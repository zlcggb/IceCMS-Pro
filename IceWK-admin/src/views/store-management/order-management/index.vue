<template>
  <div class="order-list">
    <el-card shadow="never">
      <template #header>
        <div class="clearfix">
          <span>订单列表</span>
          <el-input v-model="searchQuery" class="search-input" placeholder="搜索订单"></el-input>
        </div>
      </template>
      <el-table :data="filteredOrders" border v-loading="loading">
        <el-table-column prop="orderId" label="订单编号" width="120"></el-table-column>
        <el-table-column prop="customerName" label="客户姓名"></el-table-column>
        <el-table-column prop="totalAmount" label="订单金额" width="120" align="right"></el-table-column>
        <el-table-column prop="status" label="订单状态" width="120"></el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button type="text" size="mini" @click="showOrderDetails(row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :visible.sync="dialogVisible" title="订单详情" width="30%">
      <el-descriptions :items="orderDetails" border column></el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// 模拟订单数据
const orders = ref([
  { orderId: '1001', customerName: '张三', totalAmount: 200, status: '待付款' },
  { orderId: '1002', customerName: '李四', totalAmount: 350, status: '已付款' },
  { orderId: '1003', customerName: '王五', totalAmount: 150, status: '已发货' },
  { orderId: '1004', customerName: '赵六', totalAmount: 280, status: '已完成' },
  { orderId: '1005', customerName: '钱七', totalAmount: 400, status: '已取消' }
]);

const searchQuery = ref('');
const loading = ref(false);
const dialogVisible = ref(false);
const orderDetails = ref({});

const filteredOrders = computed(() => {
  const query = searchQuery.value.toLowerCase();
  if (!query) return orders.value;
  return orders.value.filter(order => order.orderId.toLowerCase().includes(query) || order.customerName.toLowerCase().includes(query));
});

const showOrderDetails = (order) => {
  orderDetails.value = order;
  dialogVisible.value = true;
};
</script>

<style scoped>
.search-input {
  width: 200px;
  float: right;
}

.order-list {
  padding-bottom: 20px;
}
</style>
