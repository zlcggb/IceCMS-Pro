<template>
  <div>
    <el-dialog v-model="dialogVisible" title="添加新文章" width="500px" :before-close="handleClose">
      <el-form :model="articleForm">
        <el-form-item label="标题" required :rules="[{ required: true, message: '请输入标题', trigger: 'blur' }]">
          <el-input v-model="articleForm.title"></el-input>
        </el-form-item>
            <el-form-item label="分类" prop="category" required :rules="[{ required: true, message: '请选择分类', trigger: 'blur' }]">
              <el-select v-model="articleForm.sortClass" placeholder="请选择分类">
                <el-option v-for="item in classList" :key="item.id" :label="item.name" :value="item.id">
                </el-option>
              </el-select>
            </el-form-item>
        <el-form-item label="作者" required :rules="[{ required: true, message: '请输入名称', trigger: 'blur' }]">
          <el-input v-model="articleForm.author"></el-input>
        </el-form-item>
        <el-form-item label="发布日期">
          <el-date-picker v-model="articleForm.addTime" type="date" placeholder="选择日期"></el-date-picker>
        </el-form-item>
        <el-form-item label="图片地址">
          <el-input v-model="articleForm.thumb"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitArticle">确认</el-button>
        </div>
      </template>
    </el-dialog>
    <!-- 编辑文章的对话框 -->
    <el-dialog v-model="editDialogVisible" title="编辑文章" width="500px" :before-close="handleCloseEdit">
      <el-form :model="editArticleForm">
        <el-form-item label="标题" required
          :rules="[{ required: true, message: '请输入标题', trigger: 'blur' }]">
          <el-input v-model="editArticleForm.title"></el-input>
        </el-form-item>
         <el-select v-model="articleForm.sortClass" placeholder="请选择分类">
                  <el-option v-for="item in classList" :key="item.id" :label="item.name" :value="item.id">
                  </el-option>
                </el-select>
        <el-form-item label="作者" required
          :rules="[{ required: true, message: '请输入作者姓名', trigger: 'blur' }]">
          <el-input v-model="editArticleForm.author"></el-input>
        </el-form-item>
        <el-form-item label="发布时间">
          <el-date-picker v-model="editArticleForm.addTime" type="date" placeholder="选择日期"></el-date-picker>
        </el-form-item>
        <el-form-item label="图片地址">
          <el-input v-model="editArticleForm.thumb"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="editDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="updateArticle">更新</el-button>
        </div>
      </template>
    </el-dialog>
    <el-card class="box-card" shadow="never">
      <template #header>
        <div class="table-operations">
          <el-input v-model="searchQuery" placeholder="请输入查询内容" class="search-input"></el-input>
          <el-button type="success" @click="searchArticles">查询</el-button>
          <el-button type="primary" @click="showAddArticleDialog">添加</el-button>
          <el-button type="danger" @click="confirmDeleteSelected">删除选中</el-button>
        </div>
      </template>
      <el-table @row-click="handleRowClick" :data="filteredArticles" style="width: 100%"
        @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column label="图片" width="100">
          <template #default="scope">
            <el-image style="width: 90px; height: 80px" :src="scope.row.thumb" fit="contain"></el-image>
          </template>
        </el-table-column>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="title" label="标题"></el-table-column>
        <el-table-column prop="author" label="作者"></el-table-column>
        <el-table-column prop="addTime" label="发布日期"
          :formatter="(row, column, cellValue) => dayjs(cellValue).format('YYYY-MM-DD  HH:mm')"></el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button type="primary" plain size="small" @click.stop="editArticle(scope.row)"
              @click="editArticle(scope.row)">修改</el-button>
            <el-button type="danger" plain size="small" @click.stop="confirmDeleteArticle(scope.row.id)"
              @click="confirmDeleteArticle(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页组件 -->
      <div class="pagination-container">
        <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="currentPage"
          :page-sizes="[1, 2, 5, 10]" :page-size="pageSize" layout="total, sizes, prev, pager, next"
          :total="totalArticles"></el-pagination>
      </div>
    </el-card>

  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { ElMessageBox, ElNotification } from 'element-plus';
