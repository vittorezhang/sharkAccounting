export class Base64Util {
  private static keyStr: string =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

  static encode(input: string): string {
    let output: string = "";
    let i: number = 0;
    const keyStr = Base64Util.keyStr; // 避免使用this

    while (i < input.length) {
      const chr1: number = Base64Util.getCharCode(input, i++);
      const chr2: number = Base64Util.getCharCode(input, i++);
      const chr3: number = Base64Util.getCharCode(input, i++);

      const enc1: number = chr1 >> 2;
      const enc2: number = ((chr1 & 3) << 4) | (chr2 >> 4);
      let enc3: number = ((chr2 & 15) << 2) | (chr3 >> 6);
      let enc4: number = chr3 & 63;

      if (isNaN(chr2)) {
        enc3 = enc4 = 64;
      } else if (isNaN(chr3)) {
        enc4 = 64;
      }

      output += keyStr.charAt(enc1) + keyStr.charAt(enc2) +
      keyStr.charAt(enc3) + keyStr.charAt(enc4);
    }

    return output;
  }

  static decode(input: string): string {
    let output: string = "";
    let i: number = 0;
    const keyStr = Base64Util.keyStr; // 避免使用this

    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

    while (i < input.length) {
      const enc1: number = keyStr.indexOf(input.charAt(i++));
      const enc2: number = keyStr.indexOf(input.charAt(i++));
      const enc3: number = keyStr.indexOf(input.charAt(i++));
      const enc4: number = keyStr.indexOf(input.charAt(i++));

      const chr1: number = (enc1 << 2) | (enc2 >> 4);
      const chr2: number = ((enc2 & 15) << 4) | (enc3 >> 2);
      const chr3: number = ((enc3 & 3) << 6) | enc4;

      output += Base64Util.fromCharCode(chr1);

      if (enc3 != 64) {
        output += Base64Util.fromCharCode(chr2);
      }
      if (enc4 != 64) {
        output += Base64Util.fromCharCode(chr3);
      }
    }

    return output;
  }

  private static getCharCode(str: string, index: number): number {
    return index < str.length ? str.charCodeAt(index) : NaN;
  }

  private static fromCharCode(...codes: number[]): string {
    return String.fromCharCode(...codes);
  }
}