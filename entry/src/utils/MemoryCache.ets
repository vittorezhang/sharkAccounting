import { CacheItem } from "../main/ets/viewModel/commonFunction";

export class MemoryCache {
  private static cache = new Map<string, CacheItem>();

  static set(key: string, value: CacheItem, ttl?: number) {
    MemoryCache.cache.set(key, value);
    if (ttl) {
      setTimeout((): void => MemoryCache.delete(key), ttl);
    }
  }

  static get(key: string) {
    return MemoryCache.cache.get(key);
  }

  static delete(key: string) {
    MemoryCache.cache.delete(key);
  }
}