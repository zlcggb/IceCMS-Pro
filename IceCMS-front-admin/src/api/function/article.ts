import { http } from "@/utils/http";

/**  新增文章(修改)  */
export const newAaticle = (data?: object) => {
  return http.request<ResponseData<[]>>("post", "/article/create", { data });
};
