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

  private static final long serialVersionUID = 1L;

  private Integer id;

  private String featureTitle;

  private String featureSrc;

}
