<template>
  <el-container style="height: 100vh; background-color: #f3f4f6;">
    <el-main>
      <el-row gutter="20">
        <el-col :span="6">
          <el-card class="gradient-total-sales">
            <div>总销售额</div>
            <div>¥100,000</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="gradient-today-sales">
            <div>今日销售额</div>
            <div>¥10,000</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="gradient-user-count">
            <div>用户数量</div>
            <div>1,000</div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="gradient-new-orders">
            <div>新增订单</div>
            <div>50</div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 最近订单列表 -->
      <el-card class="recent-orders">
        <template #header>
          <div class="card-header">
            <span class="font-medium">最近订单列表</span>
          </div>
        </template>
        <el-table :data="recentOrders" style="width: 100%" stripe>
          <el-table-column prop="date" label="日期" width="180"></el-table-column>
          <el-table-column prop="name" label="商品名称"></el-table-column>
          <el-table-column prop="sales" label="销售量"></el-table-column>
          <el-table-column prop="amount" label="金额"></el-table-column>
        </el-table>
      </el-card>

      <!-- 用户列表 -->
      <el-card class="user-list">
        <template #header>
          <div class="card-header">
            <span class="font-medium">用户列表</span>
          </div>
        </template>
        <el-table :data="userList" style="width: 100%" stripe>
          <el-table-column prop="id" label="用户ID" width="100"></el-table-column>
          <el-table-column prop="name" label="用户名"></el-table-column>
          <el-table-column prop="email" label="邮箱"></el-table-column>
          <el-table-column prop="createdAt" label="注册时间"></el-table-column>
        </el-table>
      </el-card>
    </el-main>
  </el-container>
</template>

<script>
import { ref } from 'vue';

export default {
  name: 'AdminDashboard',
  setup() {
    const recentOrders = ref([
      { date: '2024-02-14', name: '商品1', sales: 100, amount: '¥1,000' },
      // 添加更多示例数据...
    ]);

    const userList = ref([
      { id: 1, name: 'User1', email: 'user1@example.com', createdAt: '2024-01-01' },
      // 添加更多示例数据...
    ]);

    return { recentOrders, userList };
  }
}
</script>



<style>
/* 样式 */
.gradient-total-sales {
  background: linear-gradient(to right, #ff9a9e, #fad0c4);
  color: #fff;
}

.gradient-today-sales {
  background: linear-gradient(to right, #a1c4fd, #c2e9fb);
  color: #fff;
}

.gradient-user-count {
  background: linear-gradient(to right, #b6d66c, #85d18f);
  color: #fff;
}

.gradient-new-orders {
  background: linear-gradient(to right, #f9d423, #ff4e50);
  color: #fff;
}

.recent-orders, .user-list {
  margin-top: 20px;
}
/* 
.el-card {
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.el-card__header {
  background-color: #f3f4f6;
  border-bottom: none;
  border-radius: 10px 10px 0 0;
}

.el-card__body {
  padding: 20px;
}

.el-table {
  border-radius: 10px;
} */

</style>  