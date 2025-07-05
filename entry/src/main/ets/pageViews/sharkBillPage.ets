import HorizontalBarChart from '../components/HorizontalBarChart';

@Entry
@Component
struct SharkBillPage {
  // 用户信息区
  @State userName: string = 'test1';
  @State usageDays: number = 2;
  @State currentMonth: string = '6月账单';
  // 收入&支出区
  @State currentBalance: number = 198.00;
  @State lastMonthBalance: number = 0.00;
  @State income: number = 198.00;
  @State expenses: number = 0.00;

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

        // 在页面中嵌入组件
        Column() {
          HorizontalBarChart()
        }

        // 动态更新数据
        // Button('更新数据')
        //   .onClick(() => {
        //     this.income = 250;
        //     this.expenses = 50;
        //   })
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