//
//  MixCacheableProtocol.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheableProtocol {
    
    var codedObject: NSCoding {get}
}

extension MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        if self is String       { return self as! NSString }
        else if self is Data    { return self as! NSData }
        else if self is Date    { return self as! NSDate }
        else if self is Int     { return NSNumber(value: self as! Int) }
        else if self is UInt    { return NSNumber(value: self as! UInt) }
        else if self is Int8    { return NSNumber(value: self as! Int8) }
        else if self is UInt8   { return NSNumber(value: self as! UInt8) }
        else if self is Int16   { return NSNumber(value: self as! Int16) }
        else if self is UInt16  { return NSNumber(value: self as! UInt16) }
        else if self is Int32   { return NSNumber(value: self as! Int32) }
        else if self is UInt32  { return NSNumber(value: self as! UInt32) }
        else if self is Int64   { return NSNumber(value: self as! Int64) }
        else if self is UInt64  { return NSNumber(value: self as! UInt64) }
        else if self is Float   { return NSNumber(value: self as! Float) }
        else if self is Double  { return NSNumber(value: self as! Double) }
        else if self is Bool    { return NSNumber(value: self as! Bool) }
        else { return self as! NSCoding}
    }
}

extension String: MixCacheableProtocol {}

extension Data: MixCacheableProtocol {}

extension Date: MixCacheableProtocol {}

extension Int: MixCacheableProtocol {}

extension UInt: MixCacheableProtocol {}

extension Int8: MixCacheableProtocol {}

extension UInt8: MixCacheableProtocol {}

extension Int16: MixCacheableProtocol {}

extension UInt16: MixCacheableProtocol {}

extension Int32: MixCacheableProtocol {}

extension UInt32: MixCacheableProtocol {}

extension Int64: MixCacheableProtocol {}

extension UInt64: MixCacheableProtocol {}

extension Float: MixCacheableProtocol {}

extension Double: MixCacheableProtocol {}

extension Bool: MixCacheableProtocol {}

