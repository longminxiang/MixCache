//
//  MixKeychainCache.swift
//  MixCache
//
//  Created by Eric Long on 2021/9/15.
//  Copyright © 2021 Eric Lung. All rights reserved.
//

import Foundation

public class MixKeychainCache: NSObject, MixCacheProtocol {

    private var archiverQueue: DispatchQueue
    private var service: String
    public var debug: Bool = false
    
    public static let shared: MixKeychainCache = {
        let bundleID = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String)
        let cache = MixKeychainCache(service: bundleID as! String)
        return cache
    }()
    
    public init(service: String) {
        self.service = service
        self.archiverQueue = DispatchQueue(label: "mix_keychain_cache")
        super.init()
    }
  
    public func set(_ obj: AnyObject, key: String) {
        var data: Data?
        self.archiverQueue.sync {
            data = NSKeyedArchiver.mixcache_archive(obj, secure: true)
        }
        guard let data = data else {
            return
        }
        
        let update: [CFString : Any] = [
            kSecAttrAccessible: kSecAttrAccessibleAlways,
            kSecValueData: data as NSData
        ]
        
        var status: OSStatus;
        if (self.getData(key) != nil) {
            let query = self.query(key)
            status = SecItemUpdate(query, update as CFDictionary)
        }
        else {
            let query = self.query(key, merge: update)
            status = SecItemAdd(query, nil)
        }
        if (status != errSecSuccess && self.debug) {
            print("failed to store data for key \(key), error: \(status)")
        }
    }
    
    private func getData(_ key: String) -> CFTypeRef? {
        let query = self.query(key, merge: [kSecMatchLimit: kSecMatchLimitOne, kSecReturnData: kCFBooleanTrue as Any])
        var data: CFTypeRef?
        let status = SecItemCopyMatching(query, &data)
        if (status != errSecSuccess && status != errSecItemNotFound && self.debug) {
            print("failed to get data for key \(key), error: \(status)")
        }
        return data
    }
    
    public func get<T: NSCoding>(_ key: String) -> T? {
        guard let data = self.getData(key) as? Data else {
            return nil
        }
        
        var obj: T?
        self.archiverQueue.sync {
            do {
                obj = try NSKeyedUnarchiver.mixcache_unarchive(data)
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
        let query = self.query(key)
        let status = SecItemDelete(query)
        if (status != errSecSuccess) {
            print("failed to delete data for key \(key), error: \(status)")
        }
    }
    
    public func removeAll() {}
    
    private func query(_ key: String, merge: [CFString: Any]?=nil) -> CFDictionary {
        var query: [CFString : Any] = [
            kSecAttrService: self.service,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
        ]
        if let merge = merge {
            query.merge(merge, uniquingKeysWith: { v1, _ in return v1 })
        }
        return query as CFDictionary
    }
}
