import { DateUtil } from "../../../utils/DateUtil";
import { dateTimeItem } from "../viewModel/commonFunction";

@Entry
@Component
export default struct DatePickerDialog {
  dateCallBack: (params: dateTimeItem) => void = () => {
  };
  selectedDate: Date = new Date(this.getCurrentDate());

  // 当前 年/月/日
  private getCurrentDate(): string {
    const now = new Date()
    return `${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`
  }

  // 当前月份
  private getCurrentMonth(): string {
    const now = new Date()
    return `${now.getMonth() + 1}`
  }

  build() {
    Column() {
      Row() {
        Text(this.getCurrentMonth())
          .fontSize(24)
          .fontColor('#333333')
        Row() {
          Text('月')
            .fontSize(12)
            .fontColor('#333333')
          Image($r('app.media.detail_below'))
            .width(16)
            .height(16)
            .padding({ left: 4 })
        }
        .padding({ top: 6 })
      }
      .width('22%')
      .border({
        width: {
          right: 1
        },
        color: '#cccccc'
      })
      .onClick(() => {
        this.getUIContext().showDatePickerDialog({
          start: new Date("2025-1-1"),
          end: new Date("2100-12-31"),
          selected: this.selectedDate,
          showTime: true,
          useMilitaryTime: false,
          dateTimeOptions: { hour: "numeric", minute: "2-digit" },
          onDateAccept: (value: Date) => {
            // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
            this.selectedDate = value;
            this.dateCallBack({
              startTime: DateUtil.formatCST(value.toISOString())
            })
            console.log('按下确定按钮后的value', JSON.stringify(value.toISOString()))
            // console.info("DatePickerDialog:onDateAccept()" + value.toString());
          },
          onCancel: () => {
            this.dateCallBack({
              startTime: ''
            })
            // console.info("DatePickerDialog:onCancel()");
          },
          onDateChange: (value: Date) => {
            // console.info("DatePickerDialog:onDateChange()" + value.toString());
          },
          onDidAppear: () => {
            // console.info("DatePickerDialog:onDidAppear()");
          },
          onDidDisappear: () => {
            // console.info("DatePickerDialog:onDidDisappear()");
          },
          onWillAppear: () => {
            // console.info("DatePickerDialog:onWillAppear()");
          },
          onWillDisappear: () => {
            // console.info("DatePickerDialog:onWillDisappear()");
          }
        })
      })
    }
  }
}