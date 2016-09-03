//
//  ViewController.swift
//  BaseProject
//
//  Created by Tarun Sharma on 21/05/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet var txtUserid:UITextField?
    @IBOutlet var txtName:UITextField?
    @IBOutlet var txtBody:UITextField?
    @IBOutlet var txtResponse:UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testGetRequest(sender:UIButton){
        self.txtResponse!.text = "";
        self.showNetworkActivityIndicator()
        //Test GET DATA API
        NetworkManager.sharedManager.getUserComments(["postId":"\(1)"]) { (obj, err) -> Void in
            var string:String = ""
            
            if let objUser:[UserComments] = obj as? [UserComments]{
                for comment:UserComments in objUser {
                    let str:String = "User ID \(comment.id)" + "\n" +
                        "Post ID \(comment.postId)" + "\n" +
                        "Name \(comment.name)" + "\n" +
                        "Email \(comment.email)" + "\n" +
                        "Body \(comment.body)" + "\n" +
                        "===================================="
                    
                    string = string + str
                }
            }
           
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideNetworkActivityIndicator()
                self.txtResponse!.text = string;
            });
            
        }
    }
    
    @IBAction func testPostRequest(sender:UIButton){
        self.txtResponse!.text = "";
         self.showNetworkActivityIndicator()
        //Test POST DATA API
        NetworkManager.sharedManager.postUserData(["userId":(self.txtUserid?.text)!,"title":(self.txtName?.text)!,"body":(self.txtBody?.text)!]) { (obj, err) -> Void in
            
            var string:String?
            
            if let objUser:UserModel = obj as? UserModel{
                string = "User ID \(objUser.id)" + "\n" +
                    "Title \(objUser.title)" + "\n" +
                    "Body \(objUser.body)" + "\n" +
                "===================================="
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideNetworkActivityIndicator()
                self.txtResponse!.text = string;
            });
            
        }
    }


}

