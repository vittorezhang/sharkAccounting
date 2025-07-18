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