package com.ttice.icewkment.controller.frontend;

import com.ttice.icewkment.entity.Announcements;
import com.ttice.icewkment.mapper.AnnouncementsMapper;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@io.swagger.annotations.Api(tags = "Web公告接口")
@RestController
@RequestMapping("/WebAnnouncements")
public class WebAnnouncementsController {

    @Autowired
    private AnnouncementsMapper announcementsMapper;

    @ApiOperation(value = "获取全部公告列表")
    @GetMapping("/getAnnouncementslist")
    public List<Announcements> getArticleClasslist() {
        return announcementsMapper.selectList(null);
    }

}
