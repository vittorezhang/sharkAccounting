import { TabItem } from '../viewModel/TabBarListModel';
import { promptAction, router } from '@kit.ArkUI';
import { AuthInterceptor } from '../../../utils/AuthInterceptor';
import { TAB_ROUTES } from '../common/routes';

@Component
export default struct TabBar {
  @Link @Watch('onIndexChange') currentIndex: number
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
    return TAB_ROUTES[index] || 'pages/detail';
  }

  onIndexChange() {
    console.log('监听Tab切换', this.currentIndex);
    const targetRoute = this.getTabRoute(this.currentIndex);
    // 先清除已有定时器（防止重复）
    if (this.timerId) {
      clearTimeout(this.timerId);
      this.timerId = 0;
    }

    AuthInterceptor.checkRouteAccess(targetRoute).then(valid => {
      if (valid === false && AuthInterceptor.shouldCheckToken(targetRoute)) {
        console.log('token已失效，请重新登录');
        promptAction.showToast({
          message: 'token已失效，请重新登录',
          duration: 1500,
        });
        // 设置新定时器
        this.timerId = setTimeout(() => {
          router.replaceUrl({
            url: 'pages/Index',
            params: { sessionExpired: false }
          });
        }, 1500);
        // 终止后续逻辑
        return;
      }
      console.log('允许访问的情况：1. Token有效 或 2. 路由在白名单中')
      // 允许访问的情况：1. Token有效 或 2. 路由在白名单中
      router.replaceUrl({ url: targetRoute });
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