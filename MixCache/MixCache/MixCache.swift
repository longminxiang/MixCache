//
//  MixCache.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/17.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public class MixCache: NSObject {

    private var internalCache: NSCache<NSString, MixCacheItem> = NSCache()
    private var queue: DispatchQueue
    private var directory: URL
    
    /// Default cache instance. using "MixCache" for the name
    public static let `default`: MixCache = {
        let cache = MixCache("MixCache")
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
    
    // MARK: Set Method
    
    /// Cache the NSCoding object
    ///
    /// - parameter obj:        An object that should be cached
    /// - parameter key:        The object key
    /// - parameter expires:    The expiry date of the given value
    public func set(_ obj: NSCoding, key: String, expires: Date?=nil) {
        self._set(obj, key: key, expires: expires)
    }
    
    /// Cache the NSCoding objects
    ///
    /// - parameter objs:       NSCoding objects array
    /// - parameter key:        The object key
    /// - parameter expires:    The expiry date of the given value
    public func set<T: NSCoding>(_ objs: [T], key: String, expires: Date?=nil) {
        self._set(objs as NSArray, key: key, expires: expires)
    }
    
    /// Cache the MixCacheableProtocol object
    ///
    /// - parameter obj:        An object that should be cached
    /// - parameter key:        The object key
    /// - parameter expires:    The expiry date of the given value
    public func set(_ obj: MixCacheableProtocol, key: String, expires: Date?=nil) {
        self._set(obj.codedObject, key: key, expires: expires)
    }
    
    /// Cache the MixCacheableProtocol objects
    ///
    /// - parameter objs:       MixCacheableProtocol objects array
    /// - parameter key:        The object key
    /// - parameter expires:    The expiry date of the given value
    public func set<T: MixCacheableProtocol>(_ obj: [T], key: String, expires: Date?=nil) {
        let array = obj.map({ return $0.codedObject }) as NSArray
        self._set(array, key: key, expires: expires)
    }
    
    // MARK: Set Method
    
    /// Get NSCoding protocal object
    ///
    /// - parameter key:        The key
    ///
    /// - returns: NSCoding object
    public func get<T: NSCoding>(_ key: String) -> T? {
        return self._get(key)
    }
    
    /// Get NSCoding protocal objects
    ///
    /// - parameter key:        The key
    ///
    /// - returns: NSCoding objects
    public func get<T: NSCoding>(_ key: String) -> [T]? {
        return self._get(key)
    }
    
    /// Get MixCacheableProtocol object
    ///
    /// - parameter key:        The key
    ///
    /// - returns: MixCacheableProtocol object
    public func get<T: MixCacheableProtocol>(_ key: String) -> T? {
        return self._get(key)
    }
    
    /// Get MixCacheableProtocol objects
    ///
    /// - parameter key:        The key
    ///
    /// - returns: MixCacheableProtocol objects
    public func get<T: MixCacheableProtocol>(_ key: String) -> [T]? {
        return self._get(key)
    }
    
    /// Check the cached object is exists
    ///
    /// - parameter key:        The key
    ///
    /// - returns: True if the object is exists
    public func exists(key: String) -> Bool {
        if let item = self.internalCache.object(forKey: key as NSString) {
            if let expires = item.expires {
                return expires.timeIntervalSinceNow >= 0
            }
            return true
        }
        return false
    }
    
    /// Remove the cached object
    ///
    /// - parameter key:        The key
    public func remove(objectForKey key: String) {
        self.internalCache.removeObject(forKey: key as NSString)
        self.queue.async {
            try? FileManager.default.removeItem(at: self.getURL(key: key))
        }
    }
    
    /// Remove all the cached objects
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
    
    private func getURL(key: String) -> URL {
        return self.directory.appendingPathComponent(key)
    }
    
    private func _set(_ obj: NSCoding, key: String, expires: Date?=nil) {
        let item = MixCacheItem(obj, expires)
        self.internalCache.setObject(item, forKey: key as NSString)
        print(self.internalCache)
        self.queue.async {
            NSKeyedArchiver.archiveRootObject(item, toFile: self.getURL(key: key).path)
        }
    }
    
    private func _get<T>(_ key: String) -> T? {
        var item = self.internalCache.object(forKey: key as NSString)
        
        if item == nil {
            self.queue.sync {
                item = NSKeyedUnarchiver.unarchiveObject(withFile: self.getURL(key: key).path) as? MixCacheItem
            }
        }
        
        if let item = item {
            if let expires = item.expires, expires.timeIntervalSinceNow < 0  {
                self.remove(objectForKey: key)
            }
            else {
                self.internalCache.setObject(item, forKey: key as NSString)
            }
        }
        return item?.obj as? T
    }
}
