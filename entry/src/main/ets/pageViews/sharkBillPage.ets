import { router } from "@kit.ArkUI";

interface RouteParams {
  userName: string;
  income?: string;
  expenses?: string;
}

@Entry
@Component
struct SharkBillPage {
  // 用户信息区
  @State userName: string = '';
  @State usageDays: number = 17;
  @State currentMonth: string = '7月账单';
  // 收入&支出区
  @State currentBalance: number = 0;
  @State lastMonthBalance: number = 0;
  @State income: number = 0;
  @State expenses: number = 0;
  @State maxValue: number = 0;
  @State incomeWidth: number = 0;
  @State expensesWidth: number = 0;

  onPageShow() {
    const params = router.getParams() as RouteParams;
    if (params.userName) {
      this.userName = params.userName;
      this.income = Number(params.income);
      this.expenses = Number(params.expenses);
      this.maxValue = Number(params.income);
      // 初始化动画（从左到右展开）
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.incomeWidth = (Number(this.income) / this.maxValue) * 100;
        this.expensesWidth = (Number(this.expenses) / this.maxValue) * 100;
        this.currentBalance = Number(this.income) - Number(this.expenses)
      })
    }
  }

  build() {
    // 用户信息区
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column({ space: 10 }) {
          // 头像占位
          Row() {
            Image($r('app.media.avatar'))
              .width(48)
              .height(48)
              .borderRadius(24)
              .border({ width: 2, color: '#FFFFFF' })
            Text(this.userName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
          }
          .margin({ right: 12 })

          // 文字信息
          Column({ space: 4 }) {
            Text(this.currentMonth)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ top: 4 })

            Text(`这是你和鲨鱼记账相识的第${this.usageDays}天`)
              .fontSize(12)
              .fontColor('#999999')
              .margin({ top: 8 })
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Image($r('app.media.ic_pie_chart'))
            .width(120)
            .height(120)
        }
      }
      .padding(16)
      .width('100%')
      .backgroundColor('#E8EBF0')

      // 收入&支出区
      Column() {
        // 本月/上月结余行
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          // 本月结余
          Column({ space: 4 }) {
            Text('本月结余')
              .fontSize(14)
              .fontColor('#666666')
            Text(`${this.currentBalance.toFixed(2)}`)
              .fontSize(24)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          // 上月结余
          Column({ space: 4 }) {
            Text('上月结余')
              .fontSize(14)
              .fontColor('#666666')
            Text(`${this.lastMonthBalance.toFixed(2)}`)
              .fontSize(24)
              .fontColor('#999999')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .padding({ top: 16, bottom: 16 })

        // 横向柱状图
        Column() {
          // 支出柱状图
          Row() {
            // 标签文字
            Text('支出')
              .fontSize(14)
              .fontColor('#666666')
              .width(40)

            // 柱状图容器（确保左对齐）
            Column() {
              Stack() {
                // 灰色背景（全宽）
                Column()
                  .width('100%')
                  .height(12)
                  .backgroundColor('#F0F0F0')
                  .borderRadius(6)

                // 动态黄色进度条（从左向右增长）
                Row() {
                  Column()
                    .width(`${this.expensesWidth}%`)
                    .height(12)
                    .backgroundColor('#FFD700')
                    .borderRadius(6)
                }
                .width('100%')
                .justifyContent(FlexAlign.Start) // 关键：确保从左开始
              }
            }
            .layoutWeight(1)
            .height(12)

            // 金额显示
            Text(`${this.expenses.toFixed(2)}`)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 8 })
          }
          .padding({ top: 8, bottom: 8 })
          .width('100%')

          // 收入柱状图
          Row() {
            // 标签文字
            Text('收入')
              .fontSize(14)
              .fontColor('#666666')
              .width(40)

            // 柱状图容器
            Column() {
              Stack() {
                // 灰色背景
                Column()
                  .width('100%')
                  .height(12)
                  .backgroundColor('#F0F0F0')
                  .borderRadius(6)

                // 动态黄色进度条（从左向右增长）
                Row() {
                  Column()
                    .width(`${this.incomeWidth}%`)
                    .height(12)
                    .backgroundColor('#FFD700')
                    .borderRadius(6)
                }
                .width('100%')
                .justifyContent(FlexAlign.Start) // 关键：确保从左开始
              }
            }
            .layoutWeight(1)
            .height(12)

            // 金额显示（加粗黑色）
            Text(`${this.income.toFixed(2)}`)
              .fontSize(14)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ left: 8 })
          }
          .padding({ top: 8, bottom: 8 })
          .width('100%')
        }
      }
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({
        radius: 4,
        color: '#10000000',
        offsetX: 0,
        offsetY: 2
      })
      .width('100%')
    }
  }
}