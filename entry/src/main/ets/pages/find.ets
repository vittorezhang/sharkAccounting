import TabBar from '../components/TabBar'
import BudgetRow from '../components/BudgetRow'
import {
  AccountingRecord,
  AuthToken,
  budgetRowItem,
  currentBudgetRecord,
  iconItem,
  RouteData
} from '../viewModel/commonFunction'
import { MemoryCache } from '../../../utils/MemoryCache'
import { StorageUtil } from '../../../utils/Storage'
import BudgetDialog from '../components/BudgetDialog';
import { Animator, router } from '@kit.ArkUI'

@Entry
@Component
struct FindPage {
  @State private currentIndex: number = 3
  @State currentAccount: AuthToken | null = null;
  @State currentBudget: currentBudgetRecord | null = null;
  @State progress: number = 0 // 进度值(0-1)
  // 收入&支出
  @State income: number = 0;
  @State expenses: number = 0;
  @State remainBudgetPercent: string = '0';
  // 预算 弹窗状态
  @State budgetVisible: boolean = false;
  @State budgetRowList: budgetRowItem[] = [
    { label: '剩余预算', value: '0.00' },
    { label: '本月预算', value: '0.00' },
    { label: '本月支出', value: '0.00' },
  ]
  private commonFunctionList: iconItem[] = [
    { name: '省钱优惠券', icon: 'app.media.coupon_icon' },
    { name: '资产管家', icon: 'app.media.asset_icon' },
    { name: '发票助手', icon: 'app.media.invoice_icon' },
    { name: '房贷计算器', icon: 'app.media.loan_icon' },
    { name: '汇率计算器', icon: 'app.media.exchange_icon' },
  ]

  // 当前月份
  private getCurrentMonth(): string {
    const nowMonth = new Date().getMonth() + 1;
    return nowMonth.toString().padStart(2, '0');
  }

  // 获取预算
  private async getBudget(accountId: string, bool: boolean = false) {
    if (!accountId) {
      return
    }
    try {
      this.currentBudget = await StorageUtil.getCurrentBudgetRecord(accountId);
      this.budgetVisible = bool;
      let currentMonthBudget = '';
      let remainBudget = '';
      if (this.currentBudget?.amount) {
        // 本月预算
        currentMonthBudget = String(this.currentBudget?.amount.toFixed(2))
        // 剩余预算
        remainBudget = String(((this.currentBudget && this.currentBudget?.amount) - this.expenses).toFixed(2))
        // 剩余预算 与 本月预算的占比
        const percentTotal = ((Number(remainBudget) / Number(this.currentBudget?.amount)) * 100).toFixed(2)
        this.remainBudgetPercent = String(percentTotal)
        // 圆环进度值 -> 转换为0-1范围的比例值
        this.progress = Number(percentTotal) / 100;
        console.log('this.progress', JSON.stringify(this.progress))
      }
      // 预算数据赋值
      this.budgetRowList = this.budgetRowList.map((mItem: budgetRowItem) => {
        if (mItem.label === '剩余预算') {
          return {
            label: mItem.label,
            value: remainBudget || '0.00'
          };
        }
        if (mItem.label === '本月预算') {
          return {
            label: mItem.label,
            value: currentMonthBudget || '0.00'
          };
        }
        if (mItem.label === '本月支出') {
          return {
            label: mItem.label,
            value: String(this.expenses.toFixed(2)) || '0.00'
          };
        }
        return mItem;
      });
    } catch (error) {
      console.log(error)
    }
  }

