package com.ttice.icepayment.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ttice.icepayment.entity.OrderInfo;
import com.ttice.icepayment.enums.OrderStatus;
import com.ttice.icepayment.service.OrderInfoService;
import com.ttice.icepayment.vo.R;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.sql.Wrapper;
import java.util.List;

@CrossOrigin // 开放前端的跨域访问
@io.swagger.annotations.Api(tags = "商品订单管理")
@RestController
@RequestMapping("/Pay-api/order-info")
public class OrderInfoController {

  @Resource private OrderInfoService orderInfoService;

  // 商城信息接口，提供三个数据分别是总销售额，今日销售额，和今日新增订单
    @ApiOperation("商城信息")
    @GetMapping("/info")
    public R info() {
      // 实现orderInfoService.countToday()方法在controller内获取今日销售而不是在service内获取用wripper
      // 获取今日日期
      // 获取今日销售额
        // 获取今日新增订单
        return R.ok().data("total", orderInfoService.countSales())
                .data("today", orderInfoService.countToday())
                .data("newOrder", orderInfoService.countNewOrder());
    }

  @ApiOperation("订单列表")
  @GetMapping("/list")
  public R list() {
    List<OrderInfo> list = orderInfoService.listOrderByCreateTimeDesc();
    return R.ok().data("list", list);
  }

  @ApiOperation("订单列表(分页)")
  @GetMapping("/listByPage/{page}/{limit}")
  public R list(@PathVariable Integer page, @PathVariable Integer limit) {
    Page<OrderInfo> pageParam = new Page<>(page, limit);
    // 根据create_time逆序输出wrapper .orderByDesc("add_time");
    QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
    wrapper.orderByDesc("create_time");
    IPage<OrderInfo> pageModel = orderInfoService.page(pageParam, wrapper );
    long total = pageModel.getTotal();
    List<OrderInfo> records = pageModel.getRecords();
      return R.ok().data("total", total).data("rows", records);
  }

  @ApiOperation("最近订单列表")
  @GetMapping("/listByPage/{limit}")
  public R list(@PathVariable Integer limit) {
      QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
      wrapper.orderByDesc("create_time");
      wrapper.last("limit " + limit);
      List<OrderInfo> list = orderInfoService.list(wrapper);
      return R.ok().data("list", list);
  }

  @ApiOperation("根据id查询订单列表")
  @GetMapping("/PaylistById/{userId}")
  public R PaylistById(@PathVariable Integer userId) {
    List<OrderInfo> list = orderInfoService.listOrderById(userId);
    return R.ok().data("list", list);
  }

  @ApiOperation("查询本地订单状态(userid和resourceid)")
  @GetMapping("/query-order-status-Bytrue/{userid}/{resourceid}")
  public R queryOrderStatusBytrue(@PathVariable String userid, @PathVariable String resourceid) {

    String orderStatus = orderInfoService.getOrderStatusBytrue(userid, resourceid);
    if (OrderStatus.SUCCESS.getType().equals(orderStatus)) {
      return R.ok().setMessage("支付成功"); // 支付成功
    }

    return R.error().setCode(101).setMessage("没有支付");
  }

  @ApiOperation("根据订单号查询本地订单状态")
  @GetMapping("/query-order-status/{orderNo}")
  public R queryOrderStatus(@PathVariable String orderNo) {

    String orderStatus = orderInfoService.getOrderStatus(orderNo);
    if (OrderStatus.SUCCESS.getType().equals(orderStatus)) {
      return R.ok().setMessage("支付成功"); // 支付成功
    }

    return R.ok().setCode(101).setMessage("支付中......");
  }
}
