package com.ttice.icewkment.controller.frontend;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ttice.icewkment.entity.Announcements;
import com.ttice.icewkment.mapper.AnnouncementsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@io.swagger.annotations.Api(tags = "Web公告接口")
@RestController
@RequestMapping("/WebAnnouncements")
public class WebAnnouncementsController {

    @Autowired
    private AnnouncementsMapper announcementsMapper;

    // @Tag - API文档标签
    @GetMapping("/getAnnouncementslist")
    public List<Announcements> getArticleClasslist() {
        return announcementsMapper.selectList(null);
    }

    // @Tag - API文档标签
    @GetMapping("/getAnnouncementslistByNum/{num}")
    public List<Announcements> getAnnouncementslistByNum(@PathVariable("num") Integer num) {
        return announcementsMapper.selectList(new QueryWrapper<Announcements>().last("limit " + num));
    }

}