  async onPageShow() {
    //初始化清空【 收入、支出】
    this.income = 0
    this.expenses = 0
    // 临时存储路由数据
    console.log('临时存储路由数据--pages/find')
    const routeData: RouteData = {
      currentRoutePath: 'pages/find',
      currentIndex: this.currentIndex
    };

    // 存储1200秒自动过期
    MemoryCache.set('cache_route', {
      key: 'cache_route',
      value: routeData,
      ttl: 1200000 // 1200秒后自动删除
    });
    // 查当前账户信息
    StorageUtil.getCurrentAccount().then(async account => {
      this.currentAccount = account;
      if (!account?.id) {
        return;
      }
      const result = await StorageUtil.getCurrentAccountingRecord(account?.id);
      if (!result) {
        return;
      }
      const currentAccountData = result
      ?.filter(a => a.currentAccountId === account?.id)
        ?? [];
      // 筛选收入累计、支出累计
      currentAccountData?.forEach((mItem: AccountingRecord) => {
        if (mItem.type === 'income') {
          this.income += mItem?.amount || 0;
        } else {
          this.expenses += mItem?.amount || 0;
        }
      });
      // 获取当前预算
      this.getBudget(account?.id);
    });
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 1. 顶部黄色标题栏
          Text('发现')
            .width('100%')
            .height(56)
            .fontSize(20)
            .fontColor('#333333')
            .textAlign(TextAlign.Center)
            .backgroundColor('#FFD700')

          // 1.1 账单
          Column() {
            Column() {
              Row() {
                Text('账单')
                  .fontSize(18)
                  .fontWeight(500)
                  .margin({ left: 12 })
                // 右侧箭头图标
                Image($r('app.media.ic_arrow_right'))
                  .width(20)
                  .height(20)
                  .margin({ right: 12 })
              }
              .width('100%')
              .height(48)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                // 跳转账单页面
                return router.pushUrl({
                  url: 'pageViews/sharkBillPage',
                  params: {
                    userName: this.currentAccount?.username,
                    income: this.income,
                    expenses: this.expenses
                  }
                });
              })

              Row() {
                Row() {
                  Row() {
                    Text(this.getCurrentMonth()).fontWeight(500).fontSize(26)
                  }
                  .padding({ right: 6, top: 9 })

                  Row() {
                    Text('月')
                  }
                  .padding({ top: 14, right: 8 })
                }
                .border({
                  width: {
                    right: 1
                  },
                  color: '#cccccc'
                })
                .padding({ top: 12 })

                Column({ space: 12 }) {
                  Text('收入').fontSize(14).fontColor('#999999')
                  Text(`${this.income.toFixed(2)}`).fontSize(18).fontColor('#333333')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 8, right: 24 })

                Column({ space: 12 }) {
                  Text('支出').fontSize(14).fontColor('#999999')
                  Text(`${this.expenses.toFixed(2)}`).fontSize(18).fontColor('#333333')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ right: 24 })

