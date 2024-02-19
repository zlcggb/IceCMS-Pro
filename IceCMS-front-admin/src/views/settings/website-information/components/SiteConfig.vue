<template>
  <el-card shadow="never" class="site-config">
    <template #header>
      <div class="clearfix">
        <span>网站配置</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <el-form-item label="网站标题">
        <el-input v-model="siteTitle" class="input-width"></el-input>
      </el-form-item>
      <el-form-item label="网站LOGO">
        <el-input v-model="siteLogo" class="input-width"></el-input>
      </el-form-item>
      <el-form-item label="版权信息">
        <el-input v-model="copyright" class="input-width"></el-input>
      </el-form-item>
      <el-form-item label="备案号">
        <el-input v-model="recordNumber" class="input-width"></el-input>
      </el-form-item>
      <div class="button-container">
        <el-button type="primary">保存</el-button>
        <el-button>取消</el-button>
      </div>
    </el-form>
  </el-card>
</template>

<script setup>
import { ref } from 'vue';

const siteTitle = ref('');
const siteLogo = ref('');
const copyright = ref('');
const recordNumber = ref('');
</script>

<style scoped>
.input-width {
  width: 35%; /* 默认情况下，输入框宽度为页面宽度的 35% */
}

/* 媒体查询 */
@media (max-width: 768px) {
  /* 在屏幕宽度小于或等于 768px 的设备上，输入框宽度调整为 100% */
  .input-width {
    width: 100%;
  }
}

.button-container {
  display: flex;
  justify-content: flex-end;
  gap: 10px; /* 按钮之间的间隔 */
}
</style>

