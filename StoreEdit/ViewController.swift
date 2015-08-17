//
//  ViewController.swift
//  StoreEdit
//
//  Created by keyzhang on 15/7/6.
//  Copyright © 2015年 keyzhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    
    @IBAction func editorAction(sender: UIButton) {
        sender.selected = !sender.selected
        self.myTable.editing = sender.selected
    }
    
    var dataList = [AnyObject?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshUI()
        
        
    }

    @IBAction func addObject(sender: AnyObject) {
        
        //添加数据
        let alert = UIAlertController(title: "AddUser", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (tf: UITextField) -> Void in
            tf.placeholder = "username"
        }
        alert.addTextFieldWithConfigurationHandler { (tf: UITextField) -> Void in
            tf.placeholder = "password"
            tf.secureTextEntry = true
        }
        alert.addTextFieldWithConfigurationHandler { (tf: UITextField) -> Void in
            tf.placeholder = "age"
        }

        
        let sureAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            let usernameTF = alert.textFields![0]
            let passwordTF = alert.textFields![1]
            let ageTF = alert.textFields![2]
            
            let userModel = UserModel()
            userModel.username = usernameTF.text
            userModel.password = passwordTF.text
            userModel.age = ageTF.text
            
            let ud = UserDB.shareUserDB
            ud.addUser(userModel)
            
            //刷新UI
            self.refreshUI()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
        }

        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //刷新UI
    func refreshUI() {
        let ud = UserDB.shareUserDB
        ud.finderUser { (users: [AnyObject?]) -> () in
            self.dataList = users
            self.myTable.reloadData()
        }
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let model = self.dataList[indexPath.row] as! UserModel
        cell.textLabel?.text = "name--\(model.username!)    pass--\(model.password!)    age--\(model.age!)"
        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete", handler: { (action, indexPath) -> Void in
            
            let userModel = self.dataList[indexPath.row] as! UserModel
            
            let ud = UserDB.shareUserDB
            ud.deleteUser(userModel)
            self.refreshUI()
        })]
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 {
            return UITableViewCellEditingStyle.Delete
        }else if indexPath.row == 1 {
            return UITableViewCellEditingStyle.Insert
        }else {
            return UITableViewCellEditingStyle.None
        }
//        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}

