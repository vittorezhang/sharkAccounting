import { preferences } from '@kit.ArkData';
import { AuthToken, registerItem } from '../main/ets/viewModel/commonFunction';

export class StorageUtil {
  private static readonly PREFERENCES_NAME = 'my_app_preferences';
  private static readonly AUTH_TOKEN_KEY = 'auth_token';

  // 获取Preferences实例（支持多种数据类型）
  private static async getPreferences(): Promise<preferences.Preferences> {
    return await preferences.getPreferences(
      getContext(),
      StorageUtil.PREFERENCES_NAME
    );
  }

  // 存储认证信息
  static async setAuthToken(token: AuthToken): Promise<void> {
    console.log('token', JSON.stringify(token))
    try {
      const pref = await StorageUtil.getPreferences();
      await pref.put(StorageUtil.AUTH_TOKEN_KEY, JSON.stringify(token));
      await pref.flush();
    } catch (error) {
      console.error('[StorageUtil] 存储token失败:', error);
      // throw error;
    }
  }

  // 获取认证信息
  static async getAuthToken(): Promise<AuthToken | null> {
    try {
      const pref = await StorageUtil.getPreferences();
      const value = await pref.get(StorageUtil.AUTH_TOKEN_KEY, '');
      return value ? JSON.parse(value.toString()) : null;
    } catch (error) {
      console.error('[StorageUtil] 获取token失败:', error);
      return null;
    }
  }

  // 清除认证信息
  static async clearAuthToken(): Promise<void> {
    await StorageUtil.delete(StorageUtil.AUTH_TOKEN_KEY);
  }

  // 保存数据
  static async set(key: string, value: registerItem): Promise<void> {
    try {
      const pref = await StorageUtil.getPreferences();
      await pref.put(key, JSON.stringify(value));
      await pref.flush();
    } catch (error) {
      console.error(`[StorageUtil] 存储失败 (key: ${key}):`, error);
    }
  }

  // 获取数据
  static async get(key: string, defaultValue: string = ''): Promise<string> {
    try {
      const pref = await StorageUtil.getPreferences();
      const value = await pref.get(key, defaultValue);
      // 严格类型检查
      return typeof value === 'string' ? value : defaultValue;
    } catch (error) {
      console.error(`[StorageUtil] 读取失败 (key: ${key}):`, error);
      return defaultValue;
    }
  }

  // 删除数据
  static async delete(key: string): Promise<void> {
    try {
      const pref = await StorageUtil.getPreferences();
      await pref.delete(key);
      await pref.flush();
    } catch (error) {
      console.error(`[StorageUtil] 删除失败 (key: ${key}):`, error);
    }
  }

  // 清空所有数据
  static async clear(): Promise<void> {
    try {
      const pref = await StorageUtil.getPreferences();
      await pref.clear();
      await pref.flush();
    } catch (error) {
      console.error('[StorageUtil] 清空数据失败:', error);
    }
  }
}