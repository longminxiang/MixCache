//
//  MixCacheable.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheable {
    associatedtype RefType where RefType: NSObject, RefType: NSCoding
    var codedObject: RefType {get}
}

extension MixCacheable {
    public var codedObject: RefType { return self as! RefType }
}

public protocol MixNumCacheable: MixCacheable where RefType == NSNumber {}

extension String: MixCacheable { public typealias RefType = NSString }

extension Data: MixCacheable { public typealias RefType = NSData }

extension Date: MixCacheable { public typealias RefType = NSDate }

extension Int: MixNumCacheable {}

extension UInt: MixNumCacheable {}

extension Int8: MixNumCacheable {}

extension UInt8: MixNumCacheable {}

extension Int16: MixNumCacheable {}

extension UInt16: MixNumCacheable {}

extension Int32: MixNumCacheable {}

extension UInt32: MixNumCacheable {}

extension Int64: MixNumCacheable {}

extension UInt64: MixNumCacheable {}

extension Float: MixNumCacheable {}

extension Double: MixNumCacheable {}

extension Bool: MixNumCacheable {}
