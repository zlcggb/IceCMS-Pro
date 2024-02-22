import { http } from "@/utils/http";

/**  tag(获取)  */
export const getAllTag = () => {
  return http.request<ResponseData<[]>>("get", "/Tag/getAllTag");
};

/**  tag(修改)  */
export const setSTag = (data?: object) => {
  return http.request<ResponseData<[]>>("post", "/Tag/setSTag", { data });
};
