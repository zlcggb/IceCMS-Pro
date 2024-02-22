package com.ttice.icewkment.controller.backend;

import com.ttice.icewkment.commin.lang.Result;
import com.ttice.icewkment.entity.AllTag;
import com.ttice.icewkment.mapper.AllTagMapper;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@io.swagger.annotations.Api(tags = "后台标签接口")
@RestController
@RequestMapping("/Tag")
public class AllTagController {

  @Autowired private AllTagMapper allTagMapper;

  @ApiOperation(value = "获取全部tag")
  @GetMapping("/getAllTag")
  public Result getAllTag() {
    return Result.succ(allTagMapper.selectList(null));
  }

  @ApiOperation(value = "修改标签")
  @RequiresAuthentication // 需要登陆认证的接口
  @ApiImplicitParam(name = "setting", value = "设置", required = true)
  @PostMapping("/setSTag")
  public Result setSTag(@RequestBody AllTag allTag) {
    return Result.succ(allTagMapper.updateById(allTag));
  }

  @ApiOperation(value = "新增单个标签")
  @RequiresAuthentication // 需要登陆认证的接口
  @ApiImplicitParam(name = "setting", value = "设置", required = true)
  @PostMapping("/addSTag")
  public Result addSTag(@RequestBody AllTag Tag) {
    return Result.succ(allTagMapper.insert(Tag));
  }
}
