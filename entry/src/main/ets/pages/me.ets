import TabBar from '../components/TabBar'
import { promptAction, router } from '@kit.ArkUI'
import { StorageUtil } from '../../../utils/storage'

@Entry
@Component
struct MePage {
  @State private currentIndex: number = 4
  private handleLogOut = async () => {
    StorageUtil.clearAuthToken()
    const storedToken = await StorageUtil.getAuthToken();
    console.log('storedToken', JSON.stringify(storedToken));
    if (!storedToken) {
      promptAction.showToast({ message: '操作成功' });
      router.pushUrl({
        url: 'pages/Index',
        params: {}
      })
    }
  }

  build() {
    Column() {
      // 1. 顶部黄色标题栏
      Text('我的')
        .width('100%')
        .height(56)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .backgroundColor('#FFD700')

      // 2. 主内容区
      Scroll() {
        Column() {
          Text('页面-我的')
          Button('退出登录', { type: ButtonType.Normal })
            .width('90%')
            .height(48)
            .fontSize(16)
            .backgroundColor('#FFD700')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .borderRadius(8)
            .onClick(() => this.handleLogOut())
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

function clearAuthToken() {
  throw new Error('Function not implemented.')
}
