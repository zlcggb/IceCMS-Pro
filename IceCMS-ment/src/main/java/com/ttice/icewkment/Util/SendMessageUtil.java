package com.ttice.icewkment.Util;

import com.qiniu.common.QiniuException;
import com.qiniu.http.Response;
import com.qiniu.sms.SmsManager;
import com.qiniu.util.Auth;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @author
 */
@Slf4j
@Component
public class SendMessageUtil {

    /**
     * 发送手机验证码
     */
    public static boolean sendMessageCheck(String templateId,String[] phone,Map<String,String> map) {

        String accessKey = "l2yQr9jVkoiWocAdF6rCCjc7qd2p0guGOOl0q6Ab";
        String secretKey = "fwTqX4lGvZxpewHxOnVCXXlSXE4mED8AARdNq9Fv";
        Auth auth = Auth.create(accessKey, secretKey);
        SmsManager smsManager = new SmsManager(auth);
        try {
            Response resp = smsManager.sendMessage(templateId, phone , map);

            if(resp.statusCode == 200){
                return true;
            }else {
                return false;
            }
        } catch (QiniuException e) {
            log.info("发生短信异常 =======================" ,e);
        }
        return false;
    }

    public boolean sendSmsCode(String phone) throws Exception {
        //存入redis
//        redisService.set(WhlConstants.Redis.MESSAGECODE_PHONE + phone, code , 60*3L);
        String templateId = "*********";
        Map<String , String> map = new HashMap<String , String>();
        //生成短信验证码(随机6位)
        UUID uuid = UUID.randomUUID();

        // Convert the UUID to a string and take the first 6 characters
        String accountId = uuid.toString().substring(0, 6);
        map.put("code",accountId);
        boolean b = SendMessageUtil.sendMessageCheck(templateId, new String[]{phone}, map);
        System.out.println("============="+b);
        return b;
    }
}
