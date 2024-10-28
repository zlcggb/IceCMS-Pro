package com.ttice.icewkment.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * @author admin
 * @since 2022-01-13
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class HomeSetting implements Serializable {

  /** 唯一表示uid */
  private static final long serialVersionUID = 1L;

  /** id */
  private Integer id;

  /** 标题 */
  private String featureTitle;

  /** 图标 */
  private String featureSrc;

}
