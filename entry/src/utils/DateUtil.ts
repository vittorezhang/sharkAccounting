export class DateUtil {
  static format(isoString: string): string {
    const date = new Date(isoString);
    const pad = (num: number) => num.toString().padStart(2, '0');

    return `${
    date.getFullYear()
    }/${
    pad(date.getMonth() + 1)
    }/${
    pad(date.getDate())
    } ${
    pad(date.getHours())
    }:${
    pad(date.getMinutes())
    }:${
    pad(date.getSeconds())
    }`;
  }

  static formatCST(isoString: string): string {
    const date = new Date(isoString);
    date.setHours(date.getHours());

    return this.format(date.toISOString());
  }
}

export function getDaysSince20250624(): number {
  // 1. 定义目标日期（2025年6月24日）
  const targetDate = new Date(2025, 5, 24); // 月份是0-11，所以6月是5

  // 2. 获取当前日期
  const currentDate = new Date();

  // 3. 计算时间差（毫秒）
  const timeDiff = currentDate.getTime() - targetDate.getTime();

  // 4. 转换为天数
  const daysDiff = Math.floor(timeDiff / (1000 * 60 * 60 * 24));

  // 5. 处理未来日期情况
  return daysDiff >= 0 ? daysDiff : 0;
}