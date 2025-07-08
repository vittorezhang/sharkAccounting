import { router } from '@kit.ArkUI'
import TabBar from '../components/TabBar'

@Entry
@Component
struct AccountPage {
  @State private currentIndex: number = 2
  @State translateY: number = 1000 // 初始在屏幕外
  @State selectedTab: string = '支出'
  @State selectedCategory: string = ''
  // 分类数据（按设计稿顺序）
  @State categories: Category[] = [
    { name: '餐饮', icon: $r('app.media.sharkAccounting') },
    { name: '购物', icon: $r('app.media.sharkAccounting') },
    { name: '日用', icon: $r('app.media.sharkAccounting') },
    { name: '交通', icon: $r('app.media.sharkAccounting') },
    { name: '蔬菜', icon: $r('app.media.sharkAccounting') },
    { name: '水果', icon: $r('app.media.sharkAccounting') },
    { name: '零食', icon: $r('app.media.sharkAccounting') },
    { name: '运动', icon: $r('app.media.sharkAccounting') },
    { name: '娱乐', icon: $r('app.media.sharkAccounting') },
    { name: '通讯', icon: $r('app.media.sharkAccounting') },
    { name: '服饰', icon: $r('app.media.sharkAccounting') },
    { name: '美容', icon: $r('app.media.sharkAccounting') },
    { name: '住房', icon: $r('app.media.sharkAccounting') },
    { name: '居家', icon: $r('app.media.sharkAccounting') },
    { name: '孩子', icon: $r('app.media.sharkAccounting') },
    { name: '长辈', icon: $r('app.media.sharkAccounting') },
    { name: '社交', icon: $r('app.media.sharkAccounting') },
    { name: '旅行', icon: $r('app.media.sharkAccounting') },
    { name: '烟酒', icon: $r('app.media.sharkAccounting') },
    { name: '数码', icon: $r('app.media.sharkAccounting') },
    { name: '汽车', icon: $r('app.media.sharkAccounting') },
    { name: '医疗', icon: $r('app.media.sharkAccounting') },
    { name: '书籍', icon: $r('app.media.sharkAccounting') },
    { name: '学习', icon: $r('app.media.sharkAccounting') },
    { name: '宠物', icon: $r('app.media.sharkAccounting') },
    { name: '礼金', icon: $r('app.media.sharkAccounting') },
    { name: '礼物', icon: $r('app.media.sharkAccounting') },
    { name: '办公', icon: $r('app.media.sharkAccounting') },
    { name: '维修', icon: $r('app.media.sharkAccounting') },
    { name: '捐赠', icon: $r('app.media.sharkAccounting') },
    { name: '彩票', icon: $r('app.media.sharkAccounting') },
    { name: '亲友', icon: $r('app.media.sharkAccounting') }
  ]

  build() {
    Stack() {
      // 主内容区（带动画）
      Column() {
        // 顶部操作栏（黄色背景）
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Row() {
              Text('支出')
                .fontSize(18)
                .fontColor(this.selectedTab === '支出' ? '#333333' : '#999999')
                .fontWeight(FontWeight.Bold)
                .margin({ right: 24 })
                .onClick(() => this.switchTab('支出'))

              Text('收入')
                .fontSize(18)
                .fontColor(this.selectedTab === '收入' ? '#333333' : '#999999')
                .fontWeight(FontWeight.Bold)
                .onClick(() => this.switchTab('收入'))
            }
            .width('65%')
            .justifyContent(FlexAlign.End)

            Row() {
              Text('取消')
                .fontSize(16)
                .fontColor('#666666')
                .onClick(() => this.closePage())
            }
            .width('35%')
            .justifyContent(FlexAlign.End)
          }
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 12
          })
        }
        .backgroundColor('#FFD700')
        .width('100%')

        // 分类网格（4列布局）
        Grid() {
          ForEach(this.categories, (item: Category) => {
            GridItem() {
              Column() {
                Image(item.icon)
                  .width(40)
                  .height(40)
                  .margin({ bottom: 8 })
                Text(item.name)
                  .fontSize(12)
                  .fontColor('#333333')
              }
              .padding(12)
              .backgroundColor(this.selectedCategory === item.name ? '#FFF8E6' : '#FFFFFF')
              .borderRadius(8)
              .onClick(() => this.selectCategory(item.name))
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr') // 4列
        .columnsGap(12)
        .rowsGap(12)
        .padding(16)
        .layoutWeight(1)

        // 底部TabBar
        TabBar({ currentIndex: $currentIndex })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
      .translate({ y: this.translateY })
    }
    .onAppear(() => {
      animateTo({
        duration: 300,
        curve: Curve.EaseOut
      }, () => {
        this.translateY = 0
      })
    })
  }

  private closePage() {
    animateTo({
      duration: 250,
      curve: Curve.EaseIn
    }, () => {
      this.translateY = 1000
    })
    // router.back()
    router.replaceUrl({ url: 'pages/detail' });
  }

  private switchTab(tab: string) {
    animateTo({
      duration: 200,
      curve: Curve.EaseInOut
    }, () => {
      this.selectedTab = tab
      this.selectedCategory = ''
    })
  }

  private selectCategory(name: string) {
    animateTo({
      duration: 150,
      curve: Curve.EaseInOut
    }, () => {
      this.selectedCategory = name
    })
  }
}

interface Category {
  name: string;
  icon: Resource;
}