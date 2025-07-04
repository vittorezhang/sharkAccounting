import { TabItem } from '../viewModel/TabBarListModel';
import { promptAction, router } from '@kit.ArkUI';
import { AuthInterceptor } from '../../../utils/AuthInterceptor';

@Component
export default struct TabBar {
  @Link @Watch('onIndexChange') currentIndex: number // 默认选中"发现"页
  @State timerId: number = 0;
  private tabItems: TabItem[] = [
    { name: '明细', icon: 'app.media.bottom_detail_stroke', activeIcon: 'app.media.bottom_detail_fill' },
    { name: '图表', icon: 'app.media.bottom_chart_stroke', activeIcon: 'app.media.bottom_chart_fill' },
    { name: '记账', icon: 'app.media.bottom_add_pressed' },
    { name: '发现', icon: 'app.media.bottom_find_stroke', activeIcon: 'app.media.bottom_find_fill' },
    {
      name: '我的',
      icon: 'app.media.bottom_me_stroke',
      activeIcon: 'app.media.bottom_me_fill',
      hasRedDot: true
    }
  ]

  private getTabRoute(index: number): string {
    const routes = ['pages/detail', 'pages/chart', 'pages/account', 'pages/find', 'pages/me']
    return routes[index] || 'pages/find'
  }

  // 监听Tab切换
  onIndexChange() {
    console.log('监听Tab切换', this.currentIndex);
    // 先清除已有定时器（防止重复）
    if (this.timerId) {
      clearTimeout(this.timerId);
      this.timerId = 0;
    }

    AuthInterceptor.checkWithRefresh().then(valid => {
      if (!valid) {
        console.log('token已失效，请重新登录');
        promptAction.showToast({
          message: 'token已失效，请重新登录',
          duration: 1500,
        });

        // 设置新定时器
        this.timerId = setTimeout(() => {
          router.replaceUrl({
            url: 'pages/Index',
            params: { keepSession: false }
          });
        }, 1500);
        return; // 终止后续逻辑
      }

      // Token有效时正常切换
      router.replaceUrl({
        url: this.getTabRoute(this.currentIndex)
      });
    });
  }

  onPageHide() {
    // 页面隐藏时清除定时器
    if (this.timerId) {
      clearTimeout(this.timerId);
      this.timerId = 0;
    }
  }

  build() {
    Column() {
      Divider().strokeWidth(1).color('#F0F0F0')
      Row() {
        ForEach(this.tabItems, (item: TabItem, index) => {
          Column() {
            Stack() {
              Image($r((this.currentIndex === index && item.activeIcon) ? item.activeIcon : item.icon))
                .width(index === 2 ? 48 : '100%')
                .height(index === 2 ? 48 : '100%')
                .margin({ bottom: index === 2 ? 56 : 0 })

              if (item.hasRedDot) {
                Circle()
                  .width(8)
                  .height(8)
                  .fill('#FF0000')
                  .position({ x: 42, y: 0 })
              }
            }

            Text(index === 2 ? item.name : '')
              .fontSize(12)
              .margin({ top: index === 2 ? -20 : 0 })
          }
          .width('20%')
          .onClick(() => this.currentIndex = index)
        })
      }
      .height(56)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
  }
}