//
//  UserDB.swift
//  StoreEdit
//
//  Created by keyzhang on 15/8/14.
//  Copyright © 2015年 keyzhang. All rights reserved.
//

import UIKit

class UserDB: NSObject {
    var myblock: ([AnyObject?] -> ())!
    
    let sqlite_file = NSHomeDirectory().stringByAppendingString("/Documents/mydatabase1.sqlite")
    
    
    //构建单例方法
    class var shareUserDB: UserDB{
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: UserDB? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = UserDB()
        }
        return Static.instance!
    }

    
}
