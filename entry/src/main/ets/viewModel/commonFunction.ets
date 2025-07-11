export interface iconItem {
  name: string;
  icon: string;
  activeIcon?: string;
  hasRedDot?: boolean;
}

export interface actionBarItem {
  name: string;
  icon: string;
  hasRedDot?: boolean;
}

export interface operateAreaItem {
  name: string;
  leftIcon: string;
  rightIcon: string;
  hasWarning?: boolean;
}

export interface budgetRowItem {
  label: string;
  value: string;
}

export interface statsItem {
  consecutiveDays: number;
  totalDays: number;
  totalRecords: number;
}

export interface registerItem {
  username: boolean;
  password: boolean;
  passwordMatch?: boolean;
  isAgreed: boolean;
}

export interface AuthToken {
  id: string;
  username: string;
  password: string;
  token?: string; // 新增JWT token
  tokenExpire?: number; // 过期时间戳（单位：毫秒）
  avatar?: string;
  nickname?: string;
  gender?: string;
  phone?: string;
  wechat?: string;
  emergencyContact?: string;
  timestamp: number;
}

export interface AccountList {
  currentAccountId: string;
  accounts: AuthToken[];
  expenseOrIncomeData?: AccountingRecord[]
}

export interface RouteData {
  currentRoutePath: string,
  currentIndex: number
}

export interface CacheItem<T = RouteData> {
  key: string;
  value: T;
  ttl?: number;
}

// 记账记录类型
export interface AccountingRecord {
  currentAccountId: string;
  id: string; // 记录唯一ID
  accountId: string; // 关联账户ID（对应AuthToken.id）
  type?: 'expense' | 'income'; // 收支类型
  selectedIcon: string; // 图标
  category: string; // 分类名称
  amount: number; // 金额（单位：元）
  remark?: string; // 备注（可选）
  createTime: string; // ISO格式时间戳
  updateTime?: string; // 最后更新时间（可选）
}

// 账户数据类型
interface accountType {
  expense: string[]; // 支出分类
  income: string[]; // 收入分类
}

export interface AccountData {
  balance: number; // 当前余额
  records: AccountingRecord[]; // 记账记录
  categories: accountType;
}