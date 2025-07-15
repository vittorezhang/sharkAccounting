import { StorageUtil } from "./Storage";
import { router } from "@kit.ArkUI";
import { BusinessError } from '@ohos.base';
import { AuthToken } from "../main/ets/viewModel/commonFunction";
import { PUBLIC_ROUTES } from '../main/ets/common/routes/index';

export class AuthInterceptor {
  private static isRefreshing = false;
  private static refreshQueue: ((token: string | null) => void)[] = [];

  static shouldCheckToken(url: string): boolean {
    return !PUBLIC_ROUTES.some(route => url.includes(route));
  }

  static async checkRouteAccess(url: string): Promise<boolean> {
    if (!AuthInterceptor.shouldCheckToken(url)) {
      return true;
    }

    return await AuthInterceptor.checkWithRefresh();
  }


  static async checkWithRefresh(): Promise<boolean> {
    const account = await StorageUtil.getCurrentAccount();

    // 1. 无Token直接跳转
    if (!account?.token) {
      await AuthInterceptor.redirectToLogin();
      return false;
    }

    // 2. Token有效
    if (await StorageUtil.verifyToken(account.token)) {
      // 检查是否需要提前刷新
      if (StorageUtil.shouldRefresh(account.token)) {
        AuthInterceptor.silentRefresh(account.token);
      }
      return true;
    }

    return false;
    // 3. Token过期尝试刷新
    // return await AuthInterceptor.handleRefreshFlow(account);
  }

  private static async handleRefreshFlow(account: AuthToken): Promise<boolean> {
    try {
      // 1. 显式类型检查
      if (!account.token) {
        throw new Error('Missing token in account');
      }

      // 2. 严格类型调用
      const newToken: string = await StorageUtil.refreshToken(account.token);

      // 3. 验证新Token
      if (!StorageUtil.verifyToken(newToken)) {
        throw new Error('Refreshed token verification failed');
      }

      const updatedAccount: AuthToken = {
        id: account.id,
        username: account.username,
        password: account.password,
        token: newToken,
        tokenExpire: Date.now() + 120 * 60 * 1000,
        timestamp: account.timestamp
      };

      await StorageUtil.setAccount(updatedAccount);
      return true;

    } catch (error) {
      console.error('Token刷新流程异常:', (error as Error).message);
      await AuthInterceptor.redirectToLogin();
      return false;
    }
  }

  // 静默刷新（不阻塞UI）
  private static async silentRefresh(token: string) {
    if (AuthInterceptor.isRefreshing) {
      return;
    }

    AuthInterceptor.isRefreshing = true;
    try {
      const newToken = await StorageUtil.refreshToken(token);
      if (newToken) {
        // 更新所有等待中的请求
        AuthInterceptor.refreshQueue.forEach(cb => cb(newToken));
      }
    } finally {
      AuthInterceptor.isRefreshing = false;
      AuthInterceptor.refreshQueue = [];
    }
  }

  private static async redirectToLogin(): Promise<void> {
    try {
      await router.replaceUrl({
        url: 'pages/Index',
        params: {
          reason: 'token_expired',
          message: '登录已过期，请重新登录'
        }
      });
    } catch (err) {
      console.error('跳转登录页失败:', (err as BusinessError).message);
    }
  }

  static async checkLoginStatus(): Promise<boolean> {
    try {
      const account = await StorageUtil.getCurrentAccount();
      if (!account?.token || !(await StorageUtil.verifyToken(account.token))) {
        await AuthInterceptor.redirectToLogin();
        return false;
      }
      return true;
    } catch (error) {
      console.error('登录状态检查异常:', (error as BusinessError).message);
      await AuthInterceptor.redirectToLogin();
      return false;
    }
  }
}