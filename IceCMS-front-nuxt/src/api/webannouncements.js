import request from '@/utils/request'

// 获取全部公告列表
export function getAnnouncementslist() {
    return request({
      url: 'WebAnnouncements/getAnnouncementslist',
      method: 'get'
    })
  }

// 获取指定数量的公告列表
export function getAnnouncementslistByNum(num) {
  return request({
    url: 'WebAnnouncements/getAnnouncementslistByNum/' + num,
    method: 'get'
  })
}
