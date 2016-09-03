//
//  UserCommentParser.swift
//  BaseProject
//
//  Created by Tarun Sharma on 5/24/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import Foundation
class UserCommentParser:BaseParser {
    
    override init(response jsonData:AnyObject) {
        super.init(response: jsonData);
    }
    
    override func parseData() -> AnyObject {
        
        var obj = [UserComments]()
        
        if(JsonUtility.isArrayType(fromJson: self.jsonData)){
            //Enumerate over items and parse it
            if let comments:[[String:AnyObject]] = self.jsonData as? [[String:AnyObject]]{
                
                
                if let objComments:[[String:AnyObject]] = comments{
                    for dict:[String:AnyObject] in objComments{
                        obj.append(parseItem(dict))
                    }
                }
                
            }
        }else if(JsonUtility.isObjectType(fromJson: self.jsonData)){
            //parse it
            obj.append(parseItem(self.jsonData as! [String : AnyObject]))
        }
        
        return obj;
        
    }
    
    private func parseItem(jsoDict:[String:AnyObject])->UserComments
    {
        let userComment:UserComments = UserComments();
        
        if (JsonUtility.isObjectType(fromJson: jsoDict))
        {
            if let jsonDict:[String:AnyObject] = jsoDict
            {
                userComment.postId = JsonUtility.getIntValue(fromJson: jsonDict, forKey: "postId")
                
                userComment.name = JsonUtility.getStringValue(fromJson: jsonDict, forKey: "name")
                
                userComment.body = JsonUtility.getStringValue(fromJson: jsonDict, forKey: "body")

                userComment.email = JsonUtility.getStringValue(fromJson: jsonDict, forKey: "email")
                
                userComment.id = JsonUtility.getIntValue(fromJson: jsonDict, forKey: "id")
            }
            
        }
        
        return userComment;
    }
}