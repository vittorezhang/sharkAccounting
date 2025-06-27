@Component
export default struct BadgeDialog {
  onClose: (bool: boolean) => void = () => {
  }; // 关闭回调函数

  build() {
    Column() {
      // 放射状背景
      Image($rawfile('radial_background.png'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .position({ x: 0, y: 0 })

      // 弹框内容容器（居中）
      Column() {
        // 徽章内容
        Column() {
          // 徽章圆形区域
          Stack({ alignContent: Alignment.Top }) {
            Image($rawfile('shark_badge.png'))
              .width(240)
              .height(240)
              .margin({
                top: 24
              })
            // 关闭按钮
            Row() {
              Text()
              Image($r('app.media.close_icon'))
                .width(24)
                .height(24)
                .onClick(() => {
                  this.onClose(false);
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, right: 8 })
          }

          Column() {
            Image($rawfile('shark_text.png'))
              .width(110)
              .height(30)
              .offset({ x: 4, y: -6 }) // 向右偏移20vp，向上偏移10vp
            Column({ space: 16 }) {
              Text('搬砖的徽章')
                .fontSize(24)
                .fontColor($r('sys.color.black'))

              Text('工资累计记账1笔')
                .fontSize(18)
                .fontColor($r('sys.color.black'))
                .margin({ bottom: 24 })
            }
            .margin({ top: 16 })
          }
          .width('100%')
          .backgroundColor('#FFD700')
        }
        .width('80%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .alignItems(HorizontalAlign.Center)

        // 炫耀按钮
        Button('炫耀一下', { type: ButtonType.Normal })
          .width('70%')
          .height(40)
          .backgroundColor('#FFD700')
          .borderRadius(16)
          .fontColor('#333333')
          .fontSize(16)
          .margin({ top: 20 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .position({ x: 0, y: 0 })
  }
}