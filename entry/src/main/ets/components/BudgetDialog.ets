import { StorageUtil } from "../../../utils/Storage";
import { AuthToken, currentBudgetRecord } from "../viewModel/commonFunction";
import { promptAction } from "@kit.ArkUI";

@Component
export default struct BudgetDialog {
  @Prop currentAccount: AuthToken | null;
  @Prop currentBudget: currentBudgetRecord | null = null;
  @State userBudget: string = '';
  @State showErrors: boolean = false;
  onClose: (bool: boolean) => void = () => {
  }; // 关闭回调函数
  // 防抖计时器
  private debounceTimer: number = 0;

  // 防抖函数封装
  private debounce(func: () => void, delay: number) {
    // 清除之前的计时器
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }
    // 设置新的计时器
    this.debounceTimer = setTimeout(() => {
      func();
    }, delay) as number;
  }

  // 提交预算
  private finishBudget() {
    if (!this.currentAccount?.id) {
      return;
    }

    if (this.currentBudget?.amount) {
      this.showErrors =
        !/^\d+(\.\d{1,2})?$/.test(this.userBudget) || !/^\d+(\.\d{1,2})?$/.test(String(this.currentBudget?.amount));
    } else {
      this.showErrors = !/^\d+(\.\d{1,2})?$/.test(String(this.userBudget))
    }
    if (this.showErrors) {
      return;
    }
    if (this.currentBudget?.amount) {
      this.currentBudget.amount = Number(this.userBudget)
    }
    const newRecord: currentBudgetRecord = {
      currentAccountId: this.currentAccount.id,
      accountId: this.currentAccount.id,
      type: 'month',
      amount: Number(this.userBudget) || Number(this.currentBudget?.amount),
      createTime: new Date().toISOString()
    };
    // 使用防抖包装处理逻辑
    this.debounce(() => {
      // 保存预算
      StorageUtil.saveCurrentBudget(newRecord);
      promptAction.showToast({ message: `操作成功` })
    }, 200); // 200ms防抖间隔

    setTimeout(() => {

      this.onClose(false);
    }, 300)
  }

  aboutToAppear(): void {
    this.userBudget = ''
  }

  build() {
    Column() {
      // 弹框内容容器（居中）
      Column() {
        Column({ space: 24 }) {
          Row() {
            // 标题
            Row() {
              Text('设置预算')
                .fontSize(20)
                .fontWeight(500)
            }
            .width('65%')
            .justifyContent(FlexAlign.End)

            // 关闭按钮
            Row() {
              Image($r('app.media.close_icon'))
                .width(24)
                .height(24)
                .onClick(() => {
                  this.onClose(false);
                })
            }
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 8 })

          Column() {
            // 输入框
            TextInput({
              placeholder: '请输入预算',
              text: this.showErrors ? '' : String(this.currentBudget?.amount || '')
            })
              .width('80%')
              .height(48)
              .fontSize(16)
              .placeholderColor('#999999')
              .caretColor('#FFD700')
              .borderRadius(8)
              .borderColor(this.showErrors ? '#FF6B6B' : '#E5E5E5')
              .onChange((value: string) => {
                console.log('value', value)
                this.userBudget = value;
              })
            // 用户名错误提示
            if (this.showErrors) {
              Text('请输入有效数字，最多2位小数')
                .fontSize(12)
                .fontColor('#FF6B6B')
                .width('80%')
                .textAlign(TextAlign.Start)
            }
          }

          Row() {
            // 保存按钮
            Button('保存', { type: ButtonType.Normal })
              .width('80%')
              .height(40)
              .backgroundColor('#FFD700')
              .borderRadius(16)
              .fontColor('#333333')
              .fontSize(16)
              .margin({ top: 20 })
              .onClick(() => {
                this.finishBudget();
              })
          }
        }
        .width('80%')
        .height('30%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .position({ x: 0, y: 0 })
    .zIndex(99999)
  }
}