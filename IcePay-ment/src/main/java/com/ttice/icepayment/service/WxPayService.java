package com.ttice.icepayment.service;

import org.springframework.stereotype.Repository;

import java.security.GeneralSecurityException;
import java.util.Map;

@Repository
public interface WxPayService {
    Map<String, Object> nativePay(Long productId) throws Exception;

    Map<String, Object> nativePayTemp(Long productId) throws Exception;

    Map<String, Object> nativePayLogin(Long productId,Integer userid) throws Exception;

    Map<String, Object> nativePayForVipIntegralLogin(Integer price,Integer userid) throws Exception;

    Map<String, Object> nativePayForVipLogin(Integer price,Integer userid, Integer payid) throws Exception;

    void processOrder(Map<String, Object> bodyMap) throws GeneralSecurityException;

    void cancelOrder(String orderNo) throws Exception;

    String queryOrder(String orderNo) throws Exception;

    void checkOrderStatus(String orderNo) throws Exception;

    void refund(String orderNo, String reason) throws Exception;

    String queryRefund(String orderNo) throws Exception;

    void checkRefundStatus(String refundNo) throws Exception;

    void processRefund(Map<String, Object> bodyMap) throws Exception;

    String queryBill(String billDate, String type) throws Exception;

    String downloadBill(String billDate, String type) throws Exception;

    Map<String, Object> nativePayV2(Long productId, String remoteAddr) throws Exception;

}
