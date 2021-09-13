//
//  MixFileCache.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/19.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public class MixFileCache: NSObject, MixCacheProtocol {

    private var internalCache: NSCache<NSString, AnyObject> = NSCache()
    private var queue: DispatchQueue
    private var directory: URL
    
    public static let shared: MixFileCache = {
        let cache = MixFileCache("MixCache")
        return cache!
    }()
    
    public init?(_ name: String) {
        
        guard let cacheDic = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last else {
            return nil
        }
        self.directory = URL(fileURLWithPath: cacheDic + "/" + name)
        do {
            try FileManager.default.createDirectory(at: self.directory, withIntermediateDirectories: true, attributes: nil)
            print("create MixCache in \(self.directory.path)")
        } catch {
            return nil
        }
        self.queue = DispatchQueue(label: name)
        self.internalCache.name = name
    }
    
    public func set<T: MixCacheable>(_ obj: T, key: String, expires: Date?=nil) {
        self.set(obj, key: key, expires: expires, sync: false)
    }
  
    public func set<T: MixCacheable>(_ obj: T, key: String, expires: Date?=nil, sync: Bool?=nil) {
        let item = MixCacheItem(obj.codedObject, expires)
        let path = self.getURL(key: key).path
        let isSync = sync ?? false
        if (isSync) {
            self.queue.sync {
                _ = NSKeyedArchiver.mix_archive(item, secure: true, toFile: path)
            }
        }
        else {
            self.internalCache.setObject(item, forKey: key as NSString)
            self.queue.async {
                _ = NSKeyedArchiver.mix_archive(item, secure: true, toFile: path)
            }
        }
    }
    
    public func get<T: MixCacheable>(_ key: String) -> T? {
        if let item = self.internalCache.object(forKey: key as NSString) as? MixCacheItem<T.RefType> {
            if (item.didExpire) {
                self.remove(key)
            }
            return item.didExpire ? nil : item.item as? T
        }

        var item: MixCacheItem<T.RefType>?
        let path = self.getURL(key: key).path
        self.queue.sync {
            item = NSKeyedUnarchiver.mix_unarchive(path: path, cls: MixCacheItem<T.RefType>.self)
        }

        if let item = item {
            if item.didExpire  {
                self.remove(key)
            }
            else {
                self.internalCache.setObject(item, forKey: key as NSString)
            }
        }
        return item?.item as? T
    }
    
    public func remove(_ key: String) {
        guard !key.isEmpty else {
            return
        }
        self.internalCache.removeObject(forKey: key as NSString)
        self.queue.async {
            let url = self.getURL(key: key)
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    public func removeAll() {
        self.internalCache.removeAllObjects()
        self.queue.async {
            try? FileManager.default.removeItem(at: self.directory)
            try? FileManager.default.createDirectory(at: self.directory, withIntermediateDirectories: true, attributes: nil)
        }
    }

    // MARK: Private
    
    private func getURL(key: String) -> URL {
        return self.directory.appendingPathComponent(key)
    }
}
