import TabBar from '../components/TabBar'
import BudgetRow from '../components/BudgetRow'
import { budgetRowItem, iconItem } from '../viewModel/commonFunction'

@Entry
@Component
struct FindPage {
  @State private currentIndex: number = 3 // 默认显示发现页
  @State progress: number = 1.0 // 进度值(0-1)
  private budgetRowList: budgetRowItem[] = [
    { label: '剩余预算：', value: '999.00' },
    { label: '本月预算：', value: '999.00' },
    { label: '本月支出：', value: '0.00' },
  ]
  private commonFunctionList: iconItem[] = [
    { name: '省钱优惠券', icon: 'app.media.coupon_icon' },
    { name: '资产管家', icon: 'app.media.asset_icon' },
    { name: '发票助手', icon: 'app.media.invoice_icon' },
    { name: '房贷计算器', icon: 'app.media.loan_icon' },
    { name: '汇率计算器', icon: 'app.media.exchange_icon' },
  ]

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 1. 顶部黄色标题栏
          Text('发现')
            .width('100%')
            .height(56)
            .fontSize(20)
            .fontColor('#FFFFFF')
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

              Row() {
                Row() {
                  Row() {
                    Text('06').fontWeight(500).fontSize(26)
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
                  Text('198.00').fontSize(18).fontColor('#333333')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 8, right: 24 })

                Column({ space: 12 }) {
                  Text('支出').fontSize(14).fontColor('#999999')
                  Text('0.00').fontSize(18).fontColor('#333333')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ right: 24 })

                Column({ space: 12 }) {
                  Text('结余').fontSize(14).fontColor('#999999')
                  Text('198.00').fontSize(18).fontColor('#333333')
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
                  Text('06月总预算')
                    .fontSize(18)
                    .fontWeight(500)
                    .padding({ right: 8 })
                    .margin({ bottom: 4 })
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
                      .strokeDashArray([Math.PI * 80 * this.progress])

                    // 进度文本（居中）
                    Column() {
                      Text('剩余')
                        .fontSize(14)
                        .fontColor('#999999')
                      Text('100%')
                        .fontSize(20)
                        .fontColor('#333333')
                        .margin({ top: 4 })
                    }
                  }
                }
                .width('36%')
                .alignItems(HorizontalAlign.Center)

                Column({ space: 12 }) {
                  Row() {
                    // 右侧箭头图标
                    Image($r('app.media.ic_arrow_right'))
                      .width(20)
                      .height(20)
                  }
                  .width('100%')
                  .margin({ left: 2, bottom: 4 })
                  .justifyContent(FlexAlign.End)

                  BudgetRow({ budgetRowList: this.budgetRowList })
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
    }
    .width('100%')
    .height('100%')
  }
}