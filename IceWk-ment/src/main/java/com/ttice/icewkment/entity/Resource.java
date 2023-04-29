package com.ttice.icewkment.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * 
 * </p>
 *
 * @author admin
 * @since 2022-03-28
 */
@Data
  @EqualsAndHashCode(callSuper = false)
    public class Resource implements Serializable {

    private static final long serialVersionUID=1L;

      /**
     * id
     */
        @TableId(value = "id", type = IdType.AUTO)
      private Integer id;

      /**
     * 所厲栏目Class
     */
      private String sortClass;

      /**
     * 文章标题
     */
      private String title;
      /**
       * 价格
       */
      private String price;
      /**
       * 价格
       */
      private String resAddress;
      /**
       * 价格
       */
      private String resPassword;
      /**
       * 是否免费
       */
      private Boolean isFree;

      /**
     * 标题颜色
     */
      private String titleColor;

      /**
     * 标题大小
     */
      private String titlefontSize;

      /**
     * 标题字形
     */
      private Integer titlefontType;

      /**
     * 完整标题
     */
      private String fullTitle;

      /**
     * 副标题
     */
      private String subhead;

      /**
     * 简介
     */
      private String intro;

      /**
     * 文章内容
     */
      private String content;

      /**
     * 作者
     */
      private String author;

      /**
     * 来源
     */
      private String copyfrom;

      /**
     * 录入者
     */
      private String inputer;

      /**
     * 转向连接
     */
      private String httpUrl;

      /**
     * 关健字
     */
      private String keyword;

      /**
     * 点击数
     */
      private Integer hits;

      /**
     * 评论数
     */
      private Integer postNum;

    /**
     * 喜欢数
     */
    private Integer loveNum;

  /**
     * 是否评论
     */
      private String commentDisabled;

      /**
     * 是否顶制
     */
      private Integer ontop;

      /**
     * 是否推荐
     */
      private Integer iselite;

      /**
     * 是否删除
     */
      private Integer deleted;

      /**
     * 添加时间
     */
      @ApiModelProperty(value = "创建时间")
      @TableField(fill = FieldFill.INSERT)//创建注解::自动填充 -DEFAULT没有时，INSERT插入时
      @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
      // @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
      // 返回前端自动把Data类型转换为json类型
      private Date addTime;

      /**
     * 更新时间
     */
      @ApiModelProperty(value = "更新时间")
      @TableField(fill = FieldFill.INSERT_UPDATE)//更新注解::自动填充
      @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")//返回前端自动把Data类型转换为json类型
      private Date updateTime;

      /**
     * 生成时间
     */
      @ApiModelProperty(value = "生成时间")
      @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
      private Date createTime;

      /**
     * 最后评论时间
     */
      @ApiModelProperty(value = "最后评论时间")
      @JsonFormat(shape = JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
      private Date lastPost;

      /**
     * 重要性
     */
      private Integer ownerTag;

      /**
     * 自定义备注
     */
      private String ownerRemark;

      /**
     * htm地址
     */
      private String htmlPath;

      /**
     * 上传文件地址
     */
      private String filePath;

      /**
     * 模板地址
     */
      private String tempPath;

      /**
     * 缩略图地址
     */
      private String thumb;

      /**
       * 轮播图地址
       */
      private String carousel;

      /**
     * 生成状态
     */
      private String status;

      /**
     * 文章状态身份
     */
      private Integer articleStatus;


}
