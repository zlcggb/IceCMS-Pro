<template>
  <el-card shadow="never" class="home-config">
    <template #header>
      <div class="clearfix">
        <span>首页设置</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <!-- 轮播图管理卡片 -->
      <el-card class="box-card" shadow="never">
        <template #header>
          <div class="table-operations">
            <el-button type="primary" @click="showAddCarouselDialog">添加轮播图</el-button>
          </div>
        </template>
        <el-table :data="dispositionCarousel" style="width: 100%">
          <el-table-column prop="id" label="ID" width="80"></el-table-column>
          <el-table-column prop="img" label="图片">
            <template #default="scope">
              <img :src="scope.row.img" style="width: 100px; height: auto;" />
            </template>
          </el-table-column>
          <el-table-column prop="button" label="按钮"></el-table-column>
          <el-table-column prop="introduce" label="简介"></el-table-column>
          <el-table-column label="操作" width="180">
            <template #default="scope">
              <el-button type="primary" plain size="small" @click="editCarousel(scope.row)">编辑</el-button>
              <el-button type="danger" plain size="small" @click="confirmDeleteCarousel(scope.row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <!-- 轮播图数量限制设置 -->
      <el-form-item label="轮播图数量限制">
        <el-input-number v-model="carouselLimit" class="input-width" :min="1" :max="10"></el-input-number>
      </el-form-item>

      <!-- 启用特色区域开关 -->
      <el-form-item label="启用特色区域">
        <el-switch v-model="featureAreaEnabled"></el-switch>
      </el-form-item>

      <!-- 特色区域内容输入框 -->
      <el-form-item label="特色区域内容">
        <el-input v-model="featuredContent" class="input-width" type="textarea"></el-input>
      </el-form-item>

      <!-- 首页公告输入框 -->
      <el-form-item label="首页公告">
        <el-input v-model="homeAnnouncement" class="input-width" type="textarea"></el-input>
      </el-form-item>

      <!-- 按钮操作区 -->
      <div class="button-container">
        <el-button type="primary" @click="saveSettings">保存</el-button>
        <el-button @click="resetSettings">取消</el-button>
      </div>
    </el-form>
  </el-card>

  <!-- 添加轮播图的弹窗 -->
  <el-dialog v-model="dialogVisible" title="添加新内容" width="500px" :before-close="handleDialogClose">
    <el-form label-position="top" class="form-container" @submit.prevent="addCarousel">
      <el-form-item label="轮播图名称" :error="errors.name">
        <el-input v-model="newCarousel.name"></el-input>
      </el-form-item>
      <el-form-item label="轮播图图片链接" :error="errors.imgUrl">
        <el-input v-model="newCarousel.imgUrl"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="dialogVisible = false">取消</el-button>
      <el-button type="primary" @click="addCarousel">确定</el-button>
    </span>
  </el-dialog>
</template>

<script setup lang="ts">
import { ElMessageBox } from 'element-plus';
import { getAllDispositionCarousel } from '@/api/setting/webinfo';
import { ref, onMounted } from 'vue';

const carouselLimit = ref(5);
const featuredContent = ref('');
const homeAnnouncement = ref('');
const featureAreaEnabled = ref(true);

const dispositionCarousel = ref([]);
const dialogVisible = ref(false);
const newCarousel = ref({ name: '', imgUrl: '' });
const errors = ref({});

// 初始化网站配置
const initSiteConfig = async () => {
  try {
    const response = await getAllDispositionCarousel();
    if (response && response.data) {
      dispositionCarousel.value = response.data;
      console.log('Site config loaded:', dispositionCarousel.value);
    }
  } catch (error) {
    console.error('Error fetching site config:', error);
  }
};
onMounted(initSiteConfig);

// 添加轮播图的逻辑
const showAddCarouselDialog = () => {
  console.log('Showing add carousel dialog');
  dialogVisible.value = true;
};

const addCarousel = () => {
  // 表单验证
  errors.value = {};
  if (!newCarousel.value.name) {
    // errors.value.name = '轮播图名称不能为空';
  }
  if (!newCarousel.value.imgUrl) {
    // errors.value.imgUrl = '图片链接不能为空';
  }
  if (Object.keys(errors.value).length) return;

  console.log('Adding carousel:', newCarousel.value);
  // 可以在这里调用接口，添加新的轮播图
  // 成功后关闭弹窗，更新界面等操作
  // dispositionCarousel.value.push({ ...newCarousel.value, id: Date.now() }); // Example of adding a new item
  // dialogVisible.value = false;
  // handleDialogClose();
};

const handleDialogClose = (done: () => void) => {
  ElMessageBox.confirm('你确定要关闭此页面?')
    .then(() => done())
    .catch(() => { });
};

const editCarousel = (carousel) => {
  // 编辑轮播图的逻辑
  console.log('Editing carousel:', carousel);
};

const confirmDeleteCarousel = (carouselId) => {
  // 确认删除轮播图的逻辑
  console.log('Deleting carousel ID:', carouselId);
  dispositionCarousel.value = dispositionCarousel.value.filter(c => c.id !== carouselId);
};

const saveSettings = () => {
  console.log('Settings saved:', { carouselLimit, featuredContent, homeAnnouncement, featureAreaEnabled });
};

const resetSettings = () => {
  carouselLimit.value = 5;
  featuredContent.value = '';
  homeAnnouncement.value = '';
  featureAreaEnabled.value = true;
};
</script>

<style scoped>
.input-width {
  width: 100%;
}

@media (min-width: 769px) {
  .input-width {
    width: 35%;
  }
}

.button-container {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
