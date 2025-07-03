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
  username: string;
  password: string;
  timestamp: number;
}