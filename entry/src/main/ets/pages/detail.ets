import TabBar from '../components/TabBar'
import FinanceHeader from '../components/FinanceHeader'
import { MemoryCache } from '../../../utils/MemoryCache';
import { RouteData } from '../viewModel/commonFunction';

interface Transaction {
  type: string;
  amount: number;
  icon: string;
  category: 'income' | 'expense';
}

@Entry
@Component
struct DetailPage {
  @State private currentIndex: number = 0
  @State currentDate: string = '06月25日 星期三';
  @State income: number = 198.00;
  @State expenses: number = 0.00;
  @State transactions: Transaction[] = [
    {
      type: '工资',
      icon: 'app.media.sms_app_icon',
      amount: 99,
      category: 'income'
    },
    {
      type: '兼职',
      icon: 'app.media.sms_app_icon',
      amount: 99,
      category: 'income'
    }
  ];

  onPageShow() {
    // 临时存储路由数据
    console.log('临时存储路由数据--pages/detail')
    const routeData: RouteData = {
      currentRoutePath: 'pages/detail',
      currentIndex: this.currentIndex
    };

    // 存储1200秒自动过期
    MemoryCache.set('cache_route', {
      key: 'cache_route',
      value: routeData,
      ttl: 1200000 // 1200秒后自动删除
    });
  }

  build() {
    Column() {
      // 1. 顶部标题栏
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Row() {
          Image($r('app.media.left_logo'))
            .width(32)
            .height(32)
        }
        .width('14%')
        .justifyContent(FlexAlign.End)

        Row() {
          Text('鲨鱼记账')
            .height(56)
            .fontSize(24)
            .fontWeight(500)
            .fontColor('#333333')
            .padding({ right: 32 })
        }
        .width('90%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .backgroundColor('#FFD700')

      // 2. 主内容区
      Scroll() {
        Column() {
          // 财务管理应用顶部模块
          FinanceHeader()

          // 当日交易记录
          Column() {
            // 日期标题
            Row() {
              Text(this.currentDate)
                .fontSize(16)
                .fontColor('#999999')
                .fontWeight(500)

              Blank()

              Text(`收入:${this.income}`)
                .fontSize(14)
                .fontColor('#999999')
            }
            .width('100%')
            .padding(16)

            // 交易列表
            Flex({ direction: FlexDirection.Column }) {
              ForEach(this.transactions, (item: Transaction) => {
                Row() {
                  Row() {
                    Row() {
                      Image($r(item.icon))
                        .width(24)
                        .height(24)
                    }
                  }
                  .padding(16)

                  Row() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Text(item.type)
                        .fontSize(16)

                      Text(`${item.amount}`)
                        .fontSize(16)
                        .fontColor('#333333')
                    }
                    .width('82%')
                  }
                  .border({
                    width: {
                      bottom: 1
                    },
                    color: '#F5F5F5'
                  })
                  .padding(16)
                }
                .width('100%')
                .borderRadius(8)
                .backgroundColor('#FFFFFF')
              })
            }
            .width('100%')
          }
          .width('100%')
          .margin({ top: 64 })
          .layoutWeight(1)
          .backgroundColor('#ffffff')
        }
        .margin({ bottom: 56 }) // 添加底部边距，为TabBar留出空间
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