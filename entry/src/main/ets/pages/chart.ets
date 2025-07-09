import { MemoryCache } from '../../../utils/MemoryCache';
import TabBar from '../components/TabBar'
import { RouteData } from '../viewModel/commonFunction';

@Entry
@Component
struct ChartPage {
  @State private currentIndex: number = 1

  onPageShow() {
    // 临时存储路由数据
    console.log('临时存储路由数据--pages/chart')
    const routeData: RouteData = {
      currentRoutePath: 'pages/chart',
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
      // 1. 顶部黄色标题栏
      Text('图表')
        .width('100%')
        .height(56)
        .fontSize(20)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
        .backgroundColor('#FFD700')

      // 2. 主内容区
      Scroll() {
        Column() {
          Text('页面-图表')
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