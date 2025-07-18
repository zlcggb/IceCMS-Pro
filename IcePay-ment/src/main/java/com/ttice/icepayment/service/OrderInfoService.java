package com.ttice.icepayment.service;

import com.ttice.icepayment.entity.OrderInfo;
import com.ttice.icepayment.enums.OrderStatus;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface OrderInfoService extends IService<OrderInfo> {

  BigDecimal countToday();
  BigDecimal countSales();

  Integer countNewOrder();

  OrderInfo createOrderTempByWxResourceId(Long productId, String payMent);

  OrderInfo createOrderLoginByWxResourceId(Long productId, String payMent, Integer userid);

  OrderInfo createOrderForVipIntegralLoginByPrice(Integer price, String payMent, Integer userid);

  OrderInfo createOrderForVipLoginByPrice(
      Integer price, String payMent, Integer userid, Integer payid);

  OrderInfo createOrderTempByAliResourceId(Long productId, String payMent);

  OrderInfo createOrderLoginByAliResourceId(Long productId, String payMent, Integer userid);

  OrderInfo createOrdervipIntegralLoginByPrice(Integer price, String payMent, Integer userid);

  OrderInfo createOrdervipLoginByPrice(
      Integer price, String payMent, Integer userid, Integer payid);

  void saveCodeUrl(String orderNo, String codeUrl, String payMent);

  List<OrderInfo> listOrderByCreateTimeDesc();

  List<OrderInfo> listOrderById(Integer userId);

  void updateStatusByOrderNo(String orderNo, OrderStatus orderStatus);

  String getOrderStatus(String orderNo);

  String getOrderStatusBytrue(String userid, String resourceid);

  List<OrderInfo> getNoPayOrderByDuration(int minutes);

  OrderInfo getOrderByOrderNo(String orderNo);
}
