import font from '@ohos.font';
import { router } from '@kit.ArkUI'
import { MemoryCache } from '../../../utils/MemoryCache';
import TabBar from '../components/TabBar'
import { AccountingRecord, AuthToken } from '../viewModel/commonFunction';
import { StorageUtil } from '../../../utils/Storage';
import {
  calculation,
  calculationItem,
  Category,
  expensesCategories,
  fourRowList,
  listAnimationItem,
  incomeCategories,
  oneRowList,
  RouteParams,
  textItem,
  threeRowList,
  twoRowList
} from '../common/accountOptions';

@Entry
@Component
struct AccountPage {
  @State private currentIndex: number = 2
  @State currentAccount: AuthToken | null = null;
  @State listAnimation: listAnimationItem = {
    translateX: 0,
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
  @State calculation: calculationItem = calculation;
  private oneRowList: textItem[] = oneRowList;
  private twoRowList: textItem[] = twoRowList;
  private threeRowList: textItem[] = threeRowList;
  private fourRowList: textItem[] = fourRowList;
  // 支出的分类数据
  @State expensesCategories: Category[] = expensesCategories;
  // 收入的分类数据
  @State incomeCategories: Category[] = incomeCategories;
  // 防抖计时器
  private debounceTimer: number = 0;

  // 防抖函数封装
  private debounce(func: () => void, delay: number) {
    // 清除之前的计时器
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }
    // 设置新的计时器
    this.debounceTimer = setTimeout(() => {
      func();
    }, delay) as number;
  }

  onPageShow(): void {
    // 注册字体
    font.registerFont({
      familyName: 'myFont',
      familySrc: '/fonts/iconfont.ttf'
    })
    // 明细页 传过来的参数
    const params = router.getParams() as RouteParams;
    if (params) {
      console.log('params', JSON.stringify(params))
      this.selectedCategory = params?.currentCategory || '';
      this.selectedCategoryId = params?.currentCategoryId || '';
      // 处理[收入&支付]的tab页面回显
      if (params?.currentCategory &&
      ['工资', '兼职', '理财', '礼金', '其它', '设置'].includes(params?.currentCategory)) {
        this.selectedTab = '收入'
      }
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

  aboutToDisappear() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }
  }

  // 关闭页面
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

  // 切换分类
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
            direction: newDirection
          };
        });
      }
    }, () => {
      this.listAnimation = {
        translateX: newDirection === 'left' ? -100 : 100,
        direction: newDirection
      };
    });
  }

  // 选择分类
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

  // tab UI构建
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

  // 自定义键盘 UI构建
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

  // 键盘按钮 UI构建
  @Builder
  buildKeyButton(label: string, isBlank: boolean = false, isConfirm: boolean = false) {
    Button() {
      Row({ space: 4 }) {
        if (label === '今天') {
          Image($r('app.media.calendar'))
            .width(20)
            .height(20)
        }
        if (label === 'x') {
          Text('\ue63e')
            .fontFamily('myFont')
            .fontSize(20)
            .fontColor('#333333')
        } else {
          Text(this.dynamicTextHandle(label))
            .fontSize(18)
            .fontWeight(500)
            .fontColor('#333333')
        }
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

  // 键盘文本筛选
  private dynamicTextHandle = (label: string) => {
    let dynamicText = label;
    if (label === '完成' && this.calculation.operator) {
      dynamicText = '='
    }
    return dynamicText;
  }

  // 键盘功能事件筛选
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

  // 键盘功能操作
  private handleOperator(operator: '+' | '-' | '×') {
    const cleanAmount = this.amount.replace(/[^0-9.]/g, '');

    // 如果已经有运算符，先计算中间结果
    if (this.calculation.operator) {
      const result = this.calculateIntermediate();
      this.calculation = {
        firstOperand: result.toString(),
        operator,
        lastResult: result.toString()
      };
    }
    // 首次运算符输入
    else {
      this.calculation = {
        firstOperand: cleanAmount,
        operator,
        lastResult: ''
      };
    }

    this.amount = '0.00';
  }

  // 中间计算逻辑
  private calculateIntermediate(): number {
    const current = parseFloat(this.amount || '0');
    const first = parseFloat(this.calculation.firstOperand || '0');

    switch (this.calculation.operator) {
      case '+':
        return first + current;
      case '-':
        return first - current;
      case '×':
        return first * current;
      default:
        return current;
    }
  }

  // 最终计算逻辑
  private calculateResult() {
    let result = 0;

    // 如果有未完成的运算（如 2+6+）
    if (this.calculation.operator && this.calculation.firstOperand) {
      result = this.calculateIntermediate();
    }
    // 如果是连续运算（如按了=之后继续）
    else if (this.calculation.lastResult) {
      result = parseFloat(this.calculation.lastResult);
    }

    // 格式化显示
    this.amount = result % 1 === 0 ?
    result.toString() :
    result.toFixed(2);

    // 保留最后结果用于连续运算
    this.calculation = {
      firstOperand: '',
      operator: '',
      lastResult: result.toString()
    };
  }

  // 清空输入文本
  private clearCalculation() {
    this.amount = '0.00';
    this.calculation = { firstOperand: '', operator: '' };
    this.showKeyboard = true; // 保持键盘打开
  }

  // 提交记账
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
    // 使用防抖包装处理逻辑
    this.debounce(() => {
      // 保存记账数据
      StorageUtil.saveAccountingRecord(newRecord);
    }, 500); // 500ms防抖间隔

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

  // 键盘数字输入
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
                  Text(item.icon)
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
