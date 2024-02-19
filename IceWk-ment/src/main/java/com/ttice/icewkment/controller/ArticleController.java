package com.ttice.icewkment.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ttice.icewkment.Util.MathUtils;
import com.ttice.icewkment.commin.lang.Result;
import com.ttice.icewkment.commin.vo.ArticlePageVO;
import com.ttice.icewkment.commin.vo.ArticleVO;
import com.ttice.icewkment.entity.Article;
import com.ttice.icewkment.entity.ArticleClass;
import com.ttice.icewkment.entity.ArticleComment;
import com.ttice.icewkment.entity.User;
import com.ttice.icewkment.mapper.ArticleClassMapper;
import com.ttice.icewkment.mapper.ArticleCommentMapper;
import com.ttice.icewkment.mapper.UserMapper;
import com.ttice.icewkment.service.ArticleCommentService;
import com.ttice.icewkment.service.ArticleService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 前端控制器
 *
 * @author admin
 * @since 2022-02-19
 */
@io.swagger.annotations.Api(tags = "后台文章管理接口")
@RestController
@RequestMapping("/article")
public class ArticleController {

  private ArticleService articleService;
  private ArticleClassMapper articleClassMapper;
  private ArticleCommentMapper articleCommentMapper;
  private UserMapper userMapper;
  private ArticleCommentService articleCommentService;

  @Autowired
  public void  ArticleSM(
          ArticleService articleService,
          ArticleClassMapper articleClassMapper,
          ArticleCommentMapper articleCommentMapper,
          UserMapper userMapper,
          ArticleCommentService articleCommentService
  ) {
    this.articleService = articleService;
    this.articleClassMapper = articleClassMapper;
    this.articleCommentMapper = articleCommentMapper;
    this.userMapper = userMapper;
    this.articleCommentService = articleCommentService;
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "新增文章(修改)")
  @ApiImplicitParam(name = "article", value = "文章", required = true)
  @PostMapping("/create")
  public Result add(@RequestBody Article article) throws ParseException {
    // 生成随机数注入
    int number = MathUtils.randomDigitNumber(7);
    article.setArticleStatus(number);
    // 查询分类名称对应的id值
    QueryWrapper<Article> wrapper = new QueryWrapper<>();
    wrapper.eq("title", article.getTitle());
    Article articleDB = articleService.getOne(wrapper);
    QueryWrapper<ArticleClass> wrapperClass = new QueryWrapper<>();
    wrapperClass.eq("id", article.getSortClass());
    ArticleClass articleClass = articleClassMapper.selectOne(wrapperClass);
    article.setSortClass(Integer.valueOf(articleClass.getId().toString()));
    if (articleDB == null) {
      articleService.save(article);
    } else {
      articleService.update(article, wrapper);
    }
    return Result.succ(article.getId());
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "根据id删除文章")
  @ApiImplicitParam(name = "id", value = "文章id", required = true)
  @GetMapping("/DelectArticleById/{id}")
  public Result DelectArticleById(@PathVariable("id") Integer id) {
    // 根据文章id删除评论
    QueryWrapper<ArticleComment> wrapper = new QueryWrapper<ArticleComment>();
    wrapper.eq("article_id", id);
    articleCommentMapper.delete(wrapper);
    return Result.succ(this.articleService.removeById(id));
  }

  // 暂时无用
  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "根据id修改文章")
  @ApiImplicitParam(name = "id", value = "文章id", required = true)
  @PostMapping("/ReviseArticleById/{id}")
  public boolean ReviseArticleById(@RequestBody Article article) {
    return this.articleService.updateById(article);
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "根据id获取文章")
  @ApiImplicitParam(name = "id", value = "文章id", required = true)
  @GetMapping("/getArticleById/{id}")
  public Article getArticleById(@PathVariable("id") Integer id) {
    Article article = articleService.getById(id);
    String sortClass = String.valueOf(article.getSortClass());
    QueryWrapper<ArticleClass> wrapper = new QueryWrapper<>();
    wrapper.eq("id", sortClass);
    ArticleClass articleClass = articleClassMapper.selectOne(wrapper);
    String name = articleClass.getName();
    Article articleBuffer = new Article();
    BeanUtils.copyProperties(article, articleBuffer);
    articleBuffer.setSortClass(Integer.valueOf(name));
    return articleBuffer;
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "获取全部文章(分页)")
  @ApiImplicitParams({
    @ApiImplicitParam(name = "page", value = "页数", required = true),
    @ApiImplicitParam(name = "limit", value = "总量", required = true)
  })
  @GetMapping("/getAllArticle/{page}/{limit}")
  public ArticlePageVO getAllArticle(
      @PathVariable("page") Integer page, @PathVariable("limit") Integer limit) {
    return this.articleService.VoList(page, limit, 0);
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "根据name获取文章")
  @ApiImplicitParam(name = "id", value = "文章name", required = true)
  @GetMapping("/getArticleByName/{name}/{page}/{limit}")
  public ArticlePageVO getArticleByName(
      @PathVariable("name") String name,
      @PathVariable("page") Integer page,
      @PathVariable("limit") Integer limit) {
    QueryWrapper<Article> wrapper = new QueryWrapper<>();
    ArticlePageVO articlePageVO = new ArticlePageVO();
    wrapper.like("title", name);
    Page<Article> articlePage = new Page<>(page, limit);

    Page<Article> resultPage = this.articleService.page(articlePage, wrapper);
    List<ArticleVO> articleVOList = ArticleToArticleVo(resultPage.getRecords());

    articlePageVO.setData(articleVOList);
    articlePageVO.setTotal(articlePage.getTotal());
    articlePageVO.setPages(articlePageVO.getPages());

    return articlePageVO;
  }

  @RequiresAuthentication // 需要登陆认证的接口
  @ApiOperation(value = "批量删除文章")
  @ApiImplicitParam(name = "arr", value = "文章id", required = true)
  @PostMapping("/DeleteArticleBatch")
  public Result DeleteArticleBatch(@RequestBody int[] arr) {
    System.out.println(arr);
    List<Integer> list = Arrays.stream(arr).boxed().collect(Collectors.toList());

    articleService.removeByIds(list);

    return Result.succ(null);
  }

  public List<ArticleVO> ArticleToArticleVo(List<Article> articleList) {
    List<ArticleVO> result = new ArrayList<>();

    for (Article article : articleList) {

      ArticleVO articleVO = null;
      // 根据作者名称查询对应的头像地址
      String author = article.getAuthor();
      User users = userMapper.searchName(author);
      String profile = users.getProfile();
      articleVO = new ArticleVO();
      articleVO.setProfile(profile);
      // 根据文章id获取对应的评论数
      Integer aid = article.getId();
      int acnum = articleCommentService.GetCommentNum(aid);
      articleVO.setCommentNum(acnum);
      // 获取对应分类
      String sortClass = String.valueOf(article.getSortClass());
      ArticleClass articleClass = articleClassMapper.selectById(sortClass);
      String classname = articleClass.getName();
      articleVO.setClassName(classname);

      BeanUtils.copyProperties(article, articleVO);
      result.add(articleVO);
    }

    return result;
  }
}
