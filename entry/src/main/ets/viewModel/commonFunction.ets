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
}