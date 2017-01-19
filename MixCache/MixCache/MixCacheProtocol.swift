//
//  MixCacheProtocol.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/19.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheProtocol {
    
    /// The place where you put the code of the set method
    func _set(_ obj: NSCoding, key: String, expires: Date?)
    
    /// The place where you put the code of the get method
    func _get<T>(_ key: String) -> T?
    
    /// Remove the cached object
    func remove(objectForKey key: String)
    
    /// Remove all the cached object
    /// optional
    func removeAllObjects()
    
    /// Check the cached object is exists
    /// optional
    func exists(key: String) -> Bool
}

extension MixCacheProtocol {
    
    private func exists(key: String) -> Bool { return false }
    
    private func removeAllObjects() {}
    
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
    public func set<T: MixCacheableProtocol>(_ objs: [T], key: String, expires: Date?=nil) {
        let array = objs.map({ return $0.codedObject }) as NSArray
        self._set(array, key: key, expires: expires)
    }
    
    // MARK: Get Method
    
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

}
