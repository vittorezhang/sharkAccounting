import font from '@ohos.font';
import { promptAction, router } from '@kit.ArkUI'
import { MemoryCache } from '../../../utils/MemoryCache';
import TabBar from '../components/TabBar'

interface Category {
  name: string;
  icon: string;
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

@Entry
@Component
struct AccountPage {
  @State private currentIndex: number = 2
  @State listAnimation: GeneratedTypeLiteralInterface_1 = {
    translateX: 0,
    // opacity: 1,
    direction: 'left'
  }
  @State private animating: boolean = false;
  @State translateY: number = 1000 // 初始在屏幕外
  @State selectedTab: string = '支出'
  @State selectedCategory: string = ''
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
    { name: '餐饮', icon: '\ue8a4' },
    { name: '购物', icon: '\ue899' },
    { name: '日用', icon: '\ue604' },
    { name: '交通', icon: '\ue61e' },
    { name: '蔬菜', icon: '\ue713' },
    { name: '水果', icon: '\ue631' },
    { name: '零食', icon: '\ue625' },
    { name: '运动', icon: '\ue69b' },
    { name: '娱乐', icon: '\ue639' },
    { name: '通讯', icon: '\ue632' },
    { name: '服饰', icon: '\ue60d' },
    { name: '美容', icon: '\ue657' },
    { name: '住房', icon: '\ue63b' },
    { name: '居家', icon: '\ue61b' },
    { name: '孩子', icon: '\ue84e' },
    { name: '长辈', icon: '\ue654' },
    { name: '社交', icon: '\ue615' },
    { name: '旅行', icon: '\ue655' },
    { name: '烟酒', icon: '\ue60f' },
    { name: '数码', icon: '\ue611' },
    { name: '汽车', icon: '\ue65d' },
    { name: '医疗', icon: '\ue646' },
    { name: '书籍', icon: '\ue606' },
    { name: '学习', icon: '\ue763' },
    { name: '宠物', icon: '\ue90d' },
    { name: '礼金', icon: '\ue651' },
    { name: '礼物', icon: '\ue600' },
    { name: '办公', icon: '\ue624' },
    { name: '维修', icon: '\ue633' },
    { name: '捐赠', icon: '\ue634' },
    { name: '彩票', icon: '\ue613' },
    { name: '亲友', icon: '\ue61d' },
    { name: '快递', icon: '\ue696' },
    { name: '设置', icon: '\ue605' }
  ]
  // 收入的分类数据
  @State incomeCategories: Category[] = [
    { name: '工资', icon: '\ue764' },
    { name: '兼职', icon: '\ue61f' },
    { name: '理财', icon: '\ue623' },
    { name: '礼金', icon: '\ue792' },
    { name: '其它', icon: '\ue65a' },
    { name: '设置', icon: '\ue605' }
  ]

  onPageShow(): void {
    // 注册字体
    font.registerFont({
      familyName: 'myFont',
      familySrc: '/fonts/iconfont.ttf'
    })
    const cached = MemoryCache.get('cache_route');
    console.log('--cached--', JSON.stringify(cached))
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

  private selectCategory(name: string) {
    animateTo({
      duration: 150,
      curve: Curve.EaseInOut
    }, () => {
      this.selectedCategory = name
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
          Text('\ue624')
            .fontFamily('myFont')
            .fontSize(20)
            .fontColor('#333333')
        }
        Text(this.dynamicTextHandle(label))
          .fontSize(20)
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

  // 点击 +
  private submitCalculator() {
    console.log(`计算数值: ${this.selectedCategory} ¥${this.amount}}`);
    this.note = this.amount + this.amount
    this.showKeyboard = false;
  }

  // 点击完成
  private submitExpense() {
    console.log(`记录支出: ${this.selectedCategory} ¥${this.amount} 备注: ${this.note}`);
    this.showKeyboard = false;
    // 实际项目这里调用API提交数据
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
                this.selectCategory(item.name);
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
