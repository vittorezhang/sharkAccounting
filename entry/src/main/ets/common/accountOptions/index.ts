// 记账分类
export interface Category {
  id: string;
  name: string;
  icon: string;
  selectedIcon: string;
}

// 动效
export interface listAnimationItem {
  translateX: number;
  direction: 'left' | 'right';
}

// 键盘文本
export interface textItem {
  label: string;
  icon: string;
  isBlank?: boolean;
  isConfirm?: boolean;
}

// 键盘符号文本
export interface calculationItem {
  firstOperand: string;
  operator: '+' | '-' | '×' | '';
  lastResult?: string; // 新增字段记录上次结果
}

// 路由参数
export interface RouteParams {
  currentCategoryId?: string;
  currentCategory?: string;
  currentIcon?: string;
}

// 键盘累加累计
export const calculation: calculationItem = {
  firstOperand: '',
  operator: '',
  lastResult: '', // 记录上次结果
}

// 键盘第1列
export const oneRowList: textItem[] = [
  { label: '7', icon: '' },
  { label: '8', icon: '' },
  { label: '9', icon: '' },
  { label: '今天', icon: '' },
];

// 键盘第2列
export const twoRowList: textItem[] = [
  { label: '4', icon: '' },
  { label: '5', icon: '' },
  { label: '6', icon: '' },
  { label: '+', icon: '' },
];

// 键盘第3列
export const threeRowList: textItem[] = [
  { label: '1', icon: '' },
  { label: '2', icon: '' },
  { label: '3', icon: '' },
  { label: '-', icon: '' },
];

// 键盘第4列
export const fourRowList: textItem[] = [
  { label: '.', icon: '' },
  { label: '0', icon: '' },
  { label: 'x', icon: '' },
  {
    label: calculation.operator ? '=' : '完成',
    icon: '',
    isConfirm: true
  }
];


// 支出的分类数据
export const expensesCategories: Category[] = [
  {
    id: '0',
    name: '餐饮',
    icon: '\ue8a4',
    selectedIcon: 'e8a4'
  },
  {
    id: '1',
    name: '购物',
    icon: '\ue899',
    selectedIcon: 'e899'
  },
  {
    id: '2',
    name: '日用',
    icon: '\ue604',
    selectedIcon: 'e604'
  },
  {
    id: '3',
    name: '交通',
    icon: '\ue61e',
    selectedIcon: 'e61e'
  },
  {
    id: '4',
    name: '蔬菜',
    icon: '\ue713',
    selectedIcon: 'e713'
  },
  {
    id: '5',
    name: '水果',
    icon: '\ue631',
    selectedIcon: 'e631'
  },
  {
    id: '6',
    name: '零食',
    icon: '\ue625',
    selectedIcon: 'e625'
  },
  {
    id: '7',
    name: '运动',
    icon: '\ue69b',
    selectedIcon: 'e69b'
  },
  {
    id: '8',
    name: '娱乐',
    icon: '\ue639',
    selectedIcon: 'e639'
  },
  {
    id: '9',
    name: '通讯',
    icon: '\ue632',
    selectedIcon: 'e632'
  },
  {
    id: '10',
    name: '服饰',
    icon: '\ue60d',
    selectedIcon: 'e60d'
  },
  {
    id: '11',
    name: '美容',
    icon: '\ue657',
    selectedIcon: 'e657'
  },
  {
    id: '12',
    name: '住房',
    icon: '\ue63b',
    selectedIcon: 'e63b'
  },
  {
    id: '13',
    name: '居家',
    icon: '\ue61b',
    selectedIcon: 'e61b'
  },
  {
    id: '14',
    name: '孩子',
    icon: '\ue84e',
    selectedIcon: 'e84e'
  },
  {
    id: '15',
    name: '长辈',
    icon: '\ue654',
    selectedIcon: 'e654'
  },
  {
    id: '16',
    name: '社交',
    icon: '\ue615',
    selectedIcon: 'e615'
  },
  {
    id: '17',
    name: '旅行',
    icon: '\ue655',
    selectedIcon: 'e655'
  },
  {
    id: '18',
    name: '烟酒',
    icon: '\ue60f',
    selectedIcon: 'e60f'
  },
  {
    id: '19',
    name: '数码',
    icon: '\ue611',
    selectedIcon: 'e611'
  },
  {
    id: '20',
    name: '汽车',
    icon: '\ue65d',
    selectedIcon: 'e65d'
  },
  {
    id: '21',
    name: '医疗',
    icon: '\ue646',
    selectedIcon: 'e646'
  },
  {
    id: '22',
    name: '书籍',
    icon: '\ue606',
    selectedIcon: 'e606'
  },
  {
    id: '23',
    name: '学习',
    icon: '\ue763',
    selectedIcon: 'e763'
  },
  {
    id: '24',
    name: '宠物',
    icon: '\ue90d',
    selectedIcon: 'e90d'
  },
  {
    id: '25',
    name: '礼金',
    icon: '\ue651',
    selectedIcon: 'e651'
  },
  {
    id: '26',
    name: '礼物',
    icon: '\ue600',
    selectedIcon: 'e600'
  },
  {
    id: '27',
    name: '办公',
    icon: '\ue624',
    selectedIcon: 'e624'
  },
  {
    id: '28',
    name: '维修',
    icon: '\ue633',
    selectedIcon: 'e633'
  },
  {
    id: '29',
    name: '捐赠',
    icon: '\ue634',
    selectedIcon: 'e634'
  },
  {
    id: '30',
    name: '彩票',
    icon: '\ue613',
    selectedIcon: 'e613'
  },
  {
    id: '31',
    name: '亲友',
    icon: '\ue61d',
    selectedIcon: 'e61d'
  },
  {
    id: '32',
    name: '快递',
    icon: '\ue696',
    selectedIcon: 'e696'
  },
  {
    id: '33',
    name: '设置',
    icon: '\ue605',
    selectedIcon: 'e605'
  }
]

// 收入的分类数据
export const incomeCategories: Category[] = [
  {
    id: '00',
    name: '工资',
    icon: '\ue764',
    selectedIcon: 'e764'
  },
  {
    id: '01',
    name: '兼职',
    icon: '\ue61f',
    selectedIcon: 'e61f'
  },
  {
    id: '02',
    name: '理财',
    icon: '\ue623',
    selectedIcon: 'e623'
  },
  {
    id: '03',
    name: '礼金',
    icon: '\ue792',
    selectedIcon: 'e792'
  },
  {
    id: '04',
    name: '其它',
    icon: '\ue65a',
    selectedIcon: 'e65a'
  },
  {
    id: '05',
    name: '设置',
    icon: '\ue605',
    selectedIcon: 'e605'
  }
]