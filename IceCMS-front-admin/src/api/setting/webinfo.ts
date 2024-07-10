import { http } from "@/utils/http";

// 获取设置信息
export const getSettingInfo = () => {
  return http.request<ResponseData<[]>>("post", "/Sitting/getSetting");
};

// 修改设置信息
export const setSettingInfo = (data: object) => {
  return http.request<ResponseData<[]>>("post", "/Sitting/setSetting", { data });
};

// 获取轮播图
export const getAllDispositionCarousel = (data: object) => {
  return http.request<ResponseData<[]>>("get", "/Sitting/getAllDispositionCarousel", { data });
};