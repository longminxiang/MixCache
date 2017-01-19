//
//  MixFileCache.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/19.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public class MixFileCache: NSObject, MixCacheProtocol {

    private var internalCache: NSCache<NSString, MixCacheItem> = NSCache()
    private var queue: DispatchQueue
    private var directory: URL
    
    /// Default cache instance. using "MixCache" for the name
    public static let `default`: MixFileCache = {
        let cache = MixFileCache("MixCache")
        return cache!
    }()
    
    /// Init method.
    ///
    /// - parameter name: a name of the cache file directory
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
  
    /// set method
    public func _set(_ obj: NSCoding, key: String, expires: Date?=nil) {
        let item = MixCacheItem(obj, expires)
        self.internalCache.setObject(item, forKey: key as NSString)
        self.queue.async {
            if let path = self.getURL(key: key)?.path {
                NSKeyedArchiver.archiveRootObject(item, toFile: path)
            }
        }
    }
    
    /// get method
    public func _get<T>(_ key: String) -> T? {
        var item = self.internalCache.object(forKey: key as NSString)
        
        if item == nil {
            self.queue.sync {
                if let path = self.getURL(key: key)?.path {
                    item = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? MixCacheItem
                }
            }
        }
        
        if let item = item {
            if item.didExpire()  {
                self.remove(objectForKey: key)
            }
            else {
                self.internalCache.setObject(item, forKey: key as NSString)
            }
        }
        return item?.obj as? T
    }
    
    /// Check the cached object is exists
    ///
    /// - parameter key:        The key
    ///
    /// - returns: True if the object is exists
    public func exists(key: String) -> Bool {
        var item: MixCacheItem? = self.internalCache.object(forKey: key as NSString)
        if item == nil {
            self.queue.sync {
                 if let path = self.getURL(key: key)?.path {
                    item = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? MixCacheItem
                }
            }
        }
        if let item = item {
            return !item.didExpire()
        }
        return false
    }
    
    /// Remove the cached object
    ///
    /// - parameter key:        The key
    public func remove(objectForKey key: String) {
        self.internalCache.removeObject(forKey: key as NSString)
        self.queue.async {
            if let url = self.getURL(key: key) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
    
    /// Remove all the cached object
    public func removeAllObjects() {
        self.internalCache.removeAllObjects()
        self.queue.async {
            try? FileManager.default.removeItem(at: self.directory)
            try? FileManager.default.createDirectory(at: self.directory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// Clean the internal cached objects
    public func clearInternalCache() {
        self.internalCache.removeAllObjects()
    }
    
    // MARK: Private
    
    private func getURL(key: String) -> URL? {
        if key == "" { return nil }
        return self.directory.appendingPathComponent(key)
    }
}
