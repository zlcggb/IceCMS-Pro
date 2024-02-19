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
public class CosInfo implements Serializable {

    private Integer id;

    private String cosIntage;

    private String cosBucketName;

    private String cosSecretId;

    private String cosSecretKey;

    private String cosClientConfig;
}
