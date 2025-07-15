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

  // 带时区版本（东八区）
  static formatCST(isoString: string): string {
    const date = new Date(isoString);
    date.setHours(date.getHours() + 8);

    return this.format(date.toISOString());
  }
}