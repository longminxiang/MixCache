//
//  MixCacheProtocol.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/19.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheProtocol {
    
    func set<T>(_ obj: T, key: String, expires: Date?) where T: NSObject, T: NSCoding
    
    func get<T>(_ key: String) -> T? where T: NSObject, T: NSCoding
        
    func remove(_ key: String)
    
    func removeAll()
}

extension MixCacheProtocol {

    public func set<T: MixCacheable>(_ obj: T, key: String, expires: Date?=nil) {
        self.set(obj.codedObject, key: key, expires: expires)
    }
    
    func get<T: MixCacheable>(_ key: String) -> T? {
        let item: T.RefType? = self.get(key)
        return item as? T
    }
}
