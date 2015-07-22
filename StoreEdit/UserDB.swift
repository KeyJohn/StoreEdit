//
//  UserDB.swift
//  StoreEdit
//
//  Created by keyzhang on 15/7/6.
//  Copyright © 2015年 keyzhang. All rights reserved.
//

import UIKit

class UserDB: NSObject, EGODatabaseRequestDelegate{
    
    var myblock: ([AnyObject?] -> ())?
    
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
    
    //添加一个用户
    func addUser(user: UserModel){
        //创建EGODatabase实例
        let database = EGODatabase(path: sqlite_file)
        //1.打开数据库
        database.open()
        
        
        //2.操作
        let sql = "insert into user(username,password,age) values(?,?,?)"
        let params = [user.username!, user.password!, user.age!]
        database.executeUpdate(sql, parameters: params)
        
        //3.关闭数据库
        database.close()
    }
    
    //删除一个用户
    func deleteUser(user: UserModel){
        //创建EGODatabase实例
        let database = EGODatabase(path: sqlite_file)
        //1.打开数据库
        database.open()
        
        
        //2.操作
        let sql = "delete from user where username = ?"
        let params = [user.username!]
        database.executeUpdate(sql, parameters: params)
        
        
        
        //3.关闭数据库
        database.close()
    }


    //查询用户
    func finderUser(comlitionHandle: [AnyObject?] -> ()) {
        let database = EGODatabase(path: sqlite_file)
        database.open()
        let sql = "select username,password,age from user"
        let request = database.requestWithQuery(sql)
        request.delegate = self
        self.myblock = comlitionHandle
        request.start()
        database.close()
    }
    
    //查询成功
    func requestDidSucceed(request: EGODatabaseRequest!, withResult result: EGODatabaseResult!) {
        var users = [AnyObject?]()
        
        for index in 0..<result.count() {
            let user = UserModel()
            let row = result.rowAtIndex(Int(index))
            user.username = row.stringForColumn("username")
//            user.password = row.stringForColumn("password")
            user.password = row.stringForColumnIndex(1)
            user.age = row.stringForColumn("age")
            users.append(user)
        }
        
        if let block = self.myblock {
            block(users)
        }
        
    }
    
    
    //查询失败
    func requestDidFail(request: EGODatabaseRequest!, withError error: NSError!) {
        print(error)
    }
    


}
