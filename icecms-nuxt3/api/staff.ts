import httpRequest from "../service/index";
import type {Setting} from "../types/setting";

/**
 * @description 分页查询员工数据
 * @return 员工信息
 */

const URL = "/WebSitting/getSetting";
export const getStaffInfoByPage = (params: any) => {
  return httpRequest.get<Setting[]>('/WebSitting/getSetting');

};
