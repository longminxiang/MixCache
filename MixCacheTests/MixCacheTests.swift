//
//  MixCacheTests.swift
//  MixCacheTests
//
//  Created by Eric Lung on 2017/1/17.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import XCTest
@testable import MixCache

class MixCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MixFileCache.shared.debug = true
        MixFileCache.shared.isSync = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var cache: MixFileCache? = MixFileCache.shared
        XCTAssertNotNil(cache, "init with default failed");
        
        cache = MixFileCache("TestCache")
        XCTAssertNotNil(cache, "init with name failed");
    }
    
    func testArchiver() {
        let data = NSKeyedArchiver.mixcache_archive("333", secure: true, toFile: nil)
        XCTAssertNotNil(data);
        if let data = data {
            let item: NSString? = try? NSKeyedUnarchiver.mixcache_unarchive(data)
            XCTAssertNotNil(item);
        }
    }
    
    func testCacheable() {
        let x = "ccccc".codedObject
        XCTAssertNotNil(x);
        let y = 123.codedObject
        print(y.intValue)
        XCTAssertNotNil(y);
        let z = 1234.234.codedObject
        print(z.floatValue)
        XCTAssertNotNil(z);
        let a = Date().codedObject
        XCTAssertNotNil(a);
        print(a)
        let b = Data().codedObject
        XCTAssertNotNil(b);
        print(b)
    }
    
    func testCacheItem() {
        print("-----archive------")
        let item = MixCacheItem("1234dsddsddsdsd56" as NSString, Date())
        XCTAssertNotNil(item, "init item failed");
        print(item)
        let data = NSKeyedArchiver.mixcache_archive(item, secure: true, toFile: nil)
        XCTAssertNotNil(data, "archive item failed");
        print("-----unarchive------")
        let newItem: MixCacheItem<NSString>? = try? NSKeyedUnarchiver.mixcache_unarchive(data!)
        XCTAssertNotNil(newItem, "unarchive item failed");
        print(newItem ?? "")
    }
    
    func testString() {
        let obj = "xxxxxx"
        let key = "testStringKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: String? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }

    func testDate() {
        let obj = Date()
        let key = "testDateKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: Date? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }

    func testData() {
        let obj = "123dddddd".data(using: .utf8)!
        let key = "testDataKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: Data? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testInt() {
        let obj = 500
        let key = "testIntKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: Int? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testArray() {
        let key = "testArrayKey"
        MixFileCache.shared.set([1, 2 , 3], key: key)
        let obj1: [Int]? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testNSArray() {
        let key = "testNSArrayKey"
        let obj = NSMutableArray()
        obj.add(1)
        obj.add("ddd")
        obj.add(Date())
        MixFileCache.shared.set(obj, key: key)
        let obj1: NSMutableArray? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testDictionary() {
        let key = "testDictionaryKey"
        let obj: [String: Any] = ["dd": "y", "z": 22, "ccc": "ddd".data(using: .utf8)!]
        MixFileCache.shared.set(obj, key: key)
        let obj1: [String: Any]? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testNSDictionary() {
        let key = "testNSDictionaryKey"
        let obj = NSMutableDictionary()
        obj.setObject("yyy", forKey: "a" as NSString)
        obj.setObject(Date(), forKey: "cc" as NSString)
        MixFileCache.shared.set(obj, key: key)
        let obj1: NSMutableDictionary? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }


    func testMixReturn() {
        let obj = 500
        let key = "testMixKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: Float? = MixFileCache.shared.get(key)
        XCTAssertNotNil(obj1)
    }
    
    func testWrongReturn() {
        let obj = 500
        let key = "testWrongKey"
        MixFileCache.shared.set(obj, key: key)
        let obj1: String? = MixFileCache.shared.get(key)
        XCTAssertNil(obj1)
    }

    func testRemoveObject() {
        let key = "testRemoveKey"
        MixFileCache.shared.set("dddd", key: key)
        MixFileCache.shared.remove(key)
        let key1 = "testRemoveKey1"
        MixFileCache.shared.remove(key1)
        let key2 = ""
        MixFileCache.shared.remove(key2)
    }
    
}
