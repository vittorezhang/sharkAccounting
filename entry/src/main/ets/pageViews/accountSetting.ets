import { router, promptAction } from '@kit.ArkUI';
import { StorageUtil } from '../../../utils/storage';
import { AuthToken } from '../viewModel/commonFunction';

@Entry
@Component
struct AccountSettingsPage {
  @State isLoggedIn: boolean = true;
  @State currentAccount: AuthToken | null = null;

  // 注销账户
  private async handleClearAccount() {
    try {
      const accountId = this.currentAccount?.id;
      if (!accountId) {
        return;
      }
      await StorageUtil.clearAccount(accountId);
      promptAction.showToast({ message: '账户数据已清除' });
      // 返回登录页
      router.replaceUrl({
        url: 'pages/Index',
        params: { cleared: 'true' }
      });
    } catch (error) {
      promptAction.showToast({ message: '清除失败: ' + error.message });
    }
  }

  // 注销账号确认弹窗
  private showClearAccountConfirm() {
    promptAction.showDialog({
      title: '注销账号',
      message: '确认注销当前账号?',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '确认注销', color: '#FF6B6B' }
      ]
    }).then(result => {
      // 点击确定
      if (result.index === 1) {
        this.handleClearAccount()
      }
    });
  }

  // 退出登录
  private handleLogOut = () => {
    // 实际项目应调用退出接口
    this.isLoggedIn = false; // 仅更改登录状态
    promptAction.showToast({ message: '已退出当前登录' });
    router.replaceUrl({
      url: 'pages/Index',
      params: { keepSession: true } // 传递保持会话参数
    });
  };

  // 退出确认弹窗
  private showLogoutConfirm() {
    promptAction.showDialog({
      title: '退出登录',
      message: '确认退出当前登录?',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '确认退出', color: '#FF6B6B' }
      ]
    }).then(result => {
      // 点击确定
      if (result.index === 1) {
        this.handleLogOut()
      }
    });
  }

  aboutToAppear() {
    // 从StorageUtil加载当前账户
    StorageUtil.getCurrentAccount().then(account => {
      console.log('账户设置页的account', JSON.stringify(account))
      this.currentAccount = account;
    });
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 1. 顶部标题栏
          Row() {
            Image($r('app.media.ic_arrow_back'))
              .width(24)
              .height(24)
              .onClick(() => router.back())

            Text('账号设置')
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

          if (this.currentAccount) {
            // 2. 主体内容
            Scroll() {
              Column() {
                // 头像设置
                Row() {
                  Text('头像')
                    .fontSize(16)
                    .fontColor('#333333')
                    .layoutWeight(1)

                  Image($r('app.media.avatar'))
                    .width(48)
                    .height(48)
                    .borderRadius(24)
                    .border({ width: 1, color: '#F0F0F0' })

                  Image($r('app.media.ic_arrow_right'))
                    .width(16)
                    .height(16)
                }
                .width('100%')
                .height(72)
                .padding({ left: 16, right: 16 })
                .backgroundColor('#FFFFFF')
                .onClick(() => {
                  promptAction.showToast({ message: '头像功能待开发' });
                })

                Divider()
                  .strokeWidth(0.5)
                  .color('#F5F5F5')

                // 信息列表
                this.buildInfoItem('ID', this.currentAccount?.id, false, true)
                this.buildInfoItem('昵称', this.currentAccount?.username, true, true)
                this.buildInfoItem('性别', this.currentAccount?.gender, true, true)
                this.buildInfoItem('手机号', this.currentAccount?.phone, true, false)
                this.buildInfoItem('微信', this.currentAccount?.wechat, true, false)
                this.buildInfoItem('应急联系方式', this.currentAccount?.emergencyContact, true)

                // 功能入口
                this.buildFunctionItem('个人信息浏览及导出', false)
                this.buildFunctionItem('申请注销账号', true, '注销后账号无法找回')
              }
              .width('100%')
            }
            .layoutWeight(1)
            .backgroundColor('#F5F5F5')
          }

          // 3. 退出登录按钮
          Button('退出登录', { type: ButtonType.Normal })
            .width('100%')
            .height(48)
            .margin({ top: 12, bottom: 48 })
            .fontSize(16)
            .fontColor('#FF6B6B')
            .backgroundColor('#FFFFFF')
            .onClick(() => this.showLogoutConfirm())
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
  }

  // 构建信息项
  @Builder
  private buildInfoItem(label: string, value?: string, clickable?: boolean, isSet?: boolean) {
    Column() {
      Divider()
        .strokeWidth(0.5)
        .color('#F5F5F5')
      Row() {
        Text(label)
          .fontSize(16)
          .fontColor('#333333')
          .layoutWeight(1)

        Row() {
          Text(value)
            .fontSize(16)
            .fontColor('#999999')
            .margin({ right: 8 })

          if (!isSet) {
            Text('未设置')
              .fontSize(14)
              .fontColor('#F7812F')
              .margin({ right: 4 })
          }
          if (clickable) {
            Image($r('app.media.ic_arrow_right'))
              .width(16)
              .height(16)
          }
        }
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .margin({ top: label == '手机号' ? 12 : 0 })

      Divider()
        .strokeWidth(0.5)
        .color('#F5F5F5')
    }
    .onClick(() => {
      if (clickable) {
        promptAction.showToast({ message: `${label}功能待开发` });
      }
    })
  }

  // 构建功能项
  @Builder
  private buildFunctionItem(label: string, withWarning: boolean, warningText?: string) {
    Column() {
      Divider()
        .strokeWidth(0.5)
        .color('#F5F5F5')

      Row() {
        Text(label)
          .fontSize(16)
          .fontColor(label.includes('注销') ? '#FF6B6B' : '#333333')
          .layoutWeight(1)

        Image($r('app.media.ic_arrow_right'))
          .width(16)
          .height(16)
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .margin({ top: label == '个人信息浏览及导出' ? 12 : 0 })

      if (!withWarning) {
        Divider()
          .strokeWidth(0.5)
          .color('#F5F5F5')
      }
      if (withWarning && warningText) {
        Text(warningText)
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ left: 16, right: 16, bottom: 16 })
          .backgroundColor('#FFFFFF')
      }
    }
    .onClick(() => {
      if (label.includes('注销')) {
        // 注销账户
        this.showClearAccountConfirm();
      } else {
        promptAction.showToast({ message: `${label}功能待开发` });
      }
    })
  }
}