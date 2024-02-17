package com.ttice.icepayment.mapper;

import com.ttice.icepayment.entity.OrderInfo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ttice.icepayment.entity.PayInfo;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

@Repository
public interface PayInfoMapper extends BaseMapper<PayInfo> {
  // 假设每个配置都是唯一的，我们使用 LIMIT 1 来确保只获取一条记录
  @Select("SELECT * FROM t_pay_info LIMIT 1")
  PayInfo getAlipayConfig();
}
