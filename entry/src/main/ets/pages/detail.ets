import TabBar from '../components/TabBar'
import FinanceHeader from '../components/FinanceHeader'
import { MemoryCache } from '../../../utils/MemoryCache';
import { AccountingRecord, AuthToken, RouteData } from '../viewModel/commonFunction';
import { StorageUtil } from '../../../utils/Storage';
import font from '@ohos.font';
import { promptAction, router } from '@kit.ArkUI';
import BadgeDialog from '../components/BadgeDialog';
import { DateUtil } from '../../../utils/DateUtil';

interface editPositionItem {
  x: number;
  y: number;
}

interface RouteParams {
  categoryType?: string;
}

@Entry
@Component
struct DetailPage {
  @State private currentIndex: number = 0
  @State currentAccount: AuthToken | null = null;
  @State income: number = 0;
  @State expenses: number = 0;
  @State transactions: AccountingRecord[] = [];
  // 徽章 弹窗状态
  @State budgeVisible: boolean = false;
  // 状态管理【长按】
  @State isEditing: boolean = false;
  @State editPosition: editPositionItem = { x: 0, y: 0 };
  @State currentEditCategory: string = '';
  @State currentEditRemark: string = '';
  @State currentEditCategoryId: string = '';
  @State currentEditCreateTime: string = '';

  // 获取记账数据
  private async getCategory(accountId: string) {
    // 查账户下所有记账数据
    if (!accountId) {
      return
    }
    const result = await StorageUtil.getCurrentAccountingRecord(accountId);
    console.log('这是所有的记账数据', JSON.stringify(result));
    if (!result) {
      return;
    }
    const currentAccountData = result
    ?.filter(a => a.currentAccountId === accountId)
      ?? [];
    console.log('这是当前登录账户的记账数据', JSON.stringify(currentAccountData));
    this.transactions = currentAccountData;
    // 筛选收入累计、支出累计
    this.transactions?.forEach((mItem: AccountingRecord) => {
      if (mItem.type === 'income') {
        this.income += mItem?.amount || 0;
      } else {
        this.expenses += mItem?.amount || 0;
      }
    });
  };

  // 修改记账数据
  private saveCategory(item: AccountingRecord) {
    if (!this.currentAccount?.id) {
      return;
    }
    //初始化清空【 收入、支出】
    this.income = 0
    this.expenses = 0
    // 1. 获取当前数据
    const selectedCategory = this.currentEditCategory || item.category || '其他';
    const selectedRemark = this.currentEditRemark || item.remark || undefined;
    // 2. 创建新记录
    const newRecord: AccountingRecord = {
      currentAccountId: this.currentAccount.id,
      id: item.id,
      accountId: this.currentAccount.id,
      type: item.type,
      selectedIcon: item.selectedIcon,
      category: selectedCategory,
      amount: item.amount,
      remark: selectedRemark,
      createTime: (item.id === this.currentEditCategoryId && item.createTime === this.currentEditCreateTime) ?
      item.createTime : new Date().toISOString()
    };
    // 保存记账数据
    StorageUtil.saveAccountingRecord(newRecord);
    promptAction.showToast({ message: `保存成功` })
    setTimeout(() => {
      if (!this.currentAccount?.id) {
        return;
      }
      // 刷新记账列表
      this.getCategory(this.currentAccount?.id);
    }, 1000)
  }

  // 长按手势处理
  private handleLongPress(event: GestureEvent, item: AccountingRecord) {
    this.isEditing = true;
    this.currentEditCategoryId = item.id;
    this.currentEditCreateTime = item.createTime;
    this.currentEditCategory = item.category;
    if (item?.remark) {
      this.currentEditRemark = item.remark;
    }
    // 获取点击位置（适配不同设备）
    this.editPosition = {
      x: event.offsetX + 32,
      y: event.offsetY - 2
    };
  }

  // 编辑框组件
  @Builder
  editCategoryInput(item: AccountingRecord) {
    if (this.isEditing) {
      Column() {
        TextInput({ text: this.currentEditRemark || this.currentEditCategory })
          .width('70%')
          .height(34)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#FFD700' })
          .onChange((value) => {
            this.currentEditCategory = value;
            this.currentEditRemark = value;
          })
          .onBlur(() => {
            this.saveCategory(item);
          })
      }
      .position({ x: this.editPosition.x, y: this.editPosition.y })
      .zIndex(10)
    }
  }

  async onPageShow() {
    //初始化清空【 收入、支出】
    this.income = 0
    this.expenses = 0
    // 注册字体
    font.registerFont({
      familyName: 'myFont',
      familySrc: '/fonts/iconfont.ttf'
    })
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
    // 查当前账户信息
    StorageUtil.getCurrentAccount().then(account => {
      this.currentAccount = account;
      if (!account?.id) {
        return;
      }
      // 获取记账数据
      this.getCategory(account?.id);
      // 徽章弹窗判断
      const params = router.getParams() as RouteParams;
      if (params?.categoryType == '工资') {
        this.budgeVisible = true;
      }
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

      // 财务管理应用顶部模块
      FinanceHeader({
        userName: this.currentAccount?.username,
        income: this.income,
        expenses: this.expenses
      })
        .zIndex(99)

      // 2. 主内容区
      Scroll() {
        Column() {
          ForEach(this.transactions, (item: AccountingRecord) => {
            Column({ space: 8 }) {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(DateUtil.formatCST(item.createTime))
                    .fontSize(16)
                    .fontColor('#999999')
                    .fontWeight(500)
                }

                Row() {
                  Text(`${item.type === 'expense' ? '支出' : '收入'}:${item.amount}`)
                    .fontSize(14)
                    .fontColor('#999999')
                }
              }
              .height(24)

              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Row() {
                  Text(item.selectedIcon)
                    .fontFamily('myFont')
                    .fontSize(20)
                    .fontColor('#333333')
                }
                .width(32)
                .height(32)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#FFD700')
                .borderRadius('50%')
                .onClick(() => {
                  // 跳转记账页面
                  router.replaceUrl({
                    url: 'pages/account',
                    params: {
                      currentCategoryId: item.id,
                      currentCategory: item.category,
                      currentIcon: item.selectedIcon,
                    }
                  });
                })

                Row() {
                  Text(item.remark || item.category)
                    .fontSize(16)
                }
                .width('70%')
                .gesture(
                  LongPressGesture({ repeat: false })
                    .onAction((event: GestureEvent) => {
                      this.handleLongPress(event, item);
                    })
                )

                if (this.currentEditCategoryId === item.id && this.currentEditCreateTime === item.createTime) {
                  // 编辑框（放在Stack最上层）
                  this.editCategoryInput(item)
                }


                Row() {
                  Text(`${item.type === 'expense' ? '-' : '+'}${item.amount}`)
                    .fontSize(16)
                    .fontColor('#333333')
                }
              }
              .height(32)
              .margin({ top: 4, bottom: 4 })
            }
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 8
            }) // 调整内边距
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 1 }) // 添加底部边距
            .borderRadius(8) // 添加圆角
          })
        }
        .width('100%')
        .margin({ top: 64, bottom: 56 })
      }
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .layoutWeight(1)
      .align(Alignment.Top)


      // 3. 底部TabBar
      TabBar({ currentIndex: $currentIndex })

      // 4 徽章弹窗 【工资进账了】
      if (this.budgeVisible) {
        BadgeDialog({
          onClose: (bool: boolean) => {
            this.budgeVisible = bool;
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .onClick(() => {
      if (this.isEditing) {
        this.isEditing = false; // 点击其他区域关闭编辑
      }
    })
  }
}