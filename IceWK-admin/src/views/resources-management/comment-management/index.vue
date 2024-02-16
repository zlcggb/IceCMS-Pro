<template>
  <div>
    <el-dialog
      v-model="dialogVisible"
      title="Add New Comment"
      width="500px"
      :before-close="handleClose"
    >
      <el-form :model="commentForm">
        <el-form-item label="Content" required :rules="[{ required: true, message: 'Please input the comment content', trigger: 'blur' }]">
          <el-input v-model="commentForm.content" type="textarea"></el-input>
        </el-form-item>
        <el-form-item label="Author" required :rules="[{ required: true, message: 'Please input the author name', trigger: 'blur' }]">
          <el-input v-model="commentForm.author"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="submitComment">Confirm</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog
      v-model="editDialogVisible"
      title="Edit Comment"
      width="500px"
      :before-close="handleCloseEdit"
    >
      <el-form :model="editCommentForm">
        <el-form-item label="Content" required :rules="[{ required: true, message: 'Please input the comment content', trigger: 'blur' }]">
          <el-input v-model="editCommentForm.content" type="textarea"></el-input>
        </el-form-item>
        <el-form-item label="Author" required :rules="[{ required: true, message: 'Please input the author name', trigger: 'blur' }]">
          <el-input v-model="editCommentForm.author"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="updateComment">Update</el-button>
        </div>
      </template>
    </el-dialog>

    <el-card class="box-card" shadow="never">
      <template #header>
        <div class="table-operations">
          <el-button type="primary" @click="showAddCommentDialog">Add Comment</el-button>
        </div>
      </template>
      <el-table :data="comments" style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="content" label="Content"></el-table-column>
        <el-table-column prop="author" label="Author"></el-table-column>
        <el-table-column label="Actions" width="180">
          <template #default="scope">
            <el-button type="primary" plain size="small" @click="editComment(scope.row)">Edit</el-button>
            <el-button type="danger" plain size="small" @click="confirmDeleteComment(scope.row.id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { ElMessageBox, ElNotification } from 'element-plus';
import type { Comment } from './types';

const dialogVisible = ref(false);
const comments = ref<Comment[]>([
  {
    id: 1,
    content: 'This is a comment',
    author: 'John Doe',
    publishDate: new Date(), // add this line
    image: 'path/to/image.jpg', // and this line
  },
  // Add more comments as needed...
]);

const editDialogVisible = ref(false);
const editCommentForm = ref({
  id: 0,
  content: '',
  author: '',
});
const handleCloseEdit = (done: () => void) => {
  done();
};

const editComment = (comment: Comment) => {
  editCommentForm.value = { ...comment };
  editDialogVisible.value = true;
};

const updateComment = () => {
  const index = comments.value.findIndex(comment => comment.id === editCommentForm.value.id);
  if (index !== -1) {
    comments.value[index] = { 
      ...comments.value[index], 
      ...editCommentForm.value 
    };
    editDialogVisible.value = false;
    ElNotification({
      title: 'Success',
      message: 'Comment updated successfully',
      type: 'success',
    });
  }
};

const commentForm = ref({
  content: '',
  author: '',
});

const handleClose = (done: () => void) => {
  done();
};

const showAddCommentDialog = () => {
  commentForm.value = { content: '', author: '' }; // Reset form
  dialogVisible.value = true;
};

const submitComment = () => {
  const newComment: Comment = {
    id: Math.max(0, ...comments.value.map(c => c.id)) + 1,
    ...commentForm.value,
  };
  comments.value.push(newComment);
  dialogVisible.value = false;
  ElNotification({
    title: 'Success',
    message: 'Comment added successfully',
    type: 'success',
  });
};

const confirmDeleteComment = (commentId: number) => {
  ElMessageBox.confirm('Are you sure to delete this comment?')
    .then(() => {
      const index = comments.value.findIndex(comment => comment.id === commentId);
      if (index !== -1) {
        comments.value.splice(index, 1);
        ElNotification({
          title: 'Deleted',
          message: 'Comment deleted successfully',
          type: 'success',
        });
      }
    })
    .catch(() => {});
};
</script>

<style scoped>
.box-card {
  margin: 20px;
}
.table-operations {
  margin-bottom: 20px;
}
.dialog-footer {
  text-align: right;
}
</style>