import { newAaticle, getAllArticles, createArticle, updateArticles, deleteArticle } from '@/api/function/article'; // 请确保路径正确
import type { Article } from './types';
import { useRouter } from 'vue-router'
import dayjs from 'dayjs';

const dialogVisible = ref(false);
const searchQuery = ref('');
const selectedArticles = ref<Article[]>([]);

// 引入分页所需的响应式变量
const currentPage = ref(1);
const pageSize = ref(5);
const totalArticles = ref(0);

const classList = ref([
  {
    "id": 20,
    "name": "基础教程"
  },
  {
    "id": 19,
    "name": "新手入门"
  }
]);

// 用于存储文章数据的响应式变量
const articles = ref([]);

const router = useRouter()

const handleRowClick = (row, column, event) => {
  // 检查点击的元素是否是按钮
  if (event.target.tagName === 'BUTTON') {
    // 如果是按钮，则不执行导航逻辑
    return;
  }

  // 如果不是按钮，则执行原来的导航逻辑
  // 使用Vue Router的push方法来导航到新的URL
  const newPath = '/content-management/edit-article/' + row.id
  if (router.currentRoute.value.path !== newPath) {
    router.push(newPath)
  }
}

interface ArticleResponse {
  pages: any[]; // Replace any[] with the actual type of your pages
  total: number;
  data: Article[];
}

// 分页改变时获取文章
const fetchArticles = async (pageNum = 1, limit = pageSize.value) => {
  try {
    const response = await getAllArticles(pageNum, limit) as unknown as { code: number, data: ArticleResponse };
    if (response.code === 200) {
      const res = response.data;
      articles.value = res.data;
      console.log('articles:', articles.value);
      totalArticles.value = res.total;
    }
  } catch (error) {
    console.error('Error fetching articles:', error);
  }
};

// 页面大小变化时的处理函数
const handleSizeChange = (newSize) => {
  pageSize.value = newSize;
  fetchArticles(currentPage.value, pageSize.value);
};

// 当前页面变化时的处理函数
const handleCurrentChange = (newPage) => {
  currentPage.value = newPage;
  fetchArticles(currentPage.value, pageSize.value);
};

// 页面挂载时获取文章数据
onMounted(() => {
  fetchArticles(currentPage.value, pageSize.value);
});

// 页面挂载时获取文章数据
onMounted(fetchArticles);

// 添加文章
const submitArticle = async () => {
  try {
    await createArticle(articleForm.value);
    fetchArticles(); // 重新获取文章列表
    dialogVisible.value = false;
    ElNotification({
      title: '成功',
      message: '文章添加成功',
      type: 'success',
    });
  } catch (error) {
    console.error('Error submitting article:', error);
  }
};

// 更新文章
const updateArticle = async () => {
  try {
    // await updateArticle(editArticleForm.value);
    fetchArticles(); // 重新获取文章列表
    editDialogVisible.value = false;
    ElNotification({
      title: 'Success',
      message: 'Article updated successfully',
      type: 'success',
    });
  } catch (error) {
    console.error('Error updating article:', error);
  }
};

// 删除文章
const confirmDeleteArticle = async (articleId) => {
  try {
    await deleteArticle(articleId);
    fetchArticles(); // 重新获取文章列表
    ElNotification({
      title: 'Deleted',
      message: 'Article deleted successfully',
      type: 'success',
    });
  } catch (error) {
    console.error('Error deleting article:', error);
  }
};

const editDialogVisible = ref(false);
const editArticleForm = ref({
  id: 0,
  title: '',
  author: '',
  addTime: '',
  thumb: '',
});

const articleForm = ref({
  title: '',
  sortClass: '',
  author: '',
  addTime: '',
  thumb: '',
});

const handleCloseEdit = (done: () => void) => {
  // 可以根据需要定制关闭编辑对话框前的逻辑
  done();
};
// 定义 searchArticles
const searchArticles = () => {
  // 搜索文章的逻辑
}
const editArticle = (article: Article) => {
  editArticleForm.value = { ...article };
  editDialogVisible.value = true;
};

