package com.ttice.icewkment.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import java.io.Serializable;

import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @author admin
 * @since 2022-01-13
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class DispositionCarousel implements Serializable {

  /** id */
  @TableId(type = IdType.AUTO)
  private Integer id;

  private String title;

  private String introduce;

  private String button;

  private String img;
}
