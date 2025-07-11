import font from '@ohos.font';
import { promptAction, router } from '@kit.ArkUI'
import { MemoryCache } from '../../../utils/MemoryCache';
import TabBar from '../components/TabBar'
import { AccountData, AccountingRecord, AuthToken } from '../viewModel/commonFunction';
import { StorageUtil } from '../../../utils/storage';

interface Category {
  id: string;
  name: string;
  icon: string;
  selectedIcon: string;
}

interface GeneratedTypeLiteralInterface_1 {
  translateX: number;

  // opacity: number;
  direction: 'left' | 'right';
}

export interface textItem {
  label: string;
  icon: string;
  isBlank?: boolean;
  isConfirm?: boolean;
}

interface GeneratedTypeLiteralInterface_2 {
  firstOperand: string;
  operator: '+' | '-' | '×' | '';
}

interface RouteParams {
  currentCategoryId?: string;
  currentCategory?: string;
  currentIcon?: string;
}

@Entry
@Component
struct AccountPage {
  @State private currentIndex: number = 2
  @State currentAccount: AuthToken | null = null;
  @State listAnimation: GeneratedTypeLiteralInterface_1 = {
    translateX: 0,
    // opacity: 1,
    direction: 'left'
  }
  @State private animating: boolean = false;
  @State translateY: number = 1000 // 初始在屏幕外
  @State selectedTab: string = '支出'
  @State selectedIcon: string = ''
  @State selectedCategory: string = ''
  @State selectedCategoryId: string = ''
  @State amount: string = '0.00'
  @State showKeyboard: boolean = false
  @State note: string = ''
  @State calculation: GeneratedTypeLiteralInterface_2 = {
    firstOperand: '',
    operator: ''
  }
  private oneRowList: textItem[] = [
    { label: '7', icon: '' },
    { label: '8', icon: '' },
    { label: '9', icon: '' },
    { label: '今天', icon: '' },
  ];
  private twoRowList: textItem[] = [
    { label: '4', icon: '' },
    { label: '5', icon: '' },
    { label: '6', icon: '' },
    { label: '+', icon: '' },
  ];
  private threeRowList: textItem[] = [
    { label: '1', icon: '' },
    { label: '2', icon: '' },
    { label: '3', icon: '' },
    { label: '-', icon: '' },
  ];
  private fourRowList: textItem[] = [
    { label: '.', icon: '' },
    { label: '0', icon: '' },
    { label: 'x', icon: '' },
    {
      label: this.calculation.operator ? '=' : '完成',
      icon: '',
      isConfirm: true
    }
  ];
  // 支出的分类数据
  @State expensesCategories: Category[] = [
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
  @State incomeCategories: Category[] = [
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

  onPageShow(): void {
    // 注册字体
    font.registerFont({
      familyName: 'myFont',
      familySrc: '/fonts/iconfont.ttf'
    })
    // 明细页 传过来的参数
    const params = router.getParams() as RouteParams;
    if (params) {
      this.selectedCategory = params?.currentCategory || '';
      this.selectedCategoryId = params?.currentCategoryId || '';
      // 预留TODO
      // this.selectCategory({
      //   name: params.currentCategory,
      //   icon: params.currentIcon,
      //   selectedIcon: params.currentIcon,
      // });
      // this.showKeyboard = true;
    }
    // 从StorageUtil加载当前账户
    StorageUtil.getCurrentAccount().then(account => {
      console.log('页面记账的account', JSON.stringify(account))
      this.currentAccount = account;
    });
  }

  onPageHide(): void {
    MemoryCache.delete('cache_route');
  }

  private closePage() {
    if (this.animating) {
      return;
    }
    this.animating = true;

    // 下滑动画
    animateTo({
      duration: 280,
      curve: Curve.EaseIn,
      onFinish: () => {
        router.replaceUrl({ url: MemoryCache.get('cache_route')?.value.currentRoutePath || 'pages/detail' });
        this.animating = false;
      }
    }, () => {
      this.translateY = 1000;
    });
  }

  private switchTab(tab: string) {
    if (tab === this.selectedTab) {
      return;
    }
    const newDirection = tab === '支出' ? 'right' : 'left';

    // 第一步：当前列表淡出
    animateTo({
      duration: 0,
      curve: Curve.EaseIn,
      onFinish: () => {
        // 第二步：切换数据后新列表进入
        this.selectedTab = tab;
        this.selectedCategory = '';
        this.listAnimation = {
          translateX: newDirection === 'left' ? 300 : -300,
          // opacity: 0,
          direction: newDirection
        };

        animateTo({
          duration: 250,
          curve: Curve.EaseOut
        }, () => {
          this.listAnimation = {
            translateX: 0,
            // opacity: 1,
            direction: newDirection
          };
        });
      }
    }, () => {
      this.listAnimation = {
        translateX: newDirection === 'left' ? -100 : 100,
        // opacity: 0.5,
        direction: newDirection
      };
    });
  }

  private selectCategory(item: Category) {
    animateTo({
      duration: 150,
      curve: Curve.EaseInOut
    }, () => {
      this.selectedIcon = item.icon
      this.selectedCategory = item.name
      this.selectedCategoryId = item.id
    })
  }

  // 新增Tab构建方法
  @Builder
  buildTabItem(tabName: string) {
    Column() {
      Text(tabName)
        .fontSize(18)
        .fontColor('#333333')
        .fontWeight(500)
        .onClick(() => this.switchTab(tabName))

      // 下滑线指示器
      if (this.selectedTab === tabName) {
        Divider()
          .color('#333333')
          .strokeWidth(2)
          .width(36)
          .position({ y: 26 })
      }
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildTopBar() {
    Column() {
      Row() {
        Text('取消')
          .fontSize(16)
          .fontColor('#666666')
          .onClick(() => router.back())

        Blank()

        Row() {
          Text('支出')
            .fontSize(18)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
            .margin({ right: 24 })

          Text('收入')
            .fontSize(18)
            .fontColor('#999999')
        }
      }
      .padding(16)
    }
    .backgroundColor('#FFD700')
    .width('100%')
  }

  @Builder
  buildNumberKeyboard() {
    Column() {
      // 在金额显示区上方添加计算表达式
      Text(
        this.calculation.firstOperand ?
          `${this.calculation.firstOperand} ${this.calculation.operator}` :
          ''
      )
        .fontSize(16)
        .fontColor('#999999')
        .margin({ bottom: 4 })
        .width('100%')
        .textAlign(TextAlign.End)

      // 金额显示区
      Flex({ direction: FlexDirection.Column }) {
        Row() {
          Text(this.amount)
            .fontSize(32)
            .fontColor('#333333')
            .onClick(() => this.showKeyboard = true)
        }
        .padding({ right: 16 })
        .width('100%')
        .height(62)
        .justifyContent(FlexAlign.End)

        Row() {
          Text('备注:')
            .fontSize(14)
            .fontColor('#333333')
          TextInput({ placeholder: ` ${this.note ? this.note : '点击填写备注'}` })
            .backgroundColor('#F5F5F5')
            .onChange((value: string) => {
              this.note = value;
            })

        }
        .width('100%')
        .height(56)
        .padding({ left: 16 })
        .backgroundColor('#F5F5F5')
      }
      .width('100%')
      .height(82)
      .backgroundColor('#FFFFFF')

      // 第一行
      Row() {
        ForEach(this.oneRowList, (item: textItem) => {
          this.buildKeyButton(item?.label)
        })
      }

      // 第二行
      Row() {
        ForEach(this.twoRowList, (item: textItem) => {
          this.buildKeyButton(item?.label)
        })
      }

      // 第三行
      Row() {
        ForEach(this.threeRowList, (item: textItem) => {
          this.buildKeyButton(item?.label)
        })
      }

      // 第四行
      Row() {
        ForEach(this.fourRowList, (item: textItem) => {
          this.buildKeyButton(item?.label, false, item?.label === '完成')
        })
      }
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
  }

  private dynamicTextHandle = (label: string) => {
    let dynamicText = label;
    if (label === '完成' && this.calculation.operator) {
      dynamicText = '='
    }
    return dynamicText;
  }

  @Builder
  buildKeyButton(label: string, isBlank: boolean = false, isConfirm: boolean = false) {
    Button() {
      Row({ space: 4 }) {
        if (label === '今天') {
          Image($r('app.media.calendar'))
            .width(20)
            .height(20)
        }
        Text(this.dynamicTextHandle(label))
          .fontSize(18)
          .fontWeight(500)
          .fontColor('#333333')
      }
    }
    .type(ButtonType.Normal)
    .width('25%')
    .height(56)
    .fontSize(20)
    .fontWeight(500)
    .fontColor('#333333')
    .backgroundColor(isConfirm ? '#FFD700' : '#FFFFFF')
    .onClick(() => this.handleKeyPress(this.dynamicTextHandle(label)))
    .visibility(isBlank ? Visibility.Hidden : Visibility.Visible)
  }

  private handleKeyPress(key: string) {
    switch (key) {
      case '+':
      case '-':
        this.handleOperator(key);
        break;
      case '=':
        this.calculateResult();
        break;
      case 'x': // 清除操作
        this.clearCalculation();
        break;
      case '完成':
        this.finishAccount();
        break;
      case '今天':
        // 原有日期处理
        break;
      default:
        this.processAmountInput(key);
    }
  }

  private handleOperator(operator: '+' | '-' | '×') {
    // 清除无效字符
    const cleanAmount = this.amount.replace(/[^0-9.]/g, '');

    // 忽略无效操作
    if (cleanAmount === '0.00' && !this.calculation.firstOperand) {
      return;
    }

    // 自动完成上一个计算
    if (this.calculation.operator && this.calculation.firstOperand) {
      this.calculateResult();
    }

    this.calculation = {
      firstOperand: cleanAmount,
      operator
    };
    this.amount = '0.00';
  }

  private calculateResult() {
    const first = parseFloat(this.calculation.firstOperand);
    const second = parseFloat(this.amount.replace(/[^0-9.]/g, ''));

    let result = 0;
    switch (this.calculation.operator) {
      case '+':
        result = first + second;
        break;
      case '-':
        result = first - second;
        break;
      case '×':
        result = first * second;
        break;
    }

    // 格式化显示（保留两位小数，去除多余0）
    this.amount = result % 1 === 0 ?
    result.toString() :
    result.toFixed(2).replace(/\.?0+$/, '');

    this.calculation = { firstOperand: '', operator: '' };
  }

  private clearCalculation() {
    this.amount = '0.00';
    this.calculation = { firstOperand: '', operator: '' };
    this.showKeyboard = true; // 保持键盘打开
  }

  private finishAccount() {
    if (!this.currentAccount?.id) {
      return;
    }
    // 1. 获取当前数据
    const currentAmount = parseFloat(this.amount.replace(/[^0-9.]/g, ''));
    const selectedCategory = this.selectedCategory || '其他'; // 从界面获取选中分类
    // 2. 创建新记录
    const newRecord: AccountingRecord = {
      currentAccountId: this.currentAccount.id,
      id: this.selectedCategoryId,
      accountId: this.currentAccount.id,
      type: this.selectedTab === '支出' ? 'expense' : 'income',
      selectedIcon: this.selectedIcon,
      category: selectedCategory,
      amount: currentAmount,
      remark: this.note || undefined, // 从备注输入框获取
      createTime: new Date().toISOString()
    };
    // 保存记账数据
    StorageUtil.saveAccountingRecord(newRecord);

    setTimeout(() => {
      // 跳转明细页面
      router.replaceUrl({
        url: 'pages/detail',
        params: {
          categoryType: selectedCategory
        }
      });
    }, 1000)
  }

  private processAmountInput(key: string) {
    // 重置计算状态时的输入
    if (this.calculation.operator && this.amount === '0.00') {
      this.amount = '';
    }

    // 过滤非数字输入
    if (!/[\d.]/.test(key)) {
      return;
    }

    // 处理小数点
    if (key === '.') {
      if (this.amount.includes('.')) {
        return;
      }
      this.amount = this.amount === '0.00' ? '0.' : this.amount + '.';
      return;
    }

    // 正常数字输入
    this.amount = this.amount === '0.00' ?
      key :
      this.amount.replace(/[^0-9.]/g, '') + key;
  }

  build() {
    Stack() {
      // 主内容区（带动画）
      Column() {
        // 顶部操作栏（黄色背景）
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            // Tab切换区域
            Row({ space: 32 }) {
              this.buildTabItem('支出')
              this.buildTabItem('收入')
            }
            .width('65%')
            .justifyContent(FlexAlign.End)

            // 取消按钮
            Row() {
              Text('取消')
                .fontSize(16)
                .fontColor('#666666')
                .onClick(() => this.closePage())
            }
            .width('35%')
            .justifyContent(FlexAlign.End)
          }
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 12
          })
        }
        .backgroundColor('#FFD700')
        .width('100%')

        // 分类网格（4列布局）
        Grid() {
          ForEach(this.selectedTab === '支出' ? this.expensesCategories : this.incomeCategories, (item: Category) => {
            GridItem() {
              Column({ space: 8 }) {
                Row() {
                  Text(item.icon)//引号里的'\u'+编号为官网图片的后四位
                    .fontFamily('myFont')//这句话必须加上，不然不显示
                    .fontSize(20)
                    .fontColor('#333333')
                }
                .width(50)
                .height(50)
                .justifyContent(FlexAlign.Center)
                .backgroundColor(this.selectedCategory === item.name ? '#FFD700' : '#F5F5F5')
                .borderRadius('50%')

                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontColor('#333333')
                }
              }
              .onClick(() => {
                this.selectCategory(item);
                this.showKeyboard = true;
              })
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr') // 4列
        .columnsGap(12)
        .rowsGap(12)
        .padding(16)
        .layoutWeight(1)
        .shadow({
          color: '#F5F5F5',
          radius: 8,
          offsetX: this.listAnimation.translateX / 10
        })
        .translate({
          x: this.listAnimation.translateX
        })

        // .opacity(this.listAnimation.opacity)

        // 数字键盘（条件渲染）
        if (this.showKeyboard) {
          this.buildNumberKeyboard()
        }

        if (this.translateY === 1000) {
          // 底部TabBar
          TabBar({ currentIndex: $currentIndex })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
      .translate({ y: this.translateY })
    }
    .onAppear(() => {
      animateTo({
        duration: 300,
        curve: Curve.EaseOut
      }, () => {
        this.translateY = 0
      })
    })
  }
}
