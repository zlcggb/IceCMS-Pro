<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { Base } from "./components";
import { UploadFile, UploadRawFile, ElMessage } from 'element-plus';// import { ElUploadFile } from "element-plus/lib/el-upload/src/upload.type";
import * as ArticleAPI from "@/api/function/article";

import { useRoute } from 'vue-router';
const route = useRoute();
const articleId = ref(route.params.articleId);

onMounted(() => {
  if (articleId.value) {
    // 如果有 articleId，加载文章数据进行编辑
    console.log('articleId:', articleId.value);
  } else {
    // 如果没有 articleId，初始化为创建文章模式
  }
});

defineOptions({
  name: "Editor"
});

const tagList = ref<string[]>(["标签1", "标签2", "标签3"]); // 可选的标签列表，根据需要调整

const carouselImage = ref('');
const generateImage = ref(false); // Define generateImage variable

const { VITE_APP_BASE_API } = import.meta.env;
// 拼接环境变量和路径
const uploadUrl = ref(`${VITE_APP_BASE_API}/FileApi/updateimage`);
const uploadUrlbyTxt = computed(() => {
  return `${VITE_APP_BASE_API}/FileApi/addwatermarkimageUpload/${form.value.title}/${form.value.summary}`;
});

const formRef = ref(null);
// 表单数据对象
const form = ref({
  title: '',      // 文章标题
  author: '',     // 作者
  publishTime: '',// 发布时间
  summary: '',    // 文章简介
  category: '',   // 文章分类
  tags: [],       // 文章标签
  // 可以根据需要添加更多字段
});
// 规则
const rules = ref({
  title: [
    { required: true, message: '请输入标题', trigger: 'blur' }
  ],
  category: [
    { required: true, message: '请输入分类', trigger: 'blur' }
  ],
  // 其他规则...
});

const confirmArticle = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      // 验证通过，执行提交逻辑
      console.log('title:', form.value.title);
      fetchValueHtmlFromBase();
      console.log('content:', content.value);
      ArticleAPI.newAaticle({
        title: form.value.title,
        sortClass: form.value.category,
      })
        .then(({ code }) => {
          console.log('data:', code);
          // 处理成功
        })
        .catch(() => {
          // 处理错误
        });
    } else {
      console.log('验证失败');
      return false;
    }
  });
};


const authorList = ref([
  {
    "id": 20,
    "name": "电到"
  },
  {
    "id": 21,
    "name": "阿萨德"
  }
]);
const classList = ref([
  {
    "id": 20,
    "name": "基础教程"
  },
  {
    "id": 21,
    "name": "新手入门"
  }
]);

const baseComponentRef = ref(null);
const content = ref('');


// 当需要获取 valueHtml 时，调用这个方法
const fetchValueHtmlFromBase = () => {
  if (baseComponentRef.value) {
    const valueHtml = baseComponentRef.value.getValueHtml();
    content.value = valueHtml; // Use .value to assign a new value
  }
};


function generateImageText() {
  // Generate image text logic
  // Based on the filled title, generate image text
}

function handleCarouselImageUpload(file: UploadFile) {
  // Handle uploaded image file
}

function beforeUpload(file: UploadRawFile) {
  // console.log('file:', file);
  // Perform validation or other tasks before uploading
  return true; // Return false to prevent upload
}
const uploadFileList = ref([]);
function handleUploadSuccess(response: any, file: UploadFile) {
  // Handle upload success
  carouselImage.value = response.url; // Assuming response contains the URL of the uploaded image
}
function handleExceed(files, fileList) {
  ElMessage({
    message: '只能上传一张图片',
    type: 'warning',
    showClose: true
  });
}
</script>

<template>
  <div id="editor-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          {{ articleId ? '编辑资源' : '创建资源' }}
        </div>
        <div class="card-body">
          <Base ref="baseComponentRef" />
        </div>
        <el-form :model="form" :rules="rules" ref="formRef" label-width="80px" style="margin-top: 20px">
          <el-form-item label="标题" prop="title">
            <el-input v-model="form.title" placeholder="请输入标题"></el-input>
          </el-form-item>
          <el-form-item label="作者">
            <el-select v-model="form.author" placeholder="请选择作者">
              <el-option v-for="item in authorList" :key="item.id" :label="item.name" :value="item.id">
              </el-option>
            </el-select> </el-form-item>
          <el-form-item label="发布时间">
            <el-date-picker v-model="form.publishTime" type="datetime" placeholder="请选择发布时间"></el-date-picker>
          </el-form-item>
          <el-form-item label="简介">
            <el-input v-model="form.summary" type="textarea" placeholder="请输入简介"></el-input>
          </el-form-item>
          <el-form-item label="分类" prop="category">
            <el-select v-model="form.category" placeholder="请选择分类">
              <el-option v-for="item in classList" :key="item.id" :label="item.name" :value="item.id">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="标签">
            <el-select v-model="form.tags" multiple filterable allow-create default-first-option placeholder="请输入标签">
              <el-option v-for="item in tagList" :key="item" :label="item" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="图片文字">
            <el-switch v-model="generateImage" active-color="#13ce66" inactive-color="#ff4949">生成图片文字</el-switch>
            <!-- <span v-if="generateImage">{{ carouselImage }}</span> -->
          </el-form-item>
          <el-form-item v-if="!generateImage" label="主图上传">
            <el-upload class="upload-demo" :action="uploadUrl" name="editormd-image-file"
              :on-success="handleUploadSuccess" :before-upload="beforeUpload" @exceed="handleExceed" :limit="1" drag
              multiple list-type="picture-card">
              <i class="el-icon-plus"></i>
              <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
              <!-- <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div> -->
            </el-upload>
          </el-form-item>
          <el-form-item v-else label="主图上传">
            <el-upload class="upload-demo" :action="uploadUrlbyTxt" name="editormd-image-file"
              :on-success="handleUploadSuccess" :before-upload="beforeUpload" @exceed="handleExceed" :limit="1" drag
              multiple list-type="picture-card">
              <i class="el-icon-plus"></i>
              <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
              <!-- <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div> -->
            </el-upload>
          </el-form-item>
          <!-- 其他表单项 -->
        </el-form>
      </template>
      <!-- Confirmation button -->
      <div class="confirmation-button">
        <el-button type="primary" @click="confirmArticle">确认</el-button>
      </div>
    </el-card>


  </div>
</template>

<style lang="scss" scoped>
#editor-container {
  max-width: 800px;
  margin: 0 auto;
}

.card-header {
  padding: 15px;
  border-bottom: 1px solid #ebeef5;
  background-color: #409EFF;
  /* 背景色 */
  font-size: 24px;
  /* 字体大小 */
  font-weight: bold;
  /* 字体加粗 */
  color: #ffffff;
  /* 字体颜色 */
  text-align: center;
  /* 文本居中 */
  border-radius: 5px;
  /* 圆角 */
  margin-bottom: 20px;
  /* 底部外边距 */
}

.el-collapse-item__header {
  padding-left: 10px;
}
</style>

<style lang="scss" scoped>
#editor-container {
  max-width: 800px;
  margin: 0 auto;
}

.el-collapse-item__header {
  padding-left: 10px;
}

.confirmation-button {
  margin-top: 20px;
  text-align: right;
  /* Align the button to the right */
}

.confirmation-button .el-button {
  margin-left: 10px;
  /* Add some space between the button and other elements */
}

.card-body {
  border-bottom: 1px solid #ebeef5;
  /* 添加边框作为分割线 */
  padding-bottom: 15px;
  /* 添加一些内边距 */
  margin-bottom: 15px;
  /* 在分割线下方留出空间 */
}</style>

