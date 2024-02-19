package com.ttice.icewkment.controller;

import com.ttice.icewkment.commin.lang.Result;
import com.ttice.icewkment.entity.Panel;
import com.ttice.icewkment.service.PanelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @projectName: IceCMS-Pro-main
 * @package: com.ttice.icewkment.controller
 * @className: PanelController
 * @author: Eric
 * @description: TODO
 * @date: 2023/8/12 14:45
 * @version: 1.0
 */
@RestController
@RequestMapping("Panel")
public class PanelController {
  @Autowired private PanelService panelService;

  @GetMapping("getPanelInfo")
  public Result getPanelInfo() {
    Panel panel = panelService.SearchPanelInfo();
    return Result.succ(panel);
  }
}
