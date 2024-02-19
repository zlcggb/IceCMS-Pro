<template>
  <el-card shadow="never" class="tag-management">
    <template #header>
      <div class="clearfix">
        <span>标签管理</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <el-form-item label="添加标签">
        <el-input v-model="newTag" placeholder="输入新标签" class="input-width"></el-input>
      </el-form-item>
      <el-form-item label="当前标签">
        <div class="tag-list">
          <el-tag
            v-for="tag in tags"
            :key="tag.id"
            closable
            @close="removeTag(tag)"
            class="tag-item"
            :style="{ backgroundColor: tag.color }"
          >{{ tag.name }}</el-tag>
        </div>
      </el-form-item>
      <div class="button-container">
        <el-button type="primary" @click="addTag">添加</el-button>
      </div>
    </el-form>
  </el-card>
</template>

<script setup>
import { ref } from 'vue';

const newTag = ref('');
const tags = ref([{ id: 1, name: '标签1', color: getRandomColor() }, { id: 2, name: '标签2', color: getRandomColor() }]);

function getRandomColor() {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

const addTag = () => {
  if (newTag.value.trim() !== '') {
    tags.value.push({ id: Date.now(), name: newTag.value.trim(), color: getRandomColor() });
    newTag.value = ''; // 清空输入框
  }
};

const removeTag = (tagToRemove) => {
  tags.value = tags.value.filter(tag => tag.id !== tagToRemove.id);
};
</script>

<style scoped>
.input-width {
  width: 100%;
}

.button-container {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.tag-item {
  padding: 6px 10px;
  border-radius: 15px;
  cursor: pointer;
  color: #fff;
}
</style>
