//
//  ViewController.swift
//  MixCacheDemo
//
//  Created by Eric Long on 2021/9/15.
//  Copyright © 2021 Eric Lung. All rights reserved.
//

import UIKit
import MixCache

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        MixKeychainCache.shared.debug = true

        var key = "intkey"
        MixCache.keychain.set(123, key: key)
        let obj: Int? = MixCache.keychain.get(key)
        if (obj == nil) {
            print("obj faild")
        }
        
        MixCache.keychain.set(234, key: key)
        let obj11: Int? = MixCache.keychain.get(key)
        if (obj11 == nil) {
            print("obj11 faild")
        }
        
        let obj1: Float? = MixCache.keychain.get(key)
        if (obj1 == nil) {
            print("obj1 faild")
        }
        
        MixCache.keychain.remove(key)
        let obj12: Int? = MixCache.keychain.get(key)
        if (obj12 == nil) {
            print("obj12 nil")
        }
        
        key = "stringkey"
        MixCache.keychain.set("123", key: key)
        let obj2: String? = MixCache.keychain.get(key)
        if (obj2 == nil) {
            print("obj2 faild")
        }
        
        key = "arraykey"
        MixCache.keychain.set(["123", "ddd", Date(), NSUUID(), NSURL(string: "https://baidu.com")!], key: key)
        if let obj3: [Any] = MixCache.keychain.get(key) {
            print(obj3)
        }
        else {
            print("obj3 faild")
        }
    }
}

