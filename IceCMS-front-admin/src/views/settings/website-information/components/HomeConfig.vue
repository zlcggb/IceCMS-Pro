<template>
  <el-card shadow="never" class="home-config">
    <template #header>
      <div class="clearfix">
        <span>首页设置</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <el-form-item label="轮播图数量限制">
        <el-input-number v-model="carouselLimit" class="input-width" :min="1" :max="10"></el-input-number>
      </el-form-item>
      <el-form-item label="特色区域内容">
        <el-input v-model="featuredContent" class="input-width" type="textarea"></el-input>
      </el-form-item>
      <el-form-item label="首页公告">
        <el-input v-model="homeAnnouncement" class="input-width" type="textarea"></el-input>
      </el-form-item>
      <el-form-item label="启用特色区域">
        <el-switch v-model="featureAreaEnabled"></el-switch>
      </el-form-item>
      <div class="button-container">
        <el-button type="primary" @click="saveSettings">保存</el-button>
        <el-button @click="resetSettings">取消</el-button>
      </div>
    </el-form>
  </el-card>
</template>

<script setup>
import { ref } from 'vue';

const carouselLimit = ref(5);
const featuredContent = ref('');
const homeAnnouncement = ref('');
const featureAreaEnabled = ref(true);

const saveSettings = () => {
  // 实现保存设置的逻辑
  console.log('Settings saved:', { carouselLimit, featuredContent, homeAnnouncement, featureAreaEnabled });
};

const resetSettings = () => {
  // 实现重置设置到默认值的逻辑
  carouselLimit.value = 5;
  featuredContent.value = '';
  homeAnnouncement.value = '';
  featureAreaEnabled.value = true;
};
</script>

<style scoped>
.input-width {
  width: 100%; /* 在移动端视图下占满宽度 */
}

@media (min-width: 769px) {
  .input-width {
    width: 35%; /* 在桌面视图下调整宽度为页面的 35% */
  }
}

.button-container {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
