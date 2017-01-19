//
//  MixCacheItem.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public class MixCacheItem: NSObject, NSCoding {
    
    public var obj: NSCoding
    public var expires: Date?
    
    public init(_ obj: NSCoding, _ expires: Date?) {
        self.obj = obj;
        self.expires = expires
    }
    
    required public init?(coder aDecoder: NSCoder) {
        guard let obj = aDecoder.decodeObject(forKey: "obj") as? NSCoding else {
            return nil
        }
        self.obj = obj
        self.expires = aDecoder.decodeObject(forKey: "expires") as? Date
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.obj, forKey: "obj")
        if let expires = self.expires {
            aCoder.encode(expires, forKey: "expires")
        }
    }
    
    public func didExpire() -> Bool {
        if let expires = self.expires {
            return expires.timeIntervalSinceNow < 0
        }
        return false
    }
}
