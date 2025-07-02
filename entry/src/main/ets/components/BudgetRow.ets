import { budgetRowItem } from "../viewModel/commonFunction"


@Component
export default struct BudgetRow {
  @Prop budgetRowList: budgetRowItem[]

  build() {
    Column({ space: 12 }) {
      ForEach(this.budgetRowList, (item: budgetRowItem, index) => {
        Row() {
          Text(item.label)
            .fontSize(index === 0 ? 16 : 14)
            .fontColor(index === 0 ? 'black' : '#999999')
            .textAlign(TextAlign.Start)
            .layoutWeight(1)

          Text(item.value)
            .fontSize(index === 0 ? 16 : 14)
            .fontColor('#333333')
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .border(index === 0 ? {
          width: {
            bottom: 1
          },
          color: '#F5F5F5'
        } : null)
        .padding(index === 0 ? {
          bottom: 8
        } : null)
      })
    }
  }
}