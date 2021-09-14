//
//  MixCacheItem.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

extension NSKeyedUnarchiver {
    
    static func mixcache_unarchive<T>(_ data: Data) throws -> T? where T : NSObject, T : NSCoding {
        var item: T?
        if #available(iOS 11.0, *) {
            item = try self.unarchivedObject(ofClass: T.self, from: data)
        }
        else {
            item = self.unarchiveObject(with: data) as? T
        }
        return item
    }
    
    static func mixcache_unarchive<T>(path: String) throws -> T? where T : NSObject, T : NSCoding {
        guard let data = try? NSData(contentsOfFile: path) as Data else {
            return nil
        }
        let item: T? = try self.mixcache_unarchive(data)
        return item
    }
}

extension NSKeyedArchiver {
    static func mixcache_archive(_ obj: Any, secure: Bool? = true, toFile path: String? = nil) -> Data? {
        var data: Data?
        if #available(iOS 12.0, *) {
            data = try? self.archivedData(withRootObject: obj, requiringSecureCoding: secure ?? true)
        }
        else {
            data = self.archivedData(withRootObject: obj)
        }
        if let data = data, let path = path {
            try? data.write(to: URL(fileURLWithPath: path))
        }
        return data
    }
}

public class MixCacheItem<T>: NSObject, NSSecureCoding where T: NSObject, T: NSCoding {
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public var item: T
    public var expires: Date?
    
    public var didExpire: Bool {
        let val = self.expires?.timeIntervalSinceNow ?? 0
        return val < 0
    }
    
    public init(_ item: T, _ expires: Date? = nil) {
        self.item = item
        self.expires = expires
    }
    
    required public init?(coder aDecoder: NSCoder) {
        guard let item = aDecoder.decodeObject(of: T.self, forKey: "item") else {
            return nil
        }
        self.item = item
        self.expires = aDecoder.decodeObject(of: NSDate.self, forKey: "expires") as Date?
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.item, forKey: "item")
        if let expires = self.expires {
            aCoder.encode(expires, forKey: "expires")
        }
    }
    
    public override var description: String {
        let expiresStr = self.expires != nil ? "\(self.expires!)" : "nil"
        return "item: \(self.item)\nexpires: \(expiresStr)"
    }
}
