import TabBarComponent from '../components/TabBarComponent'
import { iconItem } from '../viewModel/commonFunction'

@Entry
@Component
struct FinanceApp {
  private commonFunctionList: iconItem[] = [
    { name: '省钱优惠券', icon: 'app.media.coupon_icon' },
    { name: '资产管家', icon: 'app.media.asset_icon' },
    { name: '发票助手', icon: 'app.media.invoice_icon' },
    { name: '房贷计算器', icon: 'app.media.loan_icon' },
    { name: '汇率计算器', icon: 'app.media.exchange_icon' },
  ]

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
          // 2.1 账单
          Column() {
            // 账单表格
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
              // .backgroundColor('#FFD700')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)

              // 表头
              Row() {
                Text('').width('25%').textAlign(TextAlign.Center)
                Text('收入').width('25%').textAlign(TextAlign.Center)
                Text('支出').width('25%').textAlign(TextAlign.Center)
                Text('结余').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)

              // 表格内容
              Row() {
                Row() {
                  Text('06').fontWeight(FontWeight.Bold).fontSize(22)
                  Text('月').padding({ left: 8 })
                  // 左侧横线
                  Divider()
                    .vertical(true)
                    .strokeWidth(1)
                    .color('#E5E5E5')
                    .width(1)
                    .padding({ left: 16 })
                }
                .padding({ left: 16, bottom: 12 })
                .justifyContent(FlexAlign.Center)
                .width('25%')


                Text('198.00').width('25%').textAlign(TextAlign.Center)
                Text('0.00').width('25%').textAlign(TextAlign.Center)
                Text('198.00').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)
            }
            .border({ width: 1, color: '#E5E5E5' })
            .borderRadius(8)
            .width('92%')
            .backgroundColor('#FFFFFF')
          }
          .width('100%')

          //  2.2 预算
          Column() {
            Column() {
              Row() {
                Text('06月总预算')
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

              // 表头
              Row() {
                Text('').width('25%').textAlign(TextAlign.Center)
                Text('收入').width('25%').textAlign(TextAlign.Center)
                Text('支出').width('25%').textAlign(TextAlign.Center)
                Text('结余').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)

              // 表格内容
              Row() {
                Row() {
                  Text('06').fontWeight(FontWeight.Bold).fontSize(22)
                  Text('月').padding({ left: 8 })
                  // 左侧横线
                  Divider()
                    .vertical(true)
                    .strokeWidth(1)
                    .color('#E5E5E5')
                    .width(1)
                    .padding({ left: 16 })
                }
                .padding({ left: 16, bottom: 12 })
                .justifyContent(FlexAlign.Center)
                .width('25%')


                Text('198.00').width('25%').textAlign(TextAlign.Center)
                Text('0.00').width('25%').textAlign(TextAlign.Center)
                Text('198.00').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)
            }
            .margin({ top: 8 })
            .border({ width: 1, color: '#E5E5E5' })
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .width('92%')
          }
          .width('100%')

          //  2.3 资产管家
          Column() {
            Column() {
              Row() {
                Text('资产管家')
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

              // 表头
              Row() {
                Text('').width('25%').textAlign(TextAlign.Center)
                Text('收入').width('25%').textAlign(TextAlign.Center)
                Text('支出').width('25%').textAlign(TextAlign.Center)
                Text('结余').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)

              // 表格内容
              Row() {
                Row() {
                  Text('06').fontWeight(FontWeight.Bold).fontSize(22)
                  Text('月').padding({ left: 8 })
                  // 左侧横线
                  Divider()
                    .vertical(true)
                    .strokeWidth(1)
                    .color('#E5E5E5')
                    .width(1)
                    .padding({ left: 16 })
                }
                .padding({ left: 16, bottom: 12 })
                .justifyContent(FlexAlign.Center)
                .width('25%')


                Text('198.00').width('25%').textAlign(TextAlign.Center)
                Text('0.00').width('25%').textAlign(TextAlign.Center)
                Text('198.00').width('25%').textAlign(TextAlign.Center)
              }
              .width('100%')
              .height(40)
            }
            .margin({ top: 8 })
            .border({ width: 1, color: '#E5E5E5' })
            .borderRadius(8)
            .width('92%')
            .backgroundColor('#FFFFFF')
          }
          .width('100%')

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
              .padding({ left: 16, right: 16 })
            }
            .border({ width: 1, color: '#E5E5E5' })
            .borderRadius(8)
            .width('92%')
            .padding({ bottom: 16 })
            .backgroundColor('#FFFFFF')
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .margin({ bottom: 56 }) // 添加底部边距，为TabBar留出空间
      }
      .layoutWeight(1)

      // 3. 底部TabBar
      TabBarComponent()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}