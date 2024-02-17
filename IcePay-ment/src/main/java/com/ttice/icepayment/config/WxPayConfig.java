package com.ttice.icepayment.config;

import cn.hutool.core.io.resource.ClassPathResource;
import com.ttice.icepayment.entity.PayInfo;
import com.ttice.icepayment.mapper.PayInfoMapper;
import com.wechat.pay.contrib.apache.httpclient.WechatPayHttpClientBuilder;
import com.wechat.pay.contrib.apache.httpclient.auth.*;
import com.wechat.pay.contrib.apache.httpclient.util.PemUtil;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.impl.client.CloseableHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.*;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.PrivateKey;
import java.util.Objects;

@Configuration
@Slf4j
@Data
public class WxPayConfig {

  public static String inputStream2Str(InputStream is) throws IOException {
    StringBuffer sb;
    BufferedReader br = null;
    try {
      br = new BufferedReader(new InputStreamReader(is));

      sb = new StringBuffer();

      String data;
      while ((data = br.readLine()) != null) {
        sb.append(data).append("\n");
      }
    } finally {
      br.close();
    }

    return sb.toString();
  }

  @Autowired private PayInfoMapper payInfoMapper; // 注入Mapper

  private String mchId;
  private String mchSerialNo;
  private String privateKeyPath;
  private String apiV3Key;
  private String appid;
  private String domain;
  private String notifyDomain;
  private String partnerKey;

  @PostConstruct
  public void init() {
    // 从数据库获取微信支付配置
    PayInfo payInfo = payInfoMapper.getAlipayConfig();
    if (payInfo != null) {
      this.mchId = payInfo.getWeMchId();
      this.mchSerialNo = payInfo.getWeMchSerialNo();
      // 此处假设 privateKey, apiV3Key, appid, domain, notifyDomain, partnerKey 等字段已经正确填充到 PayInfo 实体
      // 需要根据实际情况调整字段名
      this.apiV3Key = payInfo.getWeApiV3Key();
      this.appid = payInfo.getWeAppid();
      this.domain = payInfo.getWeDomain();
      this.notifyDomain = payInfo.getWeNotifyDomain();
      this.partnerKey = payInfo.getWePartnerKey();
      // 请在这里添加加载私钥和其他初始化代码
    } else {
      log.error("未能从数据库加载微信支付配置");
    }
  }

  private PrivateKey loadPrivateKeyFromDatabase() {
    // 从数据库获取配置
    PayInfo payInfo = payInfoMapper.getAlipayConfig();
    if (payInfo == null || payInfo.getWePrivateKeyPath() == null) {
      throw new IllegalStateException("未能从数据库加载微信支付配置或私钥为空");
    }
    // 直接使用数据库中的 PEM 格式私钥字符串来加载 PrivateKey
    return PemUtil.loadPrivateKey(
        new ByteArrayInputStream(payInfo.getWePrivateKeyPath().getBytes(StandardCharsets.UTF_8)));
  }

  // 现有的@Bean方法和其他配置保持不变
  /**
   * 获取商户的私钥文件
   *
   * @param filename
   * @return
   */
  private PrivateKey getPrivateKey(String filename) {

    try {
      return PemUtil.loadPrivateKey(new FileInputStream(filename));
    } catch (FileNotFoundException e) {
      throw new RuntimeException("私钥文件不存在", e);
    }
  }

  /**
   * 获取签名验证器
   *
   * @return
   */
  @Bean
  public ScheduledUpdateCertificatesVerifier getVerifier() throws IOException {

    log.info("获取签名验证器");

    // 从数据库加载私钥
    PrivateKey privateKey = loadPrivateKeyFromDatabase();

    // URL fileURL=this.getClass().getResource("key/"+privateKeyPath);
    // System.out.println(fileURL.getFile());

    // 本地可以，打包不行
    // String fis =
    // Objects.requireNonNull(Thread.currentThread().getContextClassLoader().getResource("key/"+privateKeyPath)).getPath();;

    // 私钥签名对象
    PrivateKeySigner privateKeySigner = new PrivateKeySigner(mchSerialNo, privateKey);

    // 身份认证对象
    WechatPay2Credentials wechatPay2Credentials =
        new WechatPay2Credentials(mchId, privateKeySigner);

    // 使用定时更新的签名验证器，不需要传入证书
    ScheduledUpdateCertificatesVerifier verifier =
        new ScheduledUpdateCertificatesVerifier(
            wechatPay2Credentials, apiV3Key.getBytes(StandardCharsets.UTF_8));

    return verifier;
  }

  /**
   * 获取http请求对象
   *
   * @param verifier
   * @return
   */
  @Bean(name = "wxPayClient")
  public CloseableHttpClient getWxPayClient(ScheduledUpdateCertificatesVerifier verifier)
      throws IOException {

    log.info("获取httpClient");

    // 从数据库加载私钥
    PrivateKey privateKey = loadPrivateKeyFromDatabase();

    WechatPayHttpClientBuilder builder =
        WechatPayHttpClientBuilder.create()
            .withMerchant(mchId, mchSerialNo, privateKey)
            .withValidator(new WechatPay2Validator(verifier));
    // ... 接下来，你仍然可以通过builder设置各种参数，来配置你的HttpClient

    // 通过WechatPayHttpClientBuilder构造的HttpClient，会自动的处理签名和验签，并进行证书自动更新
    CloseableHttpClient httpClient = builder.build();

    return httpClient;
  }

  /** 获取HttpClient，无需进行应答签名验证，跳过验签的流程 */
  @Bean(name = "wxPayNoSignClient")
  public CloseableHttpClient getWxPayNoSignClient() throws IOException {

    // 从数据库加载私钥
    PrivateKey privateKey = loadPrivateKeyFromDatabase();

    // 用于构造HttpClient
    WechatPayHttpClientBuilder builder =
        WechatPayHttpClientBuilder.create()
            // 设置商户信息
            .withMerchant(mchId, mchSerialNo, privateKey)
            // 无需进行签名验证、通过withValidator((response) -> true)实现
            .withValidator((response) -> true);

    // 通过WechatPayHttpClientBuilder构造的HttpClient，会自动的处理签名和验签，并进行证书自动更新
    CloseableHttpClient httpClient = builder.build();

    log.info("== getWxPayNoSignClient END ==");

    return httpClient;
  }
}
