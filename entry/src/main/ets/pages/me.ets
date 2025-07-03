import TabBar from '../components/TabBar';
import { promptAction, router } from '@kit.ArkUI';
import { StorageUtil } from '../../../utils/storage';
import { actionBarItem, operateAreaItem, statsItem } from '../viewModel/commonFunction';

@Entry
@Component
struct MePage {
  @State private currentIndex: number = 4;
  @State isLoggedIn: boolean = true;
  @State private isVip: boolean = false; // VIP状态
  @State private stats: statsItem = {
    consecutiveDays: 2,
    totalDays: 2,
    totalRecords: 2
  };
  private actionBarList: actionBarItem[] = [
    { name: '消息', icon: 'app.media.sms_app_icon' },
    { name: '我的徽章', icon: 'app.media.sms_app_icon' },
    { name: '我的积分', icon: 'app.media.sms_app_icon' },
    { name: '邀请好友', icon: 'app.media.sms_app_icon' },
    { name: '设置', icon: 'app.media.sms_app_icon' },
  ]
  // 账本管理区
  private accountAreaList: operateAreaItem[] = [
    { name: '我的账本', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
    { name: '家庭账单', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
  ]
  // 操作区
  private operateAreaList: operateAreaItem[] = [
    { name: '设置', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
    {
      name: '账户安全中心',
      leftIcon: 'app.media.sharkAccounting',
      rightIcon: 'app.media.ic_arrow_right',
      hasWarning: true
    },
    { name: '使用帮助', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
    { name: '意见反馈', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
    { name: '去应用市场给鲨鱼记账评分', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
    { name: '关于鲨鱼记账 V5.30.0', leftIcon: 'app.media.sharkAccounting', rightIcon: 'app.media.ic_arrow_right' },
  ]
  // 注销账户
  // private handleLogOut = async () => {
  //   try {
  //     await StorageUtil.clearAuthToken();
  //     promptAction.showToast({ message: '退出成功' });
  //     router.replaceUrl({ url: 'pages/Index' });
  //   } catch (error) {
  //     promptAction.showToast({ message: '操作失败，请重试' });
  //   }
  // };

  private handleLogOut = () => {
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

  // 升级VIP
  private handleUpgrade = () => {
    promptAction.showToast({ message: '跳转VIP购买页' });
    // router.pushUrl({ url: 'pages/VIP' });
  };

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 1. 顶部黄色标题栏
          Row() {
            Text('我的')
              .fontSize(20)
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height(56)
          .backgroundColor('#FFD700')

          // 2. 主内容区
          Scroll() {
            Column() {
              // 用户信息区
              Column({ space: 16 }) {
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Row({ space: 8 }) {
                    Image($r('app.media.avatar'))
                      .width(50)
                      .height(50).borderRadius(25)
                    Text('who am I')
                      .fontSize(24)
                      .fontColor('#333333')
                      .margin({ right: 12 })
                  }

                  Button(this.isVip ? 'VIP会员' : '已打卡')
                    .fontSize(12)
                    .fontColor('#333333')
                    .backgroundColor('#ffffff')
                    .borderRadius(16)
                    .padding({ left: 12, right: 12 })
                    .height(32)
                }

                // 数据统计
                Row() {
                  Column() {
                    Text(this.stats.consecutiveDays.toString())
                      .fontSize(20)
                      .fontColor('#333333')
                      .textAlign(TextAlign.Center)
                    Text('已连续打卡')
                      .fontSize(12)
                      .fontColor('#999999')
                      .margin({ top: 4 })
                  }
                  .width('33%')

                  Column() {
                    Text(this.stats.totalDays.toString())
                      .fontSize(20)
                      .fontColor('#333333')
                      .textAlign(TextAlign.Center)
                    Text('记账总天数')
                      .fontSize(12)
                      .fontColor('#999999')
                      .margin({ top: 4 })
                  }
                  .width('33%')

                  Column() {
                    Text(this.stats.totalRecords.toString())
                      .fontSize(20)
                      .fontColor('#333333')
                      .textAlign(TextAlign.Center)
                    Text('记账总笔数')
                      .fontSize(12)
                      .fontColor('#999999')
                      .margin({ top: 4 })
                  }
                  .width('33%')
                }
                .width('100%')
              }
              .height(180)
              .padding(16)
              .backgroundColor('#FFD700')

              // VIP升级提示
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Row({ space: 8 }) {
                  Image($r('app.media.wechat_icon'))
                    .width(20)
                    .height(20)
                  Column() {
                    Text('升级为VIP')
                      .fontSize(16)
                      .fontColor('#333333')
                    Text('畅享更多高级功能')
                      .fontSize(12)
                      .fontColor('#999999')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)
                }

                Row() {
                  // 右侧箭头图标
                  Image($r('app.media.ic_arrow_right'))
                    .width(20)
                    .height(20)
                }
              }
              .width('92%')
              .padding(8)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .margin({ bottom: 16 })
              .position({
                x: 16,
                y: 140
              })
              .onClick(this.handleUpgrade)

              // 功能图标区
              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Row() {
                  ForEach(this.actionBarList, (item: actionBarItem) => {
                    Column() {
                      Image($r(item.icon))
                        .width(24)
                        .height(24)
                      Text(item.name)
                        .fontSize(12)
                        .fontColor('#333333')
                        .margin({ top: 8 })
                    }
                    .width('20%')
                  })
                }
                .borderRadius(8)
                .backgroundColor('#FFFFFF')
                .padding({ top: 12, bottom: 12 })
              }
              .width('92%')
              .margin({ top: 24, bottom: 12 })


              // 操作项
              Column({ space: 8 }) {
                // 账本管理区
                Column() {
                  ForEach(this.accountAreaList, (item: operateAreaItem, index) => {
                    Column({ space: 12 }) {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Row({ space: 4 }) {
                          // 左侧图标
                          Image($r(item.leftIcon))
                            .width(20)
                            .height(20)
                          Column() {
                            Text(item.name)
                              .fontSize(16)
                              .fontColor('#333333')
                              .textAlign(TextAlign.Start)
                            if (index == 0) {
                              Divider()
                                .strokeWidth(1)
                                .color('#F0F0F0')
                                .padding({ top: 8 })
                            }
                          }
                          .alignItems(HorizontalAlign.Start)
                          .padding({ top: index == 0 ? 8 : 0 })
                        }

                        Row() {
                          // 右侧箭头图标
                          Image($r(item.rightIcon))
                            .width(20)
                            .height(20)
                        }
                      }
                    }
                    .margin({ bottom: 12 })
                  })
                }
                .width('100%')
                .padding({
                  top: 16,
                  right: 16,
                  bottom: 0,
                  left: 16
                })
                .backgroundColor('#FFFFFF')
                .borderRadius(8)
                .margin({ bottom: 4 })
                .alignItems(HorizontalAlign.Start)

                // 设置区
                Column() {
                  ForEach(this.operateAreaList, (item: operateAreaItem, index) => {
                    Column({ space: 12 }) {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Row({ space: 4 }) {
                          // 左侧图标
                          Image($r(item.leftIcon))
                            .width(20)
                            .height(20)
                          Column() {
                            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Baseline }) {
                              Text(item.name)
                                .fontSize(16)
                                .fontColor('#333333')
                                .textAlign(TextAlign.Start)
                              if (index == 1) {
                                Text('高风险')
                                  .fontSize(12)
                                  .fontColor('#FF6B6B')
                              }
                            }
                            .width('92%')

                            Row() {
                              if (index != 5) {
                                Divider()
                                  .strokeWidth(1)
                                  .color('#F0F0F0')
                                  .padding({ top: 8 })
                              }
                            }
                          }
                          .alignItems(HorizontalAlign.Start)
                          .padding({ top: index != 5 ? 8 : 0 })
                        }

                        Row() {
                          // 右侧箭头图标
                          Image($r(item.rightIcon))
                            .width(20)
                            .height(20)
                        }
                      }
                    }
                    .margin({ bottom: 12 })
                  })
                }
                .width('100%')
                .padding({
                  top: 16,
                  right: 16,
                  bottom: 0,
                  left: 16
                })
                .backgroundColor('#FFFFFF')
                .borderRadius(8)
                .margin({ bottom: 16 })
                .alignItems(HorizontalAlign.Start)
              }
              .width('92%')
            }
            .width('100%')
          }
          .layoutWeight(1)

          // 退出登录按钮
          Button('退出登录', { type: ButtonType.Normal })
            .width('90%')
            .height(48)
            .fontSize(16)
            .backgroundColor('#FFFFFF')
            .fontColor('#FF6B6B')
            .border({
              width: 1,
              color: '#FF6B6B',
              radius: 8
            })
            .margin({ bottom: 24 })// .onClick(this.handleLogOut)
            .onClick(() => {
              this.showLogoutConfirm()
            })

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