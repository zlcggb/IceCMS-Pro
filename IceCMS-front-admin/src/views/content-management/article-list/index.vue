<template>
  <div>
  <el-dialog
    v-model="dialogVisible"
    title="添加新文章"
    width="500px"
    :before-close="handleClose"
  >
    <el-form :model="articleForm">
      <el-form-item label="标题" required :rules="[{ required: true, message: 'Please input the article title', trigger: 'blur' }]">
        <el-input v-model="articleForm.title"></el-input>
      </el-form-item>
      <el-form-item label="作者" required :rules="[{ required: true, message: 'Please input the author name', trigger: 'blur' }]">
        <el-input v-model="articleForm.author"></el-input>
      </el-form-item>
      <el-form-item label="发布日期">
        <el-date-picker v-model="articleForm.publishDate" type="date" placeholder="Choose the date"></el-date-picker>
      </el-form-item>
      <el-form-item label="图片地址">
        <el-input v-model="articleForm.image"></el-input>
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
  <el-dialog
    v-model="editDialogVisible"
    title="Edit Article"
    width="500px"
    :before-close="handleCloseEdit"
  >
    <el-form :model="editArticleForm">
      <el-form-item label="Title" required :rules="[{ required: true, message: 'Please input the article title', trigger: 'blur' }]">
        <el-input v-model="editArticleForm.title"></el-input>
      </el-form-item>
      <el-form-item label="Author" required :rules="[{ required: true, message: 'Please input the author name', trigger: 'blur' }]">
        <el-input v-model="editArticleForm.author"></el-input>
      </el-form-item>
      <el-form-item label="Publish Date">
        <el-date-picker v-model="editArticleForm.publishDate" type="date" placeholder="Choose the date"></el-date-picker>
      </el-form-item>
      <el-form-item label="Image URL">
        <el-input v-model="editArticleForm.image"></el-input>
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
    <el-table :data="filteredArticles" style="width: 100%" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column label="图片" width="100">
        <template #default="scope">
          <el-image style="width: 50px; height: 50px" :src="scope.row.image" fit="cover"></el-image>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column prop="title" label="标题"></el-table-column>
      <el-table-column prop="author" label="作者"></el-table-column>
      <el-table-column prop="publishDate" label="发布日期"></el-table-column>
      <el-table-column label="操作" width="180">
        <template #default="scope">
      <el-button type="primary" plain size="small" @click="editArticle(scope.row)">修改</el-button>
<el-button type="danger" plain size="small" @click="confirmDeleteArticle(scope.row.id)">删除</el-button>  </template>
      </el-table-column>
    </el-table>
  </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { ElMessageBox, ElNotification } from 'element-plus';
import type { Article } from './types';

const dialogVisible = ref(false);
const searchQuery = ref('');
const selectedArticles = ref<Article[]>([]);
const articles = ref<Article[]>([
  {
    id: 1,
    title: 'Vue 3.0 Officially Released',
    author: 'Evan You',
    publishDate: '2020-09-18',
    image: 'https://pic1.zhimg.com/50/v2-f87af36e5ac9e7515f79b0bee08c094e_200x0.jpg',
  },
  // Add more articles as needed...
]);

const editDialogVisible = ref(false);
const editArticleForm = ref({
  id: 0,
  title: '',
  author: '',
  publishDate: '',
  image: '',
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

const updateArticle = () => {
  const index = articles.value.findIndex(article => article.id === editArticleForm.value.id);
  if (index !== -1) {
    articles.value[index] = { ...editArticleForm.value };
    editDialogVisible.value = false;
    ElNotification({
      title: 'Success',
      message: 'Article updated successfully',
      type: 'success',
    });
  }
};

const articleForm = ref({
  title: '',
  author: '',
  publishDate: '',
  image: '',
});

const handleClose = (done: () => void) => {
  ElMessageBox.confirm('Are you sure to close this dialog?')
    .then(() => done())
    .catch(() => {});
};

const showAddArticleDialog = () => {
  articleForm.value = { title: '', author: '', publishDate: '', image: '' }; // Reset form
  dialogVisible.value = true;
};

const submitArticle = () => {
  const newArticle: Article = {
    id: Math.max(0, ...articles.value.map(a => a.id)) + 1,
    ...articleForm.value,
    publishDate: articleForm.value.publishDate || new Date().toISOString().slice(0, 10),
  };
  articles.value.push(newArticle);
  dialogVisible.value = false;
  ElNotification({
    title: 'Success',
    message: 'Article added successfully',
    type: 'success',
  });
};

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
    .catch(() => {});
};

const confirmDeleteArticle = (articleId: number) => {
  ElMessageBox.confirm('Are you sure to delete this article?')
    .then(() => {
      const index = articles.value.findIndex(article => article.id === articleId);
      if (index !== -1) {
        articles.value.splice(index, 1);
        ElNotification({
          title: 'Deleted',
          message: 'Article deleted successfully',
          type: 'success',
        });
      }
    })
    .catch(() => {});
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
