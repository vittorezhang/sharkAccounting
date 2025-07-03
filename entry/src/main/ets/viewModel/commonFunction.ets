export interface iconItem {
  name: string;
  icon: string;
  activeIcon?: string;
  hasRedDot?: boolean;
}

export interface budgetRowItem {
  label: string;
  value: string;
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