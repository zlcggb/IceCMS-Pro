import httpRequest from "../service/index";

/**
 * @description 根据用户ID获取用户信息
 * @param id 用户ID
 * @return Promise<any>
 */
export const getUserInfobyid = (id: string | number) => {
  return httpRequest.get<any>(`/Websuser/getUserInfobyid/${id}`);
};

/**
 * @description 修改用户信息
 * @param form 用户信息表单
 * @return Promise<any>
 */
export const ChangeUser = (form: any) => {
  return httpRequest.post<any>('/Websuser/ChangeUser', form);
};

/**
 * @description 测试邮箱是否有效
 * @param email 邮箱地址
 * @return Promise<any>
 */
export const testemail = (email: string) => {
  return httpRequest.get<any>(`/Websuser/testemail/${email}`);
};
