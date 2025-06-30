import { TabItem } from '../viewModel/TabBarListModel';

@Component
export default struct TabBarComponent {
  @State currentIndex: number = 3 // 默认选中"发现"页
  private tabItems: TabItem[] = [
    { name: '明细', icon: 'app.media.bottom_detail_stroke', activeIcon: 'app.media.bottom_detail_fill' },
    { name: '图表', icon: 'app.media.bottom_chart_stroke', activeIcon: 'app.media.bottom_chart_fill' },
    { name: '记账', icon: 'app.media.bottom_add_pressed' },
    { name: '发现', icon: 'app.media.bottom_find_stroke', activeIcon: 'app.media.bottom_find_fill' },
    {
      name: '我的',
      icon: 'app.media.bottom_me_stroke',
      activeIcon: 'app.media.bottom_me_fill',
      hasRedDot: true
    }
  ]

  build() {
    Column() {
      Divider().strokeWidth(1).color('#F0F0F0')
      Row() {
        ForEach(this.tabItems, (item: TabItem, index) => {
          Column() {
            Stack() {
              Image($r((this.currentIndex === index && item.activeIcon) ? item.activeIcon : item.icon))
                .width(index === 2 ? 48 : '100%')
                .height(index === 2 ? 48 : '100%')
                .margin({ bottom: index === 2 ? 56 : 0 })

              if (item.hasRedDot) {
                Circle()
                  .width(8)
                  .height(8)
                  .fill('#FF0000')
                  .position({ x: 42, y: 0 })
              }
            }

            Text(index === 2 ? item.name : '')
              .fontSize(12)
              .margin({ top: index === 2 ? -20 : 0 })
          }
          .width('20%')
          .onClick(() => this.currentIndex = index)
        })
      }
      .height(56)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
  }
}