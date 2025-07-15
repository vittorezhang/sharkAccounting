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


export const actionBarList: actionBarItem[] = [
  { name: '消息', icon: 'app.media.message' },
  { name: '我的徽章', icon: 'app.media.my_badge' },
  { name: '我的积分', icon: 'app.media.my_point' },
  { name: '邀请好友', icon: 'app.media.invite_friend' },
  { name: '设置', icon: 'app.media.setting' },
]

// 账本管理区
export const accountAreaList: operateAreaItem[] = [
  { name: '我的账本', leftIcon: 'app.media.my_account_book', rightIcon: 'app.media.ic_arrow_right' },
  { name: '家庭账单', leftIcon: 'app.media.home_bills', rightIcon: 'app.media.ic_arrow_right' },
]

// 操作区
export const operateAreaList: operateAreaItem[] = [
  { name: '设置', leftIcon: 'app.media.setting_none', rightIcon: 'app.media.ic_arrow_right' },
  {
    name: '账户安全中心',
    leftIcon: 'app.media.account_safe_center',
    rightIcon: 'app.media.ic_arrow_right',
    hasWarning: true
  },
  { name: '使用帮助', leftIcon: 'app.media.use_help', rightIcon: 'app.media.ic_arrow_right' },
  { name: '意见反馈', leftIcon: 'app.media.feed_back', rightIcon: 'app.media.ic_arrow_right' },
  { name: '去应用市场给鲨鱼记账评分', leftIcon: 'app.media.thumbs_up', rightIcon: 'app.media.ic_arrow_right' },
  { name: '关于鲨鱼记账 V5.30.0', leftIcon: 'app.media.about', rightIcon: 'app.media.ic_arrow_right' },
]