                Column({ space: 12 }) {
                  Text('结余').fontSize(14).fontColor('#999999')
                  Text(`${(this.income - this.expenses).toFixed(2)}`).fontSize(18).fontColor('#333333')
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding(16)
              .justifyContent(FlexAlign.SpaceAround)
            }
            .border({ width: 1, color: '#E5E5E5' })
            .borderRadius(8)
            .width('92%')
            .backgroundColor('#FFFFFF')
          }
          .width('100%')
          .position({
            x: 0, // 距离左侧20vp
            y: 46  // 距离顶部100vp
          })
          .zIndex(99)

          Scroll() {
            // 2. 主内容区
            Column() {
              //  2.1 预算
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.End,
                justifyContent: FlexAlign.SpaceBetween,
              }) {
                Column({ space: 12 }) {
                  Text(`${this.getCurrentMonth()}月总预算`)
                    .fontSize(18)
                    .fontWeight(500)
                    .padding({ right: 8 })
                    .margin({ bottom: 8 })
                  Stack() {
                    // 背景圆环
                    Circle()
                      .width(80)
                      .height(80)
                      .fillOpacity(0)
                      .strokeWidth(8)
                      .stroke('#F0F0F0')

                    // 进度圆环（动态）
                    Circle()
                      .width(80)
                      .height(80)
                      .fillOpacity(0)
                      .strokeWidth(8)
                      .stroke('#FFD700')
                      .strokeDashArray([
                        this.progress * Math.PI * 80, // 实线部分（进度）
                        Math.PI * 80// 虚线部分（剩余）
                      ])


                    // 进度文本（居中）
                    Column() {
                      Text('剩余')
                        .fontSize(14)
                        .fontColor('#999999')
                      Text(`${this.remainBudgetPercent}%`)
                        .fontSize(14)
                        .fontColor('#333333')
                        .margin({ top: 4 })
                    }
                  }
                }
                .width('36%')
                .alignItems(HorizontalAlign.Center)

                Column({ space: 12 }) {
                  Row() {
                    // 设置预算
                    if (this.currentBudget) {
                      // 右侧箭头图标
                      Image($r('app.media.ic_arrow_right'))
                        .width(20)
                        .height(20)
                        .onClick(() => {
                          this.budgetVisible = true;
                        })
                    } else {
                      Button('+ 设置预算', { type: ButtonType.Normal })
                        .width(110)
                        .height(28)
                        .backgroundColor('#FFD700')
                        .fontColor('#333333')
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .onClick(() => {
                          this.budgetVisible = true;
                        })
                    }
                  }
                  .width('100%')
                  .margin({ left: 2, bottom: 4 })
                  .justifyContent(FlexAlign.End)

                  if (this.currentBudget?.amount != 0) {
                    BudgetRow({ budgetRowList: this.budgetRowList })
                  }
                }
                .width('64%')
              }
              .padding({
                top: 16,
                right: 12,
                bottom: 16,
                left: 2
              })
              .margin({ top: 12 })
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .width('92%')
              .backgroundColor('#FFFFFF')
              .shadow({
                radius: 6,
                color: '#10000000',
                offsetX: 0,
                offsetY: 2
              })

              //  2.2 资产管家
              Column() {
                // 1. 标题栏（带右箭头）
                Row() {
                  Text('资产管家')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333333')
                    .margin({ left: 12 })

                  Image($r('app.media.ic_arrow_right'))// 需准备20x20箭头图标
                    .width(20)
                    .height(20)
                    .margin({ right: 12 })
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)

                // 2. 资产表格
                Row() {
                  Column({ space: 12 }) {
                    Text('净资产').fontSize(14).fontColor('#999999')
                    Text('800000.00').fontSize(18).fontColor('#333333')
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ right: 24 })

                  Column({ space: 12 }) {
                    Text('资产').fontSize(14).fontColor('#999999')
                    Text('800000.00').fontSize(18).fontColor('#333333')
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ right: 24 })

                  Column({ space: 12 }) {
                    Text('负债').fontSize(14).fontColor('#999999')
                    Text('0.00').fontSize(18).fontColor('#333333')
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding(16)
                .justifyContent(FlexAlign.Start)
              }
              .borderRadius(8)
              .border({ width: 1, color: '#E5E5E5' })
              .width('92%')
              .backgroundColor('#FFFFFF')
              .margin({ top: 12 })

              // 2.4 常用功能区
              Column() {
                Column() {
                  Row() {
                    Text('常用功能')
                      .fontSize(18)
                      .fontWeight(500)
                      .padding({ left: 14, top: 8 })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Start)

                  Flex({ wrap: FlexWrap.Wrap }) {
                    ForEach(this.commonFunctionList, (item: iconItem, index) => {
                      Column() {
                        Image($r(item.icon))
                          .width(75)
                          .height(75)
                          .padding({ left: index === 4 ? 8 : 0 })
                          .margin({ top: [1, 3].includes(index) ? 3 : [2].includes(index) ? 4 : 0 })
                      }
                      .width('25%')
                      .padding({ bottom: 8 })
                      .justifyContent(FlexAlign.Center)
                    })
                  }
                  .width('100%')
                  .padding({ left: 4, right: 16 })
                }
                .border({ width: 1, color: '#E5E5E5' })
                .borderRadius(8)
                .width('92%')
                .backgroundColor('#FFFFFF')
              }
              .width('100%')
              .margin({ top: 12, bottom: 12 })
            }
            .margin({ top: 120, bottom: 120 }) // 添加底部边距，为TabBar留出空间
          }
          .layoutWeight(1)

          // 3. 底部TabBar
          TabBar({ currentIndex: $currentIndex })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
      }

      if (this.budgetVisible) {
        BudgetDialog({
          currentAccount: this.currentAccount,
          currentBudget: this.currentBudget,
          onClose: (bool: boolean) => {
            if (!this.currentAccount?.id) {
              return;
            }
            // 获取预算
            this.getBudget(this.currentAccount?.id, bool);
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}