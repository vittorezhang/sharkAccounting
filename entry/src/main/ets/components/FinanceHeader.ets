import { actionBarItem } from "../viewModel/commonFunction";

@Component
export default struct FinanceHeader {
  @State currentYear: string = '2025年';
  @State income: number = 198;
  @State expenses: number = 0;
  private actionBarList: actionBarItem[] = [
    { name: '账单', icon: 'app.media.sms_app_icon' },
    { name: '预算', icon: 'app.media.sms_app_icon' },
    { name: '资产管家', icon: 'app.media.sms_app_icon' },
    { name: '购物返现', icon: 'app.media.sms_app_icon' },
    { name: '更多', icon: 'app.media.sms_app_icon' },
  ]

  build() {
    Stack() {
      Column() {
        // 顶部标题栏 (黄色背景)
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column({ space: 8 }) {
              // 年份显示
              Row() {
                Text(this.currentYear)
                  .fontSize(16)
                  .fontColor('#999999')
              }

              // 月份选择
              Row() {
                Text('06')
                  .fontSize(24)
                  .fontColor('#333333')
                Row() {
                  Text('月')
                    .fontSize(12)
                    .fontColor('#333333')
                  Image($r('app.media.sharkAccounting'))// 下拉箭头图标
                    .width(16)
                    .height(16)
                    .padding({ left: 4 })
                }
                .padding({ top: 6 })
              }
              .width('22%')
              .border({
                width: {
                  right: 1
                },
                color: '#cccccc'
              })
            }
            .alignItems(HorizontalAlign.Start)

            // 收入支出统计
            Column() {
              Row({ space: 64 }) {
                Column({ space: 12 }) {
                  Text('收入')
                    .fontSize(14)
                    .fontColor('#999999')
                  Row() {
                    Text(`${this.income}`)
                      .fontSize(20)
                      .fontColor('#333333')
                    Row() {
                      Text('.00')
                        .fontSize(12)
                        .fontColor('#333333')
                    }
                    .padding({ top: 6, left: 6 })
                  }
                }
                .alignItems(HorizontalAlign.Start)

                Column({ space: 12 }) {
                  Text('支出')
                    .fontSize(14)
                    .fontColor('#999999')
                  Row() {
                    Text(`${this.expenses}`)
                      .fontSize(20)
                      .fontColor('#333333')
                    Row() {
                      Text('.00')
                        .fontSize(12)
                        .fontColor('#333333')
                    }
                    .padding({ top: 6, left: 6 })
                  }
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
            }
            .width('75%')
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .backgroundColor('#FFD700')
        .width('100%')

        // 功能图标区
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Row() {
            ForEach(this.actionBarList, (item: actionBarItem) => {
              Column() {
                Image($r(item.icon))
                  .width(24)
                  .height(24)
                Text(item.name)
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 8 })
              }
              .width('20%')
            })
          }
          .borderRadius(4)
          .backgroundColor('#FFFFFF')
          .padding({ top: 12, bottom: 12 })
        }
        .width('92%')
        .position({
          x: 14, // 距离左侧20vp
          y: 56  // 距离顶部100vp
        })
      }
    }
  }
}