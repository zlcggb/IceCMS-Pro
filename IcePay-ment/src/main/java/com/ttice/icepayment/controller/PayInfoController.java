package com.ttice.icepayment.controller;

import com.ttice.icepayment.entity.PayInfo;
import com.ttice.icepayment.mapper.PayInfoMapper;
import com.ttice.icepayment.vo.R;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@io.swagger.annotations.Api(tags = "支付信息设置Api")
@RestController
@RequestMapping("/PayInfoApi")
public class PayInfoController {

    @Autowired private PayInfoMapper payInfoMapper;

    @ApiOperation(value = "获取pay配置")
    @GetMapping("/getPayInfo")
    public R getPayInfo() {
        return R.ok().data("list", payInfoMapper.selectOne(null));
    }

    @ApiOperation(value = "修改pay设置")
    @ApiImplicitParam(name = "setting", value = "设置", required = true)
    @PostMapping("/setPayInfo")
    public R setPayInfo(@RequestBody PayInfo payInfo) {
        return R.ok().data("list", payInfoMapper.update(payInfo, null));
    }
}