// const updateArticle = () => {
//   const index = articles.value.findIndex(article => article.id === editArticleForm.value.id);
//   if (index !== -1) {
//     articles.value[index] = { ...editArticleForm.value };
//     editDialogVisible.value = false;
//     ElNotification({
//       title: 'Success',
//       message: 'Article updated successfully',
//       type: 'success',
//     });
//   }
// };



const handleClose = (done: () => void) => {
  ElMessageBox.confirm('你确定要关闭此页面?')
    .then(() => done())
    .catch(() => { });
};

const showAddArticleDialog = () => {
  articleForm.value = { title: '', author: '', addTime: '', thumb: '', sortClass: '' }; // Reset form
  dialogVisible.value = true;
};

// const submitArticle = () => {
//   const newArticle: Article = {
//     id: Math.max(0, ...articles.value.map(a => a.id)) + 1,
//     ...articleForm.value,
//     publishDate: articleForm.value.publishDate || new Date().toISOString().slice(0, 10),
//   };
//   articles.value.push(newArticle);
//   dialogVisible.value = false;
//   ElNotification({
//     title: 'Success',
//     message: 'Article added successfully',
//     type: 'success',
//   });
// };

const filteredArticles = computed(() => {
  return articles.value.filter(article => article.title.includes(searchQuery.value));
});

const handleSelectionChange = (val: Article[]) => {
  selectedArticles.value = val;
};

const confirmDeleteSelected = () => {
  if (selectedArticles.value.length === 0) {
    ElNotification({
      title: 'No Selection',
      message: 'No articles selected',
      type: 'warning',
    });
    return;
  }
  ElMessageBox.confirm('Are you sure to delete selected articles?')
    .then(() => {
      const idsToDelete = new Set(selectedArticles.value.map(a => a.id));
      articles.value = articles.value.filter(article => !idsToDelete.has(article.id));
      selectedArticles.value = [];
      ElNotification({
        title: 'Deleted',
        message: 'The selected articles have been deleted',
        type: 'success',
      });
    })
    .catch(() => { });
};

// const confirmDeleteArticle = (articleId: number) => {
//   ElMessageBox.confirm('Are you sure to delete this article?')
//     .then(() => {
//       const index = articles.value.findIndex(article => article.id === articleId);
//       if (index !== -1) {
//         articles.value.splice(index, 1);
//         ElNotification({
//           title: 'Deleted',
//           message: 'Article deleted successfully',
//           type: 'success',
//         });
//       }
//     })
//     .catch(() => { });
// };
</script>

<style scoped>
.box-card {
  margin: 20px;
}

.table-operations {
  margin-bottom: 20px;
}

.search-input {
  width: 300px;
  margin-right: 10px;
}

.dialog-footer {
  text-align: right;
}
</style>


<style scoped>
.box-card {
  margin: 20px;
}

.table-operations {
  margin-bottom: 20px;
}

.search-input {
  width: 300px;
  margin-right: 10px;
}

/* 添加的样式 */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}

.float-left {
  float: left;
}

.box-card {
  margin: 20px;
}

.table-operations {
  margin-bottom: 20px;
}

.search-input {
  width: 300px;
  margin-right: 10px;
}
</style>
<style scoped>
/* 分页容器样式 */
.pagination-container {
  text-align: right;
  margin-top: 10px;
  margin-bottom: 40px;
}

:deep(.el-pager li) {
  width: 40px;
  height: 40px;
  background-color: #ffffff;
  color: #85899c;
  border: 0.1px solid rgba(255, 255, 255, 0.2);
  border-radius: 5px;
  margin-right: 10px;
}

:deep(.btn-prev) {
  width: 40px;
  height: 40px;
  background-color: #ffffff;
  color: #4D84EA;
  border: 1px solid rgba(21, 158, 255, 0.2);
  border-radius: 6px;
  margin-right: 15px;
  font-size: 20px;
}

:deep(.btn-next) {
  width: 40px;
  height: 40px;
  background-color: #ffffff;
  color: #4D84EA;
  border: 1px solid rgba(21, 158, 255, 0.2);
  border-radius: 6px;
  margin-left: 5px;
}

:deep(.el-pager li.is-active) {
  background-color: #409EFF;
  color: #ffffff;
  border: 1px solid #409EFF;
  border-radius: 6px;
}

:deep(.el-pagination) {
  float: right;
}
</style>
