import { router, promptAction } from '@kit.ArkUI';
import { StorageUtil } from '../../../utils/storage';
import { AuthToken, registerItem } from '../viewModel/commonFunction';

// 登录页面
@Entry
@Component
struct IndexPage {
  @State username: string = '';
  @State password: string = '';
  @State isAgreed: boolean = false;
  @State showErrors: boolean = false;
  @State showSessionTip: boolean = false;
  @State accountList: AuthToken[] = []; // 明确定义类型

  // 校验规则
  private validateForm(): boolean {
    const validations: registerItem = {
      username: this.username.length >= 4 && /^[a-zA-Z0-9_]+$/.test(this.username),
      password: this.password.length >= 6,
      isAgreed: this.isAgreed
    };

    this.showErrors = Object.values(validations).some((v: registerItem) => !v);
    return Object.values(validations).every((v: registerItem) => v);
  }

  async aboutToAppear() {
    const params = router.getParams() as Record<string, string> | undefined;
    if (params?.keepSession) {
      // 显示保持会话的UI提示
      this.showSessionTip = true;
    }
    await this.loadAccounts();
    this.setupDataListener(); // 初始化监听
  }

  async onPageShow() {
    const account = await StorageUtil.getCurrentAccount();
    if (!account?.token || !(await StorageUtil.verifyToken(account.token))) {
      await this.loadAccounts();
      return;
    }
    router.pushUrl({ url: 'pages/detail' });
  }

  async onPageHide() {
    const pref = await StorageUtil.getPreferences();
    pref?.off('change'); // 避免内存泄漏
  }

  private async setupDataListener() {
    const pref = await StorageUtil.getPreferences();
    pref?.on('change', () => this.loadAccounts());
  }

  private async loadAccounts() {
    try {
      const result = await StorageUtil.getAccountList();
      console.log('登录页获取到的accounts', JSON.stringify(result))
      this.accountList = result.accounts;
    } catch (error) {
      console.error('加载账户列表失败:', error);
    }
  }

  // 登录逻辑
  private async handleLogin() {
    if (!this.validateForm()) {
      promptAction.showToast({ message: '请完善登录信息' });
      return;
    }

    const targetAccount = this.accountList.find(
      acc => acc.username === this.username
    );

    if (!targetAccount) {
      promptAction.showDialog({
        title: '账号未注册',
        message: '是否前往注册?',
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '确认', color: '#FF6B6B' }
        ]
      }).then(result => {
        // 点击确定
        if (result.index === 1) {
          router.pushUrl({ url: 'pages/register' });
        }
      });
      return;
    }

    if (targetAccount.password !== this.password) { // 实际项目应加密对比
      promptAction.showToast({ message: '密码错误' });
      return;
    }

    //  生成新Token（有效期1分钟）
    const newToken = StorageUtil.generateToken(targetAccount.id);
    const tokenExpire = Date.now() + 120 * 60 * 1000;

    // 更新账户Token（严格类型）
    const updatedAccount: AuthToken = {
      id: targetAccount.id,
      username: targetAccount.username,
      password: targetAccount.password,
      gender: '男',
      timestamp: Date.now(),
      token: newToken,
      tokenExpire: tokenExpire
    };

    console.log('updatedAccount', JSON.stringify(updatedAccount))
    // 存储并设为当前账户
    await StorageUtil.setAccount(updatedAccount);
    await StorageUtil.setCurrentAccount(targetAccount.id);
    promptAction.showToast({ message: '登录成功' });
    router.replaceUrl({ url: 'pages/detail' });
  }

  // 自动登录功能
  // private async checkAutoLogin() {
  //   const token = await StorageUtil.getAuthToken();
  //   if (token) {
  //     this.username = token.username;
  //     // 实际项目不应该自动填充密码
  //     // this.password = token.password;
  //   }
  // }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        if (this.showSessionTip) {
          Text('您的账户信息仍保留在设备上')
            .fontSize(14)
            .fontColor('#FFD700')
            .margin({ bottom: 16 })
        }
        Column() {
          // 关闭按钮
          Row() {
            Text()
            Image($r('app.media.close_icon'))
              .width(24)
              .height(24)
              .onClick(() => {
                console.log('取消登录，跳注册页面');
                router.pushUrl({
                  url: 'pages/register',
                  params: {}
                })
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 38 })

          // Logo区域
          Row() {
            Image($r('app.media.login_register_logo'))
              .width(150)
              .height(40)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 40, bottom: 10 })

          Text('使用账号密码登录')
            .fontSize(16)
            .fontColor('#A5AAAF')
            .margin({ top: 30, bottom: 16 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 38 })

        // 登录表单区域
        Column() {
          // 账号输入框
          TextInput({ placeholder: '请输入账户名（4-16位字母数字）' })
            .width('90%')
            .height(48)
            .fontSize(16)
            .maxLength(16)
            .placeholderColor('#999999')
            .caretColor('#FFD700')
            .borderRadius(8)
            .borderWidth(1)
            .borderColor(this.showErrors && !/^[a-zA-Z0-9_]{4,}$/.test(this.username) ? '#FF6B6B' : '#E5E5E5')
            .padding({ left: 16 })
            .margin({ bottom: this.showErrors && !/^[a-zA-Z0-9_]{4,}$/.test(this.username) ? 4 : 16 })
            .onChange((value: string) => {
              this.username = value;
            })

          // 用户名错误提示
          if (this.showErrors && !/^[a-zA-Z0-9_]{4,}$/.test(this.username)) {
            Text('账户名需4-16位字母数字')
              .fontSize(12)
              .fontColor('#FF6B6B')
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 16 })
          }

          // 密码输入
          TextInput({ placeholder: '请输入密码（至少6位）' })
            .width('90%')
            .height(48)
            .fontSize(16)
            .type(InputType.Password)
            .maxLength(20)
            .placeholderColor('#999999')
            .caretColor('#FFD700')
            .borderRadius(8)
            .borderWidth(1)
            .borderColor(this.showErrors && this.password.length < 6 ? '#FF6B6B' : '#E5E5E5')
            .padding({ left: 16 })
            .margin({ bottom: this.showErrors && this.password.length < 6 ? 4 : 16 })
            .onChange((value: string) => {
              this.password = value;
            })

          // 密码错误提示
          if (this.showErrors && this.password.length < 6) {
            Text('密码需至少6位')
              .fontSize(12)
              .fontColor('#FF6B6B')
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 16 })
          }

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
            .width('90%')
            .height(48)
            .backgroundColor(this.isAgreed ? '#FFD700' : '#FFE88D')
            .fontColor(this.isAgreed ? '#FFFFFF' : '#999999')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .borderRadius(8)
            .onClick(() => this.handleLogin())
            .enabled(this.isAgreed)
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
                router.pushUrl({
                  url: 'pages/register',
                  params: {}
                })
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
              console.log('微信登录');
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
    .width('100%')
    .height('100%')
  }
}