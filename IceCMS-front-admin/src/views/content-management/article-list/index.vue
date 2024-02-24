<template>
  <div>
    <el-dialog v-model="dialogVisible" title="添加新文章" width="500px" :before-close="handleClose">
      <el-form :rules="rules" :model="articleForm">
        <el-form-item label="标题" prop="title">
          <el-input v-model="articleForm.title"></el-input>
        </el-form-item>
        <el-form-item label="分类" prop="sortClass">
          <el-select v-model="articleForm.sortClass" placeholder="请选择分类">
            <el-option v-for="item in classList" :key="item.id" :label="item.name" :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="作者" prop="author">
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
      <el-form :rules="rules" :model="editArticleForm">
        <el-form-item label="标题" prop="title">
          <el-input v-model="editArticleForm.title"></el-input>
        </el-form-item>
        <el-form-item label="分类" prop="sortClass">
          <el-select v-model="articleForm.sortClass" placeholder="请选择分类">
            <el-option v-for="item in classList" :key="item.id" :label="item.name" :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="作者" prop="author">
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
        <el-table-column prop="title" label="标题">
             <template #default="scope">
          <a class="article-link">{{ scope.row.title }}</a>
        </template>
        </el-table-column>
    <el-table-column prop="author" label="作者">
      <template #default="scope">
        <div class="author-container">
          <span>{{ scope.row.author }}</span>
          <el-avatar :src="scope.row.profile" size="small"></el-avatar>
        </div>
      </template>
    </el-table-column>
        <el-table-column prop="className" label="分类">
        </el-table-column>

        <el-table-column prop="addTime" label="发布日期"
          :formatter="(row, column, cellValue) => dayjs(cellValue).format('YYYY-MM-DD  HH:mm')"></el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button type="primary" plain size="small" @click.stop="editArticle(scope.row)"
              @click="editArticle(scope.row)">编辑</el-button>
            <el-button type="danger" plain size="small" @click.stop="confirmDeleteArticle(scope.row.id)">删除</el-button>
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
import { deleteArticlesBatch, getAllArticles, createArticle, updateArticles, deleteArticle } from '@/api/function/article'; // 请确保路径正确
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

// 规则
const rules = ref({
  title: [
    { required: true, message: '请输入标题', trigger: 'blur' }
  ],
  sortClass: [
    { required: true, message: '请输入分类', trigger: 'blur' }
  ],
  author: [
    { required: true, message: '请输入作者', trigger: 'blur' }
  ],
  // 其他规则...
});

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
    // 先复制 articleForm 的内容
    const formData = { ...editArticleForm.value };

    // 格式化日期字段
    if (formData.addTime) {
      formData.addTime = dayjs(formData.addTime).format('YYYY-MM-DD HH:mm:ss');
    }
    await updateArticles(formData, editArticleForm.value.id);
    fetchArticles(); // 重新获取文章列表
    editDialogVisible.value = false;
    ElNotification({
      title: '成功',
      message: '文章更新成功',
      type: 'success',
    });
  } catch (error) {
    console.error('Error updating article:', error);
  }
};

// 删除文章
const confirmDeleteArticle = async (articleId) => {
  // 弹出确认框
  ElMessageBox.confirm('你确定要删除此文章吗?')
    .then(() => {
      // 如果用户点击了确认按钮
      try {
        deleteArticle(articleId);
        fetchArticles(); // 重新获取文章列表
        ElNotification({
          title: '删除文章',
          message: '文章删除成功',
          type: 'success',
        });
      } catch (error) {
        console.error('Error deleting article:', error);
      }
    })
    .catch(() => {
      // 如果用户点击了取消按钮
      ElNotification({
        title: '取消删除',
        message: '文章未被删除',
        type: 'info',
      });
    });
};

const editDialogVisible = ref(false);
const editArticleForm = ref({
  id: 0,
  title: '',
  author: '',
  addTime: '',
  className: '',
  thumb: '',
});

const articleForm = ref({
  title: '',
  sortClass: '',
  author: '',
  addTime: '',
  className: '',
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

const handleClose = (done: () => void) => {
  ElMessageBox.confirm('你确定要关闭此页面?')
    .then(() => done())
    .catch(() => { });
};

const showAddArticleDialog = () => {
  articleForm.value = { title: '', author: '', className: '', addTime: '', thumb: '', sortClass: '' }; // Reset form
  dialogVisible.value = true;
};

const filteredArticles = computed(() => {
  return articles.value.filter(article => article.title.includes(searchQuery.value));
});

const handleSelectionChange = (val: Article[]) => {
  selectedArticles.value = val;
};

const confirmDeleteSelected = async () => {
  if (selectedArticles.value.length === 0) {
    ElNotification({
      title: '没有选择文章',
      message: '请选择要删除的文章',
      type: 'warning',
    });
    return;
  }

  try {
    await ElMessageBox.confirm('你确定要删除此文章吗?');

    // Extract IDs of selected articles
    const idsToDelete = selectedArticles.value.map(a => a.id);

    // Call the API to delete articles
    const response = await deleteArticlesBatch(idsToDelete);

    // Check if deletion was successful based on your API response structure
    if (response.code === 200) {
      // Filter out deleted articles from the articles array
      fetchArticles(); // 重新获取文章列表
      selectedArticles.value = [];

      ElNotification({
        title: '删除成功',
        message: '成功删除文章',
        type: 'success',
      });
    } else {
      // Handle unsuccessful deletion
      ElNotification({
        title: '失败',
        message: '删除文章失败',
        type: 'error',
      });
    }
  } catch (error) {
    // Handle cancellation or error
    console.error('Deletion cancelled or failed:', error);
  }
};
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
/* 调整作者信息和头像的样式 */
.author-container {
  display: flex;
  align-items: center; /* 垂直居中 */
  gap: 10px; /* 文字和头像之间的距离 */
}

/* Remove the empty ruleset */
  /* 可以添加更多样式来调整文字显示 */
/* } */
</style>
