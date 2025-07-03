import { preferences } from '@kit.ArkData';
import { AccountList, AuthToken, registerItem } from '../main/ets/viewModel/commonFunction';

export class StorageUtil {
  private static readonly PREFERENCES_NAME = 'my_app_preferences';
  private static readonly AUTH_TOKEN_KEY = 'auth_token';
  private static readonly ACCOUNT_LIST_KEY = 'account_list';

  // 获取Preferences实例（支持多种数据类型）
  public static async getPreferences(): Promise<preferences.Preferences> {
    return await preferences.getPreferences(
      getContext(),
      StorageUtil.PREFERENCES_NAME
    );
  }

  // ------------------单账户存储-----------------------

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

  // ------------------多账户存储-----------------------

  private static async saveAccountList(accountList: AccountList): Promise<void> {
    const pref = await StorageUtil.getPreferences();

    // 完全类型化的保存数据
    const saveData: AccountList = {
      currentAccountId: accountList.currentAccountId,
      accounts: accountList.accounts.map(account => {
        const savedAccount: AuthToken = {
          id: account.id,
          username: account.username,
          password: account.password,
          nickname: 'Tao',
          gender: '男',
          phone: '未绑定',
          wechat: 'Tao',
          emergencyContact: '未设置',
          timestamp: account.timestamp
        };
        return savedAccount;
      })
    };

    await pref.put(StorageUtil.ACCOUNT_LIST_KEY, JSON.stringify(saveData));
    await pref.flush();
  }

  // 获取账户列表
  static async getAccountList(): Promise<AccountList> {
    const pref = await StorageUtil.getPreferences();
    const value = await pref.get(StorageUtil.ACCOUNT_LIST_KEY, '');

    // 类型安全解析
    const defaultList: AccountList = {
      currentAccountId: '',
      accounts: []
    };

    if (!value) {
      return defaultList;
    }

    try {
      const parsed = JSON.parse(value.toString()) as AccountList;
      return {
        currentAccountId: parsed.currentAccountId || '',
        accounts: parsed.accounts || []
      };
    } catch (e) {
      console.error('解析账户列表失败:', e);
      return defaultList;
    }
  }

  // 存储多账户信息
  static async setAccount(token: AuthToken): Promise<void> {
    const pref = await StorageUtil.getPreferences();
    const accountList = await StorageUtil.getAccountList();

    // 更新或新增账户
    const existingIndex = accountList.accounts.findIndex(a => a.id === token.id);
    if (existingIndex >= 0) {
      accountList.accounts[existingIndex] = token;
    } else {
      accountList.accounts.push(token);
    }

    await pref.put(StorageUtil.ACCOUNT_LIST_KEY, JSON.stringify(accountList));
    await pref.flush();
  }

  // 设置当前账户
  static async setCurrentAccount(id: string): Promise<void> {
    const accountList = await StorageUtil.getAccountList();
    accountList.currentAccountId = id;
    await StorageUtil.saveAccountList(accountList);
  }

  // 获取当前账户
  static async getCurrentAccount(): Promise<AuthToken | null> {
    const accountList = await StorageUtil.getAccountList();
    return accountList.accounts.find(a => a.id === accountList.currentAccountId) || null;
  }

  // 注销账户
  static async clearAccount(accountId: string): Promise<void> {
    try {
      const pref = await StorageUtil.getPreferences();
      const accountList = await StorageUtil.getAccountList();

      // 类型安全过滤
      const updatedAccounts = accountList.accounts.filter((acc: AuthToken) => acc.id !== accountId);

      // 处理当前账户
      const updatedCurrentId = accountList.currentAccountId === accountId ? '' : accountList.currentAccountId;

      // 类型安全的保存数据
      const updatedList: AccountList = {
        currentAccountId: updatedCurrentId,
        accounts: updatedAccounts
      };

      await pref.put(StorageUtil.ACCOUNT_LIST_KEY, JSON.stringify(updatedList));
      await pref.flush();
    } catch (error) {
      console.error('清除账户失败:', error);
      throw new Error('清除账户操作失败');
    }
  }
}