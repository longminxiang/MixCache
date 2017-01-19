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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var cache: MixFileCache? = MixFileCache.default
        XCTAssertNotNil(cache, "init with default failed");
        
        cache = MixFileCache("TestCache")
        XCTAssertNotNil(cache, "init with name failed");
        
    }
    
    func testSetString() {
        let obj = "xxxxxx"
        let key = "testStringKey"
        MixFileCache.default.set(obj, key: key)
        
        if let obj1:String = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetObjects() {
        let obj = ["xxxxxx", "dddd", "e3333"]
        let key = "testObjectsKey"
        MixFileCache.default.set(obj, key: key)
        
        if let obj1:[String] = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetDate() {
        let obj = Date()
        let key = "testDateKey"
        MixFileCache.default.set(obj, key: key)
        
        if let obj1:Date = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetData() {
        if let obj = "123".data(using: .utf8) {
            let key = "testDataKey"
            MixFileCache.default.set(obj, key: key)
            MixFileCache.default.clearInternalCache()
            
            if let obj1:Data = MixFileCache.default.get(key) {
                XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
            }
            else {
                XCTFail("key \(key) 应该有值")
            }
        }
    }
    
    func testSetNSCoding() {
        let obj = NSUUID()
        let key = "testNSCodingKey"
        MixFileCache.default.set(obj, key: key)
        MixFileCache.default.clearInternalCache()
        
        if let obj1:NSUUID = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetNSCodingObjects() {
        let obj = [NSUUID(), NSUUID(), NSUUID(), NSUUID()]
        let key = "testNSCodingObjectsKey"
        MixFileCache.default.set(obj, key: key)
        MixFileCache.default.clearInternalCache()
        
        if let obj1:[NSUUID] = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testInt() {
        let obj = 500
        let key = "testIntKey"
        MixFileCache.default.set(obj, key: key)
        MixFileCache.default.clearInternalCache()
        
        if let obj1:Int = MixFileCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testMixReturn() {
        let obj = 500
        let key = "testMixKey"
        MixFileCache.default.set(obj, key: key)
        MixFileCache.default.clearInternalCache()
        
        if let obj1:Float = MixFileCache.default.get(key) {
            XCTAssertEqual(obj1, 500.0, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testWrongReturn() {
        let obj = 500
        let key = "testWrongKey"
        MixFileCache.default.set(obj, key: key)
        MixFileCache.default.clearInternalCache()
        
        if let obj1:String = MixFileCache.default.get(key) {
            print(obj1)
            XCTFail("key \(key) 不应该有值")
        }
    }
    
    func testExists() {
        let key = "testExistsKey"
        MixFileCache.default.set("ccccc", key: key)
        XCTAssertTrue(MixFileCache.default.exists(key: key), "key \(key) 应该存在")
        let key1 = "testExistsKey1"
        XCTAssertFalse(MixFileCache.default.exists(key: key1), "key \(key1) 应该不存在")
    }
    
    func testRemoveObject() {
        let key = "testRemoveKey"
        MixFileCache.default.set("dddd", key: key)
        MixFileCache.default.remove(objectForKey: key)
        let key1 = "testRemoveKey1"
        MixFileCache.default.remove(objectForKey: key1)
        let key2 = ""
        MixFileCache.default.remove(objectForKey: key2)
    }
    
}
