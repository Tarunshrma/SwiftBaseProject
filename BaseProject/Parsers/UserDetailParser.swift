//
//  UserDetailParser.swift
//  BaseProject
//
//  Created by Tarun Sharma on 5/24/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import Foundation

class UserDetailParser:BaseParser {
    
    override init(response jsonData:AnyObject) {
        super.init(response: jsonData);
    }
    
    override func parseData() -> AnyObject {
        let userDetail:UserModel = UserModel();
        
        if (JsonUtility.isObjectType(fromJson: self.jsonData))
        {
            if let jsonDict:[String:AnyObject] = self.jsonData as? [String:AnyObject]
            {
                userDetail.userId = JsonUtility.getIntValue(fromJson: jsonDict, forKey: "userId")
                
                userDetail.title = JsonUtility.getStringValue(fromJson: jsonDict, forKey: "title")
                
                userDetail.body = JsonUtility.getStringValue(fromJson: jsonDict, forKey: "body")
                
                userDetail.id = JsonUtility.getIntValue(fromJson: jsonDict, forKey: "id")
            }
            
        }
        
        return userDetail;
    }
    

}