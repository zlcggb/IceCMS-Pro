<template>
  <el-container style="height: 100vh;">
    <el-main>
      <el-card class="category-table">
        <template #header>
          <div class="card-header">
            <span class="font-medium">分类列表</span>
          </div>
        </template>
        <el-table :data="categoryList" style="width: 100%" stripe>
          <el-table-column prop="name" label="名称"></el-table-column>
          <el-table-column prop="alias" label="别名"></el-table-column>
          <el-table-column prop="description" label="描述"></el-table-column>
          <el-table-column label="置顶">
            <template #default="{ row }">
              <el-switch v-model="row.top" @change="handleTopChange(row)"></el-switch>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template #default="{ row }">
              <el-button type="text" size="mini" @click="editCategory(row)">编辑</el-button>
              <el-button type="text" size="mini" @click="deleteCategory(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-main>
    <el-footer>
      <el-card class="category-form">
        <template #header>
          <div class="card-header">
            <span class="font-medium">添加新分类</span>
          </div>
        </template>
        <el-form label-width="80px">
          <el-form-item label="名称">
            <el-input v-model="newCategory.name"></el-input>
          </el-form-item>
          <el-form-item label="别名">
            <el-input v-model="newCategory.alias"></el-input>
          </el-form-item>
          <el-form-item label="描述">
            <el-input v-model="newCategory.description" type="textarea"></el-input>
          </el-form-item>
          <el-form-item label="分类图片">
            <el-upload
              class="upload-demo"
              action="/upload"
              :show-file-list="false"
              :on-success="handleUploadSuccess"
              :on-remove="handleRemove"
            >
              <el-button size="small" type="primary">点击上传</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="addCategory">添加</el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </el-footer>
  </el-container>
</template>

<script>
import { ref } from 'vue';

export default {
  name: 'CategoryManagement',
  setup() {
    const newCategory = ref({
      name: '',
      alias: '',
      description: '',
      image: ''
    });

    const categoryList = ref([
      { name: '分类1', alias: 'Category 1', description: '这是分类1的描述', top: false },
      { name: '分类2', alias: 'Category 2', description: '这是分类2的描述', top: true },
      // 添加更多示例数据...
    ]);

    const addCategory = () => {
      // 实现添加分类的逻辑
    };

    const editCategory = (category) => {
      // 实现编辑分类的逻辑
    };

    const deleteCategory = (category) => {
      // 实现删除分类的逻辑
    };

    const handleUploadSuccess = (response, file, fileList) => {
      // 实现上传成功后的逻辑
    };

    const handleRemove = (file, fileList) => {
      // 实现移除文件后的逻辑
    };

    const handleTopChange = (category) => {
      // 实现置顶分类的逻辑
    };

    return {
      newCategory,
      categoryList,
      addCategory,
      editCategory,
      deleteCategory,
      handleUploadSuccess,
      handleRemove,
      handleTopChange
    };
  }
}
</script>

<style>
.card-header {
  font-size: 18px;
  font-weight: bold;
}

.category-form, .category-table {
  margin: 20px;
}

.el-main {
  padding: 20px;
}

.el-footer {
  margin-top: auto;
}

.el-form-item {
  margin-bottom: 20px;
}

.upload-demo {
  display: inline-block;
  margin-left: 10px;
}
</style>
