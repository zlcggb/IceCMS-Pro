<template>
  <div class="category-manager">
    <div class="category-form">
      <h2>添加新分类</h2>
      <input type="text" v-model="newCategory.name" placeholder="名称" />
      <input type="text" v-model="newCategory.alias" placeholder="别名" />
      <textarea v-model="newCategory.description" placeholder="描述"></textarea>
      <input type="file" v-on:change="handleImageUpload" />
      <button v-on:click="addCategory">添加新分类</button>
    </div>
    <div class="category-list">
      <h2>分类列表</h2>
      <ul>
        <li v-for="category in categories" :key="category.id">
          {{ category.name }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      newCategory: {
        name: '',
        alias: '',
        description: '',
        image: null,
      },
      categories: [],
    };
  },
  methods: {
    handleImageUpload(event) {
      this.newCategory.image = event.target.files[0];
    },
    addCategory() {
      // 这里添加代码来处理新分类的添加
    },
  },
};
</script>

<style scoped>
.category-manager {
  display: flex;
}
.category-form {
  width: 50%;
}
.category-list {
  width: 50%;
}
</style>