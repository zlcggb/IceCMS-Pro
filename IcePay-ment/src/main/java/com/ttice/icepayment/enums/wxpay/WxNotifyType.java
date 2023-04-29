package com.ttice.icepayment.enums.wxpay;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum WxNotifyType {

	/**
	 * 支付通知
	 */
	NATIVE_NOTIFY("/Pay-api/wx-pay/native/notify"),

	/**
	 * 支付通知
	 */
	NATIVE_NOTIFY_V2("/Pay-api/wx-pay-v2/native/notify"),


	/**
	 * 退款结果通知
	 */
	REFUND_NOTIFY("/Pay-api/wx-pay/refunds/notify");

	/**
	 * 类型
	 */
	private final String type;
}
