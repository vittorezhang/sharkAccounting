import font from '@ohos.font';
import { router } from '@kit.ArkUI'
import { MemoryCache } from '../../../utils/MemoryCache';
import TabBar from '../components/TabBar'

interface Category {
  name: string;
  icon: string;
}

interface GeneratedTypeLiteralInterface_1 {
  translateX: number;

  // opacity: number;
  direction: 'left' | 'right';
}

@Entry
@Component
struct AccountPage {
  @State private currentIndex: number = 2
  @State listAnimation: GeneratedTypeLiteralInterface_1 = {
    translateX: 0,
    // opacity: 1,
    direction: 'left'
  }
  @State private animating: boolean = false;
  @State translateY: number = 1000 // 初始在屏幕外
  @State selectedTab: string = '支出'
  @State selectedCategory: string = ''
  // 支出的分类数据
  @State expensesCategories: Category[] = [
    { name: '餐饮', icon: '\ue8a4' },
    { name: '购物', icon: '\ue899' },
    { name: '日用', icon: '\ue604' },
    { name: '交通', icon: '\ue61e' },
    { name: '蔬菜', icon: '\ue713' },
    { name: '水果', icon: '\ue631' },
    { name: '零食', icon: '\ue625' },
    { name: '运动', icon: '\ue69b' },
    { name: '娱乐', icon: '\ue639' },
    { name: '通讯', icon: '\ue632' },
    { name: '服饰', icon: '\ue60d' },
    { name: '美容', icon: '\ue657' },
    { name: '住房', icon: '\ue63b' },
    { name: '居家', icon: '\ue61b' },
    { name: '孩子', icon: '\ue84e' },
    { name: '长辈', icon: '\ue654' },
    { name: '社交', icon: '\ue615' },
    { name: '旅行', icon: '\ue655' },
    { name: '烟酒', icon: '\ue60f' },
    { name: '数码', icon: '\ue611' },
    { name: '汽车', icon: '\ue65d' },
    { name: '医疗', icon: '\ue646' },
    { name: '书籍', icon: '\ue606' },
    { name: '学习', icon: '\ue763' },
    { name: '宠物', icon: '\ue90d' },
    { name: '礼金', icon: '\ue651' },
    { name: '礼物', icon: '\ue600' },
    { name: '办公', icon: '\ue624' },
    { name: '维修', icon: '\ue633' },
    { name: '捐赠', icon: '\ue634' },
    { name: '彩票', icon: '\ue613' },
    { name: '亲友', icon: '\ue61d' },
    { name: '快递', icon: '\ue696' },
    { name: '设置', icon: '\ue605' }
  ]
  // 收入的分类数据
  @State incomeCategories: Category[] = [
    { name: '工资', icon: '\ue764' },
    { name: '兼职', icon: '\ue61f' },
    { name: '理财', icon: '\ue623' },
    { name: '礼金', icon: '\ue792' },
    { name: '其它', icon: '\ue65a' },
    { name: '设置', icon: '\ue605' }
  ]

  onPageShow(): void {
    // 注册字体
    font.registerFont({
      familyName: 'myFont',
      familySrc: '/fonts/iconfont.ttf'
    })
    const cached = MemoryCache.get('cache_route');
    console.log('--cached--', JSON.stringify(cached))
  }

  onPageHide(): void {
    MemoryCache.delete('cache_route');
  }

  private closePage() {
    if (this.animating) {
      return;
    }
    this.animating = true;

    // 下滑动画
    animateTo({
      duration: 280,
      curve: Curve.EaseIn,
      onFinish: () => {
        router.replaceUrl({ url: MemoryCache.get('cache_route')?.value.currentRoutePath || 'pages/detail' });
        this.animating = false;
      }
    }, () => {
      this.translateY = 1000;
    });
  }

  private switchTab(tab: string) {
    if (tab === this.selectedTab) {
      return;
    }
    const newDirection = tab === '支出' ? 'right' : 'left';

    // 第一步：当前列表淡出
    animateTo({
      duration: 0,
      curve: Curve.EaseIn,
      onFinish: () => {
        // 第二步：切换数据后新列表进入
        this.selectedTab = tab;
        this.selectedCategory = '';
        this.listAnimation = {
          translateX: newDirection === 'left' ? 300 : -300,
          // opacity: 0,
          direction: newDirection
        };

        animateTo({
          duration: 250,
          curve: Curve.EaseOut
        }, () => {
          this.listAnimation = {
            translateX: 0,
            // opacity: 1,
            direction: newDirection
          };
        });
      }
    }, () => {
      this.listAnimation = {
        translateX: newDirection === 'left' ? -100 : 100,
        // opacity: 0.5,
        direction: newDirection
      };
    });
  }

  private selectCategory(name: string) {
    animateTo({
      duration: 150,
      curve: Curve.EaseInOut
    }, () => {
      this.selectedCategory = name
    })
  }

  // 新增Tab构建方法
  @Builder
  buildTabItem(tabName: string) {
    Column() {
      Text(tabName)
        .fontSize(18)
        .fontColor('#333333')
        .fontWeight(500)
        .onClick(() => this.switchTab(tabName))

      // 下滑线指示器
      if (this.selectedTab === tabName) {
        Divider()
          .color('#333333')
          .strokeWidth(2)
          .width(36)
          .position({ y: 26 })
      }
    }
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Stack() {
      // 主内容区（带动画）
      Column() {
        // 顶部操作栏（黄色背景）
        Column() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            // Tab切换区域
            Row({ space: 32 }) {
              this.buildTabItem('支出')
              this.buildTabItem('收入')
            }
            .width('65%')
            .justifyContent(FlexAlign.End)

            // 取消按钮
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
          ForEach(this.selectedTab === '支出' ? this.expensesCategories : this.incomeCategories, (item: Category) => {
            GridItem() {
              Column({ space: 8 }) {
                Row() {
                  Text(item.icon)//引号里的'\u'+编号为官网图片的后四位
                    .fontFamily('myFont')//这句话必须加上，不然不显示
                    .fontSize(20)
                    .fontColor('#333333')
                }
                .width(50)
                .height(50)
                .justifyContent(FlexAlign.Center)
                .backgroundColor(this.selectedCategory === item.name ? '#FFD700' : '#F5F5F5')
                .borderRadius('50%')

                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontColor('#333333')
                }
              }
              .onClick(() => this.selectCategory(item.name))
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr') // 4列
        .columnsGap(12)
        .rowsGap(12)
        .padding(16)
        .layoutWeight(1)
        .shadow({
          color: '#F5F5F5',
          radius: 8,
          offsetX: this.listAnimation.translateX / 10
        })
        .translate({
          x: this.listAnimation.translateX
        })

        // .opacity(this.listAnimation.opacity)

        if (this.translateY === 1000) {
          // 底部TabBar
          TabBar({ currentIndex: $currentIndex })
        }
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
}
