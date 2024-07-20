import request from '@/utils/request'

export function login(data) {
  return request({
    url: '/Websuser/login',
    method: 'post',
    params: data
  })
}
export function WeChatLogin(data) {
  return request({
    url: '/Websuser/WeChatLogin',
    method: 'post',
    params: data
  })
}
export function WeChatLoginCheck(accountId) {
  return request({
    url: 'Websuser/WeChatLoginCheck/' + accountId,
    method: 'post'
  })
}

export function Messagelogin(phone) {
  return request({
    url: '/Websuser/Messagelogin/'+ phone ,
    method: 'post'
  })
}

export function MessageloginCheck(phone,code) {
  return request({
    url: '/Websuser/MessageloginCheck/'+ phone +'/' + code,
    method: 'post'
  })
}