//
//  MixCache.swift
//  MixCache
//
//  Created by Eric Long on 2021/9/15.
//  Copyright © 2021 Eric Lung. All rights reserved.
//

import Foundation

public class MixCache {

    public static var file: MixCacheProtocol {
        return MixFileCache.shared
    }
    
    public static var keychain: MixCacheProtocol {
        return MixKeychainCache.shared
    }
}
