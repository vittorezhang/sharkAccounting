import TabBarComponent from '../components/TabBarComponent'

@Entry
@Component
struct FinanceApp {
  build() {
    Column() {
      // 1. 顶部黄色标题栏
      Text('发现')
        .width('100%')
        .height(56)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .backgroundColor('#FFD700')

      // 2. 主内容区
      Scroll() {
        Column() {
          // 2.1 账单模块
          Column() {
            Row() {
              Text('账单').fontSize(16).fontColor('#333333')
              Text('06月').fontSize(14).fontColor('#666666').margin({ left: 8 })
            }
            .margin({ bottom: 16 })

            Row() {
              Column() {
                Text('收入').fontSize(14).fontColor('#999999')
                Text('198.00').fontSize(18).fontColor('#FF6B6B')
              }

              Column() {
                Text('支出').fontSize(14).fontColor('#999999')
                Text('0.00').fontSize(18).fontColor('#4CAF50')
              }

              Column() {
                Text('结余').fontSize(14).fontColor('#999999')
                Text('198.00').fontSize(18).fontColor('#333333')
              }
            }
            .justifyContent(FlexAlign.SpaceAround)
          }
          .padding(16)

          // 2.2 预算模块
          Column() {
            Row() {
              Text('06月总预算').fontSize(16).fontColor('#333333')
            }
            .margin({ bottom: 16 })

            Column() {
              Row() {
                Text('剩余预算:').fontSize(14).fontColor('#999999')
                Text('999.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }

              Row() {
                Text('本月预算:').fontSize(14).fontColor('#999999')
                Text('999.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }

              Row() {
                Text('本月支出:').fontSize(14).fontColor('#999999')
                Text('0.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }
            }
          }
          .padding(16)

          // 2.3 资产管家模块
          Column() {
            Row() {
              Text('资产管家').fontSize(16).fontColor('#333333')
            }
            .margin({ bottom: 16 })

            Column() {
              Row() {
                Text('净资产').fontSize(14).fontColor('#999999')
                Text('800000.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }

              Row() {
                Text('资产').fontSize(14).fontColor('#999999')
                Text('800000.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }

              Row() {
                Text('负债').fontSize(14).fontColor('#999999')
                Text('0.00').fontSize(14).fontColor('#333333').margin({ left: 8 })
              }
            }
          }
          .padding(16)

          // 2.4 常用功能区
          Column() {
            Row() {
              Text('常用功能').fontSize(16).fontColor('#333333')
            }
            .margin({ bottom: 16 })

            Grid() {
              GridItem() {
                Column() {
                  // Image($r('app.media.coupon_icon')).width(40).height(40)
                  Text('省钱优惠券').fontSize(12).margin({ top: 8 })
                }
              }

              GridItem() {
                Column() {
                  // Image($r('app.media.asset_icon')).width(40).height(40)
                  Text('资产管家').fontSize(12).margin({ top: 8 })
                }
              }

              GridItem() {
                Column() {
                  // Image($r('app.media.invoice_icon')).width(40).height(40)
                  Text('发票助手').fontSize(12).margin({ top: 8 })
                }
              }

              GridItem() {
                Column() {
                  // Image($r('app.media.loan_icon')).width(40).height(40)
                  Text('房贷计算器').fontSize(12).margin({ top: 8 })
                }
              }

              GridItem() {
                Column() {
                  // Image($r('app.media.exchange_icon')).width(40).height(40)
                  Text('汇率换算器').fontSize(12).margin({ top: 8 })
                }
              }
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .columnsGap(16)
            .rowsGap(16)
          }
          .padding(16)
        }
      }
      .layoutWeight(1)

      // 3. 底部TabBar
      TabBarComponent()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}