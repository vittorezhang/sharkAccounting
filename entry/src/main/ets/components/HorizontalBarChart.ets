@Component
export default struct HorizontalBarChart {
  @State income: number = 198.00;
  @State expenses: number = 100.00;
  @State maxValue: number = 200;
  @State incomeWidth: number = 0;
  @State expensesWidth: number = 0;

  aboutToAppear() {
    // 初始化动画（从左到右展开）
    animateTo({
      duration: 800,
      curve: Curve.EaseOut
    }, () => {
      this.incomeWidth = (this.income / this.maxValue) * 100;
      this.expensesWidth = (this.expenses / this.maxValue) * 100;
    })
  }

  build() {
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
}