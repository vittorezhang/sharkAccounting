import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { StorageUtil } from '../../../utils/storage';
import { AuthToken, registerItem } from '../viewModel/commonFunction';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isAgreed: boolean = false;
  @State showErrors: boolean = false;

  // 校验规则
  private validateForm(): boolean {
    const validations: registerItem = {
      username: this.username.length >= 4 && /^[a-zA-Z0-9_]+$/.test(this.username),
      password: this.password.length >= 6,
      passwordMatch: this.password === this.confirmPassword,
      isAgreed: this.isAgreed
    };

    this.showErrors = Object.values(validations).some((v: registerItem) => !v);
    return Object.values(validations).every((v: registerItem) => v);
  }

  // 注册逻辑
  private async handleRegister() {
    if (!this.validateForm()) {
      promptAction.showToast({ message: '请完善注册信息' });
      return;
    }

    try {
      // 生成唯一ID（实际项目应使用更安全的生成方式）
      const accountId = `user_${Date.now()}`;
      // 构建账户数据
      const newAccount: AuthToken = {
        id: accountId,
        username: this.username,
        password: this.password,
        token: StorageUtil.generateToken(accountId),
        tokenExpire: Date.now() + 1 * 60 * 1000,
        timestamp: Date.now()
      };
      console.log('newAccount', JSON.stringify(newAccount))
      // 存储新账户
      await StorageUtil.setAccount(newAccount);
      // 自动设为当前账户
      await StorageUtil.setCurrentAccount(accountId);

      promptAction.showToast({ message: '注册成功' });
      router.replaceUrl({ url: 'pages/Index' });
    } catch (error) {
      promptAction.showToast({ message: '注册失败: ' + error.message });
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Row() {
          Image($r('app.media.ic_arrow_back'))
            .width(24)
            .height(24)

          Text('返回').fontSize(16)
        }.onClick(() => router.back())

        Text('注册')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ top: 16, right: 16, bottom: 32 })

      // Logo区域
      Row() {
        Image($r('app.media.login_register_logo'))
          .width(150)
          .height(40)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: 32, bottom: 32 })

      // 表单区域
      Column() {
        // 用户名输入
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

        // 确认密码
        TextInput({ placeholder: '请再次输入密码' })
          .width('90%')
          .height(48)
          .fontSize(16)
          .type(InputType.Password)
          .maxLength(20)
          .placeholderColor('#999999')
          .caretColor('#FFD700')
          .borderRadius(8)
          .borderWidth(1)
          .borderColor(this.showErrors && this.password !== this.confirmPassword ? '#FF6B6B' : '#E5E5E5')
          .padding({ left: 16 })
          .margin({ bottom: this.showErrors && this.password !== this.confirmPassword ? 4 : 16 })
          .onChange((value: string) => {
            this.confirmPassword = value;
          })

        // 确认密码错误提示
        if (this.showErrors && this.password !== this.confirmPassword) {
          Text('两次密码输入不一致')
            .fontSize(12)
            .fontColor('#FF6B6B')
            .width('90%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: 16 })
        }

        // 协议勾选
        Row() {
          Checkbox()
            .select(this.isAgreed)
            .selectedColor('#FFD700')
            .onChange((checked: boolean) => {
              this.isAgreed = checked;
            })
            .size({ width: 16, height: 16 })
            .margin({ right: 8 })

          Text('已阅读并同意')
            .fontSize(14)
            .fontColor('#999999')

          Text('《用户协议》')
            .fontSize(14)
            .fontColor('#FFD700')
            .onClick(() => {
              // 跳转用户协议
            })

          Text('和')
            .fontSize(14)
            .fontColor('#999999')

          Text('《隐私协议》')
            .fontSize(14)
            .fontColor('#FFD700')
            .onClick(() => {
              // 跳转隐私协议
            })
        }
        .width('90%')
        .margin({ top: 8, bottom: 32 })

        // 注册按钮
        Button('注册', { type: ButtonType.Normal })
          .width('90%')
          .height(48)
          .backgroundColor(this.isAgreed ? '#FFD700' : '#E5E5E5')
          .fontColor(this.isAgreed ? '#FFFFFF' : '#999999')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .borderRadius(8)
          .onClick(() => this.handleRegister())
          .enabled(this.isAgreed)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}