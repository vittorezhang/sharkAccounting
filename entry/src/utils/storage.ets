import { preferences } from '@kit.ArkData';
import { AccountingRecord, AccountList, AuthToken } from '../main/ets/viewModel/commonFunction';
import { Base64Util } from './Base64Util';
import { router } from '@kit.ArkUI';

interface GeneratedTypeLiteralInterface {
  exp?: number;
  sub?: string
}

export class StorageUtil {
  private static readonly PREFERENCES_NAME = 'my_app_preferences';
  private static readonly ACCOUNT_LIST_KEY = 'account_list';

  // -------------------记账数据 start----------------------

  //  保存记账数据
  public static async saveAccountingRecord(record: AccountingRecord): Promise<void> {
    const pref = await StorageUtil.getPreferences();
    const value = await pref.get(StorageUtil.ACCOUNT_LIST_KEY, '');
    const parsed = JSON.parse(value.toString()) as AccountList;
    // 更新或新增数据
    if (!parsed.expenseOrIncomeData) {
      return
    }
    const existingIndex = parsed.expenseOrIncomeData.findIndex(a => a.id === record.id);
    if (existingIndex >= 0) {
      parsed.expenseOrIncomeData[existingIndex] = record;
    } else {
      parsed.expenseOrIncomeData.push(record);
    }


    const saveData: AccountList = {
      currentAccountId: parsed.currentAccountId,
      accounts: parsed.accounts.map(account => {
        const savedAccount: AuthToken = {
          id: account.id,
          username: account.username,
          password: account.password,
          gender: account.gender,
          token: account.token,
          tokenExpire: account.tokenExpire,
          timestamp: account.timestamp,
        };
        return savedAccount;
      }),
      expenseOrIncomeData: parsed.expenseOrIncomeData
    };

    await pref.put(StorageUtil.ACCOUNT_LIST_KEY, JSON.stringify(saveData));
    await pref.flush();

  }

  // 获取记账数据【所有账户】
  public static async getAccountingRecords(id: string): Promise<AccountingRecord | null> {
    const pref = await StorageUtil.getPreferences();
    const value = await pref.get(StorageUtil.ACCOUNT_LIST_KEY, '');
    const parsed = JSON.parse(value.toString()) as AccountList;
    if (!parsed.expenseOrIncomeData) {
      return null
    }
    return parsed.expenseOrIncomeData.find(a => a.id === id) || null;
  }

  // 获取记账数据【当前账户】
  public static async getCurrentAccountingRecord(accountId:string) {
    const accountList = await StorageUtil.getAccountList();
    if (!accountList?.expenseOrIncomeData) {
      return null;
    }
    return accountList?.expenseOrIncomeData || null;
  }

  // -------------------记账数据 end------------------


  // -------------------添加token 时效start------------------
  private static readonly TOKEN_EXPIRE_MS = 120 * 60 * 1000; // 120分钟

  private static readonly REFRESH_THRESHOLD = 5 * 60 * 1000; // 提前5分钟刷新

  static async refreshToken(oldToken: string): Promise<string> { // 明确返回string
    if (!oldToken) {
      throw new Error('Token cannot be empty');
    }
    try {
      const parts = oldToken.split('.');
      if (parts.length !== 3) {
        return '';
      }

      const payloadStr = Base64Util.decode(parts[1]);
      const payload = JSON.parse(payloadStr) as GeneratedTypeLiteralInterface;

      if (!payload.sub) {
        return '';
      }

      // 生成新Token（有效期重新计算）
      return StorageUtil.generateToken(payload.sub);
    } catch (error) {
      console.error('刷新Token失败:', error);
      return '';
    }
  }

  static shouldRefresh(token: string): boolean {
    try {
      const payloadStr = token.split('.')[1];
      const payload = JSON.parse(Base64Util.decode(payloadStr)) as GeneratedTypeLiteralInterface;
      return payload.exp ?
        payload.exp - Date.now() < StorageUtil.REFRESH_THRESHOLD :
        true;
    } catch {
      return true;
    }
  }

  // 生成Token（模拟JWT）
  static generateToken(accountId: string): string {
    const header = Base64Util.encode(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
    const payload = Base64Util.encode(JSON.stringify({
      sub: accountId,
      exp: Date.now() + StorageUtil.TOKEN_EXPIRE_MS
    }));
    return `${header}.${payload}.${StorageUtil.mockSignature()}`;
  }

  // 验证Token有效性
  static async verifyToken(token: string): Promise<boolean> {
    if (!token) {
      return false;
    }

    try {
      const parts = token.split('.');
      if (parts.length !== 3) {
        return false;
      }

      const payloadStr = Base64Util.decode(parts[1]);
      const payload = JSON.parse(payloadStr) as GeneratedTypeLiteralInterface;

      // 双重类型检查
      return typeof payload.exp === 'number' && payload.exp > Date.now();
    } catch (error) {
      console.error('Token验证异常:', error);
      return false;
    }
  }

  private static mockSignature(): string {
    return 'mock_signature_for_demo'; // 生产环境应替换为实际加密
  }

  // -------------------添加token 时效end------------------

  // 获取Preferences实例（支持多种数据类型）
  public static async getPreferences(): Promise<preferences.Preferences> {
    return await preferences.getPreferences(
      getContext(),
      StorageUtil.PREFERENCES_NAME
    );
  }

  // ------------------多账户存储start-----------------------

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
          gender: account.gender,
          token: account.token,
          tokenExpire: account.tokenExpire,
          timestamp: account.timestamp
        };
        return savedAccount;
      }),
      expenseOrIncomeData: accountList.expenseOrIncomeData
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
      accounts: [],
      expenseOrIncomeData: [],
    };

    if (!value) {
      return defaultList;
    }

    try {
      const parsed = JSON.parse(value.toString()) as AccountList;
      return {
        currentAccountId: parsed.currentAccountId || '',
        accounts: parsed.accounts || [],
        expenseOrIncomeData: parsed.expenseOrIncomeData || []
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

  // ------------------多账户存储end-----------------------
}