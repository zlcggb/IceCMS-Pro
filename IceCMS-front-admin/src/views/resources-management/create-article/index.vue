<script setup lang="ts">
import { ref } from "vue";
import { Base, Multi, PicUpload } from "./components";
// import { ElUploadFile } from "element-plus/lib/el-upload/src/upload.type";

defineOptions({
  name: "Editor"
});

// Define variables
const activeNames = ref("1");
const title = ref('');
const author = ref('');
const publishTime = ref('');
const summary = ref('');
const category = ref('');
const tags = ref<string[]>([]);
const carouselImage = ref('');
const generateImage = ref(false);
const paymentType = ref('free'); // Default to free
const resourceLink = ref('');
const resourcePassword = ref('');

function generateImageText() {
  // Generate image text logic
  // Based on the filled title, generate image text
}

function handleCarouselImageUpload(file: ElUploadFile) {
  // Handle uploaded image file
}

function beforeUpload(file: ElUploadFile) {
  // Perform validation or other tasks before uploading
  return true; // Return false to prevent upload
}

function handleUploadSuccess(response: any, file: ElUploadFile) {
  // Handle upload success
  carouselImage.value = response.url; // Assuming response contains the URL of the uploaded image
}
</script>

<template>
  <div id="editor-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          创建资源
                  </div>
  <div class="card-header">
                 <Base v-if="activeNames === '1'" />
                  </div>
 <el-form label-width="80px" style="margin-top: 20px">
      <el-form-item label="标题">
        <el-input v-model="title" placeholder="请输入标题"></el-input>
      </el-form-item>
      <el-form-item label="作者">
        <el-input v-model="author" placeholder="请输入作者"></el-input>
      </el-form-item>
      <el-form-item label="发布时间">
        <el-date-picker v-model="publishTime" type="datetime" placeholder="请选择发布时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="简介">
        <el-input v-model="summary" type="textarea" placeholder="请输入简介"></el-input>
      </el-form-item>
      <el-form-item label="分类">
        <el-input v-model="category" placeholder="请输入分类"></el-input>
      </el-form-item>
      <el-form-item label="标签">
        <el-input v-model="tags" placeholder="请输入标签，用逗号分隔"></el-input>
      </el-form-item>
    <el-form-item label="主图上传">
          <el-upload
            class="upload-demo"
            action="/upload"
            :on-success="handleUploadSuccess"
            :before-upload="beforeUpload"
            drag
            multiple
            list-type="picture-card">
            <i class="el-icon-plus"></i>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <!-- <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div> -->
          </el-upload>
        </el-form-item>
      <!-- 其他表单项 -->
       <el-form-item label="是否付费">
          <el-radio-group v-model="paymentType">
            <el-radio label="free">免费</el-radio>
            <el-radio label="paid">付费</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="资源链接">
          <el-input v-model="resourceLink" placeholder="请输入资源链接"></el-input>
        </el-form-item>
        <el-form-item label="资源密码">
          <el-input v-model="resourcePassword" placeholder="请输入资源密码"></el-input>
        </el-form-item>
        <!-- Video upload -->
        <el-form-item label="视频上传">
          <el-upload
            class="upload-demo"
            action="/uploadVideo"
            :on-success="handleVideoUploadSuccess"
            :before-upload="beforeVideoUpload"
            drag
            multiple
            list-type="text">
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">将视频文件拖到此处，或<em>点击上传</em></div>
          </el-upload>
        </el-form-item>
        
        <!-- Carousel image upload -->
        <el-form-item label="轮播图">
          <el-upload
            class="upload-demo"
            action="/uploadImage"
            :on-success="handleCarouselImageUpload"
            :before-upload="beforeCarouselImageUpload"
            drag
            multiple
            list-type="picture-card">
            <i class="el-icon-plus"></i>
            <div class="el-upload__text">将图片文件拖到此处，或<em>点击上传</em></div>
          </el-upload>
        </el-form-item>
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

.card-header {
  padding: 15px;
  border-bottom: 1px solid #ebeef5;
}

.el-collapse-item__header {
  padding-left: 10px;
}

.confirmation-button {
  margin-top: 20px;
  text-align: right; /* Align the button to the right */
}

.confirmation-button .el-button {
  margin-left: 10px; /* Add some space between the button and other elements */
}
</style>

