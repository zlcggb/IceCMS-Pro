import { http } from "@/utils/http";

/**  新增文章(修改)  */
export const newAaticle = (data?: object) => {
  return http.request<ResponseData<[]>>("post", "/article/create", { data });
};

// 获取所有文章（分页）
export const getAllArticles = (page, limit) => {
  return http.request<ResponseData<[]>>("get", `/article/getAllArticle/${page}/${limit}`);
};

// 写createArticle, updateArticle, deleteArticle方法
export const createArticle = (data: object) => {
  return http.request<ResponseData<[]>>("post", "/article/create", { data });
};

export const updateArticles = (data: object) => {
  return http.request<ResponseData<[]>>("post", "/article/update", { data });
};

export const deleteArticle = (id: string) => {
  return http.request<ResponseData<[]>>("delete", `/article/delete/${id}`);
};

// 获取文章详情
export const getArticleDetail = (id: string) => {
  return http.request<ResponseData<[]>>("get", `/article/getArticleDetail/${id}`);
};
