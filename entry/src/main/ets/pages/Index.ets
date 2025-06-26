// 登录页面
@Entry
@Component
struct Index {
  @State phoneNumber: string = '';
  @State password: string = '';
  @State isAgreed: boolean = false;
  @State showPassword: boolean = false;

  build() {
    Column() {
      // Logo区域
      Column() {
        Row() {
          Image($r('app.media.shark_logo'))
            .width(40)
            .height(40)
            .margin({ right: 10 })
          Text('鲨鱼记账')
            .fontSize(24)
            .fontColor('#000000')
        }
        .margin({ top: 40, bottom: 10 })

        Text('使用手机号密码登录')
          .fontSize(16)
          .fontColor('#A5AAAF')
          .margin({ top: 30, bottom: 16 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 38 })

      // 登录表单区域
      Column() {
        // 手机号输入框
        TextInput({ placeholder: '请输入手机号' })
          .width('90%')
          .height(48)
          .fontSize(16)
          .type(InputType.Number)
          .maxLength(11)
          .placeholderColor('#999999')
          .caretColor('#FFD700')
          .borderRadius(8)
          .borderWidth(1)
          .borderColor('#E5E5E5')
          .padding({ left: 16 })
          .margin({ bottom: 20 })
          .onChange((value: string) => {
            this.phoneNumber = value;
          })

        // 密码输入框
        Row() {
          TextInput({ placeholder: '请输入密码' })
            .width('100%')
            .height(48)
            .fontSize(16)
            .type(this.showPassword ? InputType.Normal : InputType.Password)
            .maxLength(20)
            .placeholderColor('#999999')
            .caretColor('#FFD700')
            .borderRadius(8)
            .borderWidth(1)
            .borderColor('#E5E5E5')
            .onChange((value: string) => {
              this.password = value;
            })
        }
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .margin({ bottom: 20 })

        // 协议勾选区域
        Row() {
          Checkbox()
            .select(this.isAgreed)
            .selectedColor('#FFD700')
            .onChange((isChecked: boolean) => {
              this.isAgreed = isChecked;
            })
            .size({
              width: 12,
              height: 12
            })
            .margin({ right: 8 })

          Text('已阅读并同意')
            .fontSize(12)
            .fontColor('#A5AAAF')
          Row() {
            Text('《')
              .fontSize(12)
              .fontColor('#A5AAAF')
            Text('用户协议')
              .fontSize(12)
              .fontColor('#A5AAAF')
              .decoration({
                type: TextDecorationType.Underline
              })
              .onClick(() => {
                // 跳转用户协议
              })
            Text('》')
              .fontSize(12)
              .fontColor('#A5AAAF')

            Text('和')
              .fontSize(12)
              .fontColor('#A5AAAF')

            Text('《')
              .fontSize(12)
              .fontColor('#A5AAAF')
            Text('隐私协议')
              .fontSize(12)
              .fontColor('#A5AAAF')
              .decoration({
                type: TextDecorationType.Underline
              })
              .onClick(() => {
                // 跳转隐私协议
              })
            Text('》')
              .fontSize(12)
              .fontColor('#A5AAAF')
          }
        }
        .width('90%')
        .margin({ top: 24, bottom: 16 })

        // 登录按钮
        Button('登录', { type: ButtonType.Normal })
          .borderRadius(8)
          .width('90%')
          .height(48)
          .backgroundColor(Boolean(this.phoneNumber) && Boolean(this.password) && this.isAgreed ? '#FFD700' : '#FFE88D')
          .fontColor('#000000')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            // 登录逻辑
          })
          .stateEffect(true)
          .enabled(Boolean(this.phoneNumber) && Boolean(this.password) && this.isAgreed)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 底部链接区域
      Column() {
        Row() {
          Text('找回密码')
            .fontSize(14)
            .fontColor('#999999')
            .onClick(() => {
              // 找回密码
            })
          // 添加竖线分隔符
          Divider()
            .vertical(true)
            .strokeWidth(1)
            .color('#E5E5E5')
            .height(14)// 与文字高度一致
            .margin({ left: 16, right: 16 })

          Text('注册账号')
            .fontSize(14)
            .fontColor('#999999')
            .onClick(() => {
              // 注册账号
            })
        }
        .margin({ top: 40, bottom: 60 })

        // 其他登录方式
        Column() {
          Row() {
            // 左侧横线
            Divider()
              .vertical(false)
              .strokeWidth(1)
              .color('#E5E5E5')
              .width(102)
              .margin({ right: 12 })

            Text('其他方式登录')
              .fontSize(14)
              .fontColor('#999999')

            // 右侧横线
            Divider()
              .vertical(false)
              .strokeWidth(1)
              .color('#E5E5E5')
              .width(102)
              .margin({ left: 12 })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 20 })

          // 微信登录
          Button({ type: ButtonType.Normal }) {
            Image($r('app.media.wechat_icon'))
              .width(24)
              .height(24)
          }
          .onClick(() => {
            // 微信登录
            console.log('微信登录')
          })
          .width('90%')
          .height(48)
          .backgroundColor('#FFFFFF')
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 8
          })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}