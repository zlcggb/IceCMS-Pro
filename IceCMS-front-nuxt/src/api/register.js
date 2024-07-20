import request from '@/utils/request'

export function register(data) {
  return request({
    url: '/Websuser/Create',
    method: 'get',
    params: data
  })
}