package com.ttice.icewkment.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class Announcements {

    /** id */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /** 公告id */
    private String title;

    /** 公告内容 */
    private String content;

    /** 公告创建时间 */
    private String created;

    /** 公告更新时间 */
    private String updated;

    /** 公告作者 */
    private String author;

    /** 公告有效值 1有效，0无效 */
    private Boolean is_active;
}
