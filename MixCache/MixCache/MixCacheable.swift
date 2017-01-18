//
//  MixCacheable.swift
//  MixCache
//
//  Created by Eric Lung on 2017/1/18.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

public protocol MixCacheableProtocol {
    
    var codedObject: NSCoding {get}
}

extension String: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return self as NSString
    }
}

extension Data: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return self as NSData
    }
}

extension Date: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return self as NSDate
    }
}

extension Int: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension UInt: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Int8: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension UInt8: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Int16: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension UInt16: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Int32: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension UInt32: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Int64: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension UInt64: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Float: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Double: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

extension Bool: MixCacheableProtocol {
    
    public var codedObject: NSCoding {
        return NSNumber(value: self)
    }
}

