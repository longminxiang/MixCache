//
//  MixCacheItem.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public class MixKeydArchiver {
    public static var extraUnarchivedClasses: [AnyClass]? = [
        NSDate.self, NSUUID.self, NSURL.self, NSArray.self, NSDictionary.self, NSNumber.self, NSString.self];
}

extension NSKeyedUnarchiver {
    
    public static func mixcache_unarchive<T>(_ data: Data) throws -> T? where T : NSCoding {
        var item: T?
        if #available(iOS 11.0, *) {
            var classes: [AnyClass] = []
            if let x = MixKeydArchiver.extraUnarchivedClasses {
                classes += x
            }
            classes.append(T.self)
            item = try self.unarchivedObject(ofClasses: classes, from: data) as? T
        }
        else {
            item = self.unarchiveObject(with: data) as? T
        }
        return item
    }
    
    public static func mixcache_unarchive<T>(path: String) throws -> T? where T : NSCoding {
        guard let data = try? NSData(contentsOfFile: path) as Data else {
            return nil
        }
        let item: T? = try self.mixcache_unarchive(data)
        return item
    }
}

extension NSKeyedArchiver {
    public  static func mixcache_archive(_ obj: Any, secure: Bool? = true, toFile path: String? = nil) -> Data? {
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
