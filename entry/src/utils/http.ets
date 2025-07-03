import { http } from '@kit.NetworkKit';
import { loginItem } from '../main/ets/viewModel/commonFunction';
import httpResponse from '../main/ets/viewModel/HttpResponse';

export class HttpUtil {
  /**
   * 增强版POST请求
   * @returns 包含code/data/message的标准响应格式
   */
  static async post(
    url: string,
    data: loginItem
  ): Promise<httpResponse> {
    const httpRequest = http.createHttp();
    const response = await httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(data)
    });

    // 确保返回标准格式
    return {
      code: response.responseCode,
      data: response.result || {},
    };
  }
}