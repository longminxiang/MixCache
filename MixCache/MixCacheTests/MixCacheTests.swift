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
        var cache: MixCache? = MixCache.default
        XCTAssertNotNil(cache, "init with default failed");
        
        cache = MixCache("TestCache")
        XCTAssertNotNil(cache, "init with name failed");
        
    }
    
    func testSetString() {
        let obj = "xxxxxx"
        let key = "testStringKey"
        MixCache.default.set(obj, key: key)
        
        if let obj1:String = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetObjects() {
        let obj = ["xxxxxx", "dddd", "e3333"]
        let key = "testObjectsKey"
        MixCache.default.set(obj, key: key)
        
        if let obj1:[String] = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetDate() {
        let obj = Date()
        let key = "testDateKey"
        MixCache.default.set(obj, key: key)
        
        if let obj1:Date = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetData() {
        if let obj = "123".data(using: .utf8) {
            let key = "testDataKey"
            MixCache.default.set(obj, key: key)
            MixCache.default.clearInternalCache()
            
            if let obj1:Data = MixCache.default.get(key) {
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
        MixCache.default.set(obj, key: key)
        MixCache.default.clearInternalCache()
        
        if let obj1:NSUUID = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testSetNSCodingObjects() {
        let obj = [NSUUID(), NSUUID(), NSUUID(), NSUUID()]
        let key = "testNSCodingObjectsKey"
        MixCache.default.set(obj, key: key)
        MixCache.default.clearInternalCache()
        
        if let obj1:[NSUUID] = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testInt() {
        let obj = 500
        let key = "testIntKey"
        MixCache.default.set(obj, key: key)
        MixCache.default.clearInternalCache()
        
        if let obj1:Int = MixCache.default.get(key) {
            XCTAssertEqual(obj, obj1, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testMixReturn() {
        let obj = 500
        let key = "testMixKey"
        MixCache.default.set(obj, key: key)
        MixCache.default.clearInternalCache()
        
        if let obj1:Float = MixCache.default.get(key) {
            XCTAssertEqual(obj1, 500.0, "设置和取回来的值不相等")
        }
        else {
            XCTFail("key \(key) 应该有值")
        }
    }
    
    func testWrongReturn() {
        let obj = 500
        let key = "testWrongKey"
        MixCache.default.set(obj, key: key)
        MixCache.default.clearInternalCache()
        
        if let obj1:String = MixCache.default.get(key) {
            print(obj1)
            XCTFail("key \(key) 不应该有值")
        }
    }
    
}
