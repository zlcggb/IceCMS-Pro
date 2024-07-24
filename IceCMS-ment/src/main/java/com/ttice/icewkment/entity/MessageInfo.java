package com.ttice.icewkment.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("s_message_info")
public class MessageInfo  implements Serializable {

    private Integer id;

    private String qiniuAccessKey;

    private String qiniuSecretKey;

    private String qiniuTemplateId;

}
