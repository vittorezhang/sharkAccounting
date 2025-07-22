import { actionBarItem, dateTimeItem } from "../viewModel/commonFunction";
import { promptAction, router } from "@kit.ArkUI";
import DatePickerModal from "./DatePickerModal";

@Component
export default struct FinanceHeader {
  @Prop userName: string = '';
  @Prop income: number = 0;
  @Prop expenses: number = 0;
  callBack: (params: dateTimeItem) => void = () => {
  };

  // 当前年
  private getCurrentYear(): string {
    const now = new Date()
    return `${now.getFullYear()}`
  }

  private actionBarList: actionBarItem[] = [
    { name: '账单', icon: 'app.media.detail_bill' },
    { name: '预算', icon: 'app.media.detail_budget' },
    { name: '资产管家', icon: 'app.media.detail_assetManage' },
    { name: '购物返现', icon: 'app.media.detail_shopRefund' },
    { name: '更多', icon: 'app.media.detail_more' },
  ]

  build() {
    Stack() {
      Column() {
        // 顶部标题栏 (黄色背景)
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column({ space: 8 }) {
              // 年份显示
              Row() {
                Text(this.getCurrentYear())
                  .fontSize(16)
                  .fontColor('#999999')
              }

              // 月份选择
              DatePickerModal({
                dateCallBack: (params: dateTimeItem) => {
                  this.callBack(params)
                }
              })
            }
            .alignItems(HorizontalAlign.Start)

            // 收入支出统计
            Column() {
              Row({ space: 64 }) {
                Column({ space: 12 }) {
                  Text('收入')
                    .fontSize(14)
                    .fontColor('#999999')
                  Row() {
                    Text(`${this.income}`)
                      .fontSize(20)
                      .fontColor('#333333')
                    Row() {
                      Text('.00')
                        .fontSize(12)
                        .fontColor('#333333')
                    }
                    .padding({ top: 6, left: 6 })
                  }
                }
                .alignItems(HorizontalAlign.Start)

                Column({ space: 12 }) {
                  Text('支出')
                    .fontSize(14)
                    .fontColor('#999999')
                  Row() {
                    Text(`${this.expenses}`)
                      .fontSize(20)
                      .fontColor('#333333')
                    Row() {
                      Text('.00')
                        .fontSize(12)
                        .fontColor('#333333')
                    }
                    .padding({ top: 6, left: 6 })
                  }
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
            }
            .width('75%')
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .backgroundColor('#FFD700')
        .width('100%')

        // 功能图标区
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Row() {
            ForEach(this.actionBarList, (item: actionBarItem, index) => {
              Column() {
                Image($r(item.icon))
                  .width(32)
                  .height(32)
                Text(item.name)
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 8 })
              }
              .onClick(async () => {
                if (index == 0) {
                  // 跳转账单页面
                  return router.pushUrl({
                    url: 'pageViews/sharkBillPage',
                    params: {
                      userName: this.userName,
                      income: this.income,
                      expenses: this.expenses
                    }
                  });
                }
                promptAction.showToast({ message: `${item.name}待开发` })
              })
              .width('20%')
            })
          }
          .borderRadius(4)
          .backgroundColor('#FFFFFF')
          .padding({ top: 12, bottom: 12 })
        }
        .width('92%')
        .position({
          x: 14, // 距离左侧20vp
          y: 56  // 距离顶部100vp
        })
      }
    }
  }
}