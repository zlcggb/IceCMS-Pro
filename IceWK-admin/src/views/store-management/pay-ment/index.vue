<template>
  <el-card shadow="never" class="payment-config">
    <template #header>
      <div class="clearfix">
        <span>支付配置</span>
      </div>
    </template>
    <el-form label-position="top" class="form-container">
      <!-- 微信支付相关参数 -->
      <div class="section-title">微信支付配置</div>
       <!-- 添加分隔符 -->
      <div class="divider"></div>
      <el-form-item label="微信支付商户号">
        <el-input v-model="wxpayMchId" class="input-width" placeholder="请输入微信支付商户号"></el-input>
      </el-form-item>
      <el-form-item label="商户API证书序列号">
        <el-input v-model="wxpayMchSerialNo" class="input-width" placeholder="请输入商户API证书序列号"></el-input>
      </el-form-item>
      <el-form-item label="商户私钥文件路径">
        <el-input v-model="wxpayPrivateKeyPath" class="input-width" placeholder="请输入商户私钥文件路径"></el-input>
      </el-form-item>
      <el-form-item label="APIv3密钥">
        <el-input v-model="wxpayApiV3Key" class="input-width" placeholder="请输入APIv3密钥"></el-input>
      </el-form-item>
      <el-form-item label="APPID">
        <el-input v-model="wxpayAppid" class="input-width" placeholder="请输入APPID"></el-input>
      </el-form-item>
      <el-form-item label="微信服务器地址">
        <el-input v-model="wxpayDomain" class="input-width" placeholder="请输入微信服务器地址"></el-input>
      </el-form-item>
      <el-form-item label="接收结果通知地址">
        <el-input v-model="wxpayNotifyDomain" class="input-width" placeholder="请输入接收结果通知地址"></el-input>
      </el-form-item>
      
      <!-- 支付宝支付相关参数 -->
      <div class="section-title">支付宝支付配置</div>
       <!-- 添加分隔符 -->
      <div class="divider"></div>
      <el-form-item label="支付宝APP_ID">
        <el-input v-model="alipayAppId" class="input-width" placeholder="请输入支付宝APP_ID"></el-input>
      </el-form-item>
      <el-form-item label="支付宝应用私钥">
        <el-input v-model="alipayPrivateKey" class="input-width" placeholder="请输入支付宝应用私钥"></el-input>
      </el-form-item>
      <el-form-item label="支付宝应用公钥">
        <el-input v-model="alipayPublicKey" class="input-width" placeholder="请输入支付宝应用公钥"></el-input>
      </el-form-item>
      <el-form-item label="支付宝异步回调地址">
        <el-input v-model="alipayNotifyUrl" class="input-width" placeholder="请输入支付宝异步回调地址"></el-input>
      </el-form-item>
      <el-form-item label="支付宝同步回调地址">
        <el-input v-model="alipayReturnUrl" class="input-width" placeholder="请输入支付宝同步回调地址"></el-input>
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

const alipayConfig = ref(''); // 支付宝配置信息
const wechatPayConfig = ref(''); // 微信支付配置信息

const saveSettings = () => {
  // 实现保存设置的逻辑
  console.log('Settings saved:', { alipayConfig, wechatPayConfig });
};

const resetSettings = () => {
  // 实现重置设置到默认值的逻辑
  alipayConfig.value = '';
  wechatPayConfig.value = '';
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
.divider {
  margin: 20px 0;
  border-bottom: 1px solid #ebeef5;
}
</style>
