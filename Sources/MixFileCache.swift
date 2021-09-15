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
    public var isSync: Bool = false
    public var debug: Bool = false
    
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
  
    public func set(_ obj: AnyObject, key: String) {
        let path = self.getURL(key: key).path
        if (self.isSync) {
            self.queue.sync {
                _ = NSKeyedArchiver.mixcache_archive(obj, secure: true, toFile: path)
            }
        }
        else {
            self.internalCache.setObject(obj, forKey: key as NSString)
            self.queue.async {
                _ = NSKeyedArchiver.mixcache_archive(obj, secure: true, toFile: path)
            }
        }
    }
    
    public func get<T: NSCoding>(_ key: String) -> T? {
        var obj = self.internalCache.object(forKey: key as NSString) as? T
        if (obj != nil) {
            return obj
        }

        let path = self.getURL(key: key).path
        self.queue.sync {
            do {
                obj = try NSKeyedUnarchiver.mixcache_unarchive(path: path)
            }
            catch {
                if (self.debug) {
                    print(error)
                }
            }
        }
        return obj
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
