package com.ttice.icewkment.controller.frontend;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ttice.icewkment.entity.AllTag;
import com.ttice.icewkment.mapper.AllTagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@io.swagger.annotations.Api(tags = "Web标签接口")
@RestController
@RequestMapping("/WebTag")
public class WebAllTagController {

  @Autowired private AllTagMapper allTagMapper;

  // @Tag - API文档标签
  @GetMapping("/getAllTag")
  public List<AllTag> getAllTag() {
    return allTagMapper.selectList(null);
  }

  // @Tag - API文档标签
  @GetMapping("/getTagByList/{id}")
  public AllTag getTagByList(@PathVariable("id") Integer id) {
    QueryWrapper<AllTag> wrapper = new QueryWrapper<>();
    wrapper.eq("id", id);
    return allTagMapper.selectOne(wrapper);
  }
}
