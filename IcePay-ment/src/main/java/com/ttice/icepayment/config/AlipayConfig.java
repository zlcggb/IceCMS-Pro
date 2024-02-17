package com.ttice.icepayment.config;

import javax.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import lombok.Data;
import com.ttice.icepayment.entity.PayInfo;
import com.ttice.icepayment.mapper.PayInfoMapper;

@Configuration
@Data
public class AlipayConfig {

  @Autowired private PayInfoMapper payInfoMapper;

  private String APP_ID;
  private String PRIVATE_KEY;
  private String PUBLIC_KEY;
  private String ALIPAY_PUBLIC_KEY;
  private String NOTIFY_URL;
  private String RETURN_URL;
  private String ALI_URL;
  private String TIMEOUT_EXPRESS;

  // 交易状态和返回信息的固定值
  public static final String WAIT_BUYER_PAY = "WAIT_BUYER_PAY";
  public static final String TRADE_CLOSED = "TRADE_CLOSED";
  public static final String TRADE_SUCCESS = "TRADE_SUCCESS";
  public static final String TRADE_FINISHED = "TRADE_FINISHED";
  public static final String RETURN_CODE_SUCCESS = "10000";
  public static final String RETURN_MSG_SUCCESS = "Success";

  @PostConstruct
  public void init() {
    PayInfo alipayConfig = payInfoMapper.getAlipayConfig();

    if (alipayConfig != null) {
      this.APP_ID = alipayConfig.getAliAppId();
      this.PRIVATE_KEY = alipayConfig.getAliPrivateKey();
      this.PUBLIC_KEY = alipayConfig.getAliPublicKey();
      this.ALIPAY_PUBLIC_KEY = alipayConfig.getAliAlipayPublicKey();
      this.NOTIFY_URL = alipayConfig.getAliNotifyUrl();
      this.RETURN_URL = alipayConfig.getAliReturnUrl();
      this.ALI_URL = alipayConfig.getAliAliUrl();
      this.TIMEOUT_EXPRESS = alipayConfig.getAliTimeoutExpress();
    }
  }
}
