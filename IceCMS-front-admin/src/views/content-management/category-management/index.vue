<template>
  <el-container>
    <!-- 左侧边栏：添加新分类表单 -->
    <el-aside width="300px">
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
            <el-upload class="upload-demo" action="/upload" :show-file-list="false" :on-success="handleUploadSuccess"
              :on-remove="handleRemove">
              <el-button size="small" type="primary">点击上传</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="addCategory">添加</el-button>
            <el-button type="default" @click="resetForm">重置</el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </el-aside>

    <!-- 右侧主区域：分类列表 -->
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
              <div class="table-action-buttons">
                <el-button type="primary" plain size="small" @click="editCategory(row)">编辑</el-button>
                <el-button type="danger" plain size="small" @click="deleteCategory(row)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-main>
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
    const resetForm = () => {
      newCategory.value = { name: '', alias: '', description: '', image: '' };
    };
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

.category-form,
.category-table {
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

/* 媒体查询，适用于小屏幕设备 */
@media (max-width: 768px) {
  .el-aside {
    width: auto;
    /* 侧边栏宽度调整为自动 */
    order: 2;
    /* 调整顺序使之在列表下方显示 */
  }

  .el-main {
    order: 1;
    /* 调整顺序使之在表单上方显示 */
  }

  .el-container {
    flex-direction: column;
    /* 更改布局方向为垂直 */
  }
}


/* 重置按钮样式 */
.el-button[type="default"] {
  margin-left: 10px;
  /* 与添加按钮之间的间隔 */
  background-color: #f2f2f2;
  /* 背景色 */
  color: #333;
  /* 文字颜色 */
}

/* 表单样式调整 */
.el-form-item {
  margin-bottom: 16px;
  /* 调整表单项间隔 */
}

/* 卡片样式调整 */
.category-form,
.category-table {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  /* 添加阴影效果 */
  border-radius: 4px;
  /* 圆角边框 */
}

/* 标题样式调整 */
.card-header {
  color: #409EFF;
  /* 蓝色标题 */
  font-size: 20px;
  /* 字体大小 */
  margin-bottom: 16px;
  /* 与内容间隔 */
}

/* 添加上传按钮样式 */
.upload-demo {
  /* 添加其他样式以美化上传按钮 */
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 5px 10px;
}

/* 调整媒体查询样式 */
@media (max-width: 768px) {
  /* ...其他媒体查询样式... */
}


/* 调整操作按钮的布局 */
.table-action-buttons {
  display: flex;
  /* 启用Flex布局 */
  align-items: center;
  /* 垂直居中 */
  justify-content: flex-start;
  /* 水平起始对齐 */
  gap: 10px;
  /* 按钮间隔 */
}

/* 响应式布局调整 */
@media (max-width: 768px) {
  .table-action-buttons {
    flex-direction: column;
    /* 在小屏幕上改为垂直布局 */
  }
}</style>
