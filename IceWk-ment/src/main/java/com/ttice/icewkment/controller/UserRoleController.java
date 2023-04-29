package com.ttice.icewkment.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ttice.icewkment.commin.vo.UserNameVO;
import com.ttice.icewkment.entity.Role;
import com.ttice.icewkment.entity.User;
import com.ttice.icewkment.mapper.RoleMapper;
import com.ttice.icewkment.mapper.UserMapper;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@io.swagger.annotations.Api(tags = "用户角色信息接口")
@RestController
@RequestMapping("/UserRole")
public class UserRoleController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @ApiOperation(value = "获取全部角色信息")
    @GetMapping("/getAllUserRole")
    public List<Role> getAllUserRole(){
        QueryWrapper<Role> Rolewrapper = new QueryWrapper<>();
        Rolewrapper.select();
        return roleMapper.selectList(Rolewrapper);
    }

    @ApiOperation(value = "获取全部用户名称")
    @GetMapping("/getAllUserName")
    public List<UserNameVO> getAllUserName(){
        List<UserNameVO> result = new ArrayList<>();

        QueryWrapper<User> wrapper= new QueryWrapper<User>();
        wrapper.select("username");
        UserNameVO userNameVO = null;
        List<User> users = userMapper.selectList(wrapper);
        for (User user1 : users) {
            userNameVO = new UserNameVO();
            BeanUtils.copyProperties(user1,userNameVO);
            result.add(userNameVO);
        }
        return result;
    }
}
