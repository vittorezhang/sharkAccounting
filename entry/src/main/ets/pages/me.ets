import TabBar from '../components/TabBar';
import { promptAction, router } from '@kit.ArkUI';
import { StorageUtil } from '../../../utils/Storage';
import { actionBarItem, AuthToken, operateAreaItem, RouteData, statsItem } from '../viewModel/commonFunction';
import { MemoryCache } from '../../../utils/MemoryCache';

@Entry
@Component
struct MePage {
  @State private currentIndex: number = 4;
  @State currentAccount: AuthToken | null = null;
  @State private isVip: boolean = false; // VIP状态
  @State private stats: statsItem = {
    consecutiveDays: 2,
    totalDays: 2,
    totalRecords: 2
  };
  private actionBarList: actionBarItem[] = [
    { name: '消息', icon: 'app.media.message' },
    { name: '我的徽章', icon: 'app.media.my_badge' },
    { name: '我的积分', icon: 'app.media.my_point' },
    { name: '邀请好友', icon: 'app.media.invite_friend' },
    { name: '设置', icon: 'app.media.setting' },
  ]
  // 账本管理区
  private accountAreaList: operateAreaItem[] = [
    { name: '我的账本', leftIcon: 'app.media.my_account_book', rightIcon: 'app.media.ic_arrow_right' },
    { name: '家庭账单', leftIcon: 'app.media.home_bills', rightIcon: 'app.media.ic_arrow_right' },
  ]
  // 操作区
  private operateAreaList: operateAreaItem[] = [
    { name: '设置', leftIcon: 'app.media.setting_none', rightIcon: 'app.media.ic_arrow_right' },
    {
      name: '账户安全中心',
      leftIcon: 'app.media.account_safe_center',
      rightIcon: 'app.media.ic_arrow_right',
      hasWarning: true
    },
    { name: '使用帮助', leftIcon: 'app.media.use_help', rightIcon: 'app.media.ic_arrow_right' },
    { name: '意见反馈', leftIcon: 'app.media.feed_back', rightIcon: 'app.media.ic_arrow_right' },
    { name: '去应用市场给鲨鱼记账评分', leftIcon: 'app.media.thumbs_up', rightIcon: 'app.media.ic_arrow_right' },
    { name: '关于鲨鱼记账 V5.30.0', leftIcon: 'app.media.about', rightIcon: 'app.media.ic_arrow_right' },
  ]

  aboutToAppear() {
    // 从StorageUtil加载当前账户
    StorageUtil.getCurrentAccount().then(account => {
      console.log('页面我的account', JSON.stringify(account))
      this.currentAccount = account;
    });
  }

  onPageShow() {
    // 临时存储路由数据
    console.log('临时存储路由数据--pages/me')
    const routeData: RouteData = {
      currentRoutePath: 'pages/me',
      currentIndex: this.currentIndex
    };

    // 存储1200秒自动过期
    MemoryCache.set('cache_route', {
      key: 'cache_route',
      value: routeData,
      ttl: 1200000 // 1200秒后自动删除
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
              .fontColor('#333333')
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
                    Text(this.currentAccount?.username)
                      .fontSize(24)
                      .fontColor('#333333')
                      .margin({ right: 12 })
                  }
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pageViews/accountSetting',
                      params: {}
                    })
                  })

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
                  Image($r('app.media.upgrade'))
                    .width(32)
                    .height(32)
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
                        .width(32)
                        .height(32)
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
                            .width(22)
                            .height(22)
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
                            .width(22)
                            .height(22)
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