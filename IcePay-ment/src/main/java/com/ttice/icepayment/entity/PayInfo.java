package com.ttice.icepayment.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("t_pay_info")
public class PayInfo  implements Serializable {

  @TableId(type = IdType.AUTO)
  private Integer id;

  // Alipay information

  // 支付宝app_id
  private String aliAppId;

  // 应用私钥
  private String aliPrivateKey;

  // 应用公钥
  private String aliPublicKey;

  // 支付宝公钥
  private String aliAlipayPublicKey;

  // 异步回调地址
  private String aliNotifyUrl;

  // 同步回调地址
  private String aliReturnUrl;

  // 请求支付宝服务器网关域名
  private String aliAliUrl;

  // 该笔订单允许的最晚付款时间，逾期将关闭交易
  private String aliTimeoutExpress;

  // WeChat Pay information

  // 商户号
  private String weMchId;

  // 商户API证书序列号
  private String weMchSerialNo;

  // 商户私钥文件路径
  private String wePrivateKeyPath;

  // APIv3密钥
  private String weApiV3Key;

  // APPID
  private String weAppid;

  // 微信服务器地址
  private String weDomain;

  // 接收结果通知地址
  private String weNotifyDomain;

  // APIv2密钥
  private String wePartnerKey;
}
