//
//  MixCacheProtocol.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/19.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheProtocol {
    
    func set<T: MixCacheable>(_ obj: T, key: String, expires: Date?)
    
    func get<T: MixCacheable>(_ key: String) -> T?
        
    func remove(_ key: String)
    
    func removeAll()
}
