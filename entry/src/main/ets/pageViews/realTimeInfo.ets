import { router } from '@kit.ArkUI'

@Entry
@Component
struct RealTimeInfoPage {
  build() {
    Stack(){
      Scroll() {
        Column(){
          // 1. 顶部标题栏
          Row() {
            Image($r('app.media.ic_arrow_back'))
              .width(24)
              .height(24)
              .onClick(() => router.back())

            Text('热点资讯')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .fontColor('#333333')
          }
          .width('100%')
          .height(56)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#FFD700')

          // 2. 主体内容
          Scroll(){
            Column() {
              Text('这是热点资讯页面')
                .fontSize(18)
                .fontColor('#333333')
            }
            .width('100%')
          }
          .layoutWeight(1)
          .backgroundColor('#F5F5F5')
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