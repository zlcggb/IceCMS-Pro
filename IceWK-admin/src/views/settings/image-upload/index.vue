<template>
  <el-card shadow="never" class="image-upload-config">
    <template #header>
      <div class="clearfix">
        <span>图片上传设置</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <el-form-item label="存储模式">
        <el-select v-model="storageMode" class="input-width" placeholder="选择存储模式">
          <el-option label="本地" value="local"></el-option>
          <el-option label="OSS" value="oss"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="图片大小限制（MB）">
        <el-input-number v-model="imageSizeLimit" class="input-width" :min="1" :max="20"></el-input-number>
      </el-form-item>
      <el-form-item label="允许的图片类型">
        <el-select v-model="allowedImageTypes" class="input-width" multiple placeholder="选择图片类型">
          <el-option label="JPEG" value="jpeg"></el-option>
          <el-option label="PNG" value="png"></el-option>
          <el-option label="GIF" value="gif"></el-option>
          <el-option label="SVG" value="svg"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="启用自动图片压缩">
        <el-switch v-model="autoCompress"></el-switch>
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

const storageMode = ref('local'); // 默认存储模式为本地
const imageSizeLimit = ref(5);
const allowedImageTypes = ref(['jpeg', 'png']);
const autoCompress = ref(true);

const saveSettings = () => {
  // 实现保存设置的逻辑
  console.log('Settings saved:', { storageMode, imageSizeLimit, allowedImageTypes, autoCompress });
};

const resetSettings = () => {
  // 实现重置设置到默认值的逻辑
  storageMode.value = 'local';
  imageSizeLimit.value = 5;
  allowedImageTypes.value = ['jpeg', 'png'];
  autoCompress.value = true;
};
</script>

<style scoped>
.input-width {
  width: 100%; /* 在移动端视图下占满宽度 */

  @media (min-width: 769px) {
    width: 35%; /* 在桌面视图下调整宽度为页面的 35% */
  }
}

.button-container {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
