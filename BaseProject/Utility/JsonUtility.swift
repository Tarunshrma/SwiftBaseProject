//
//  JsonUtility.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class JsonUtility{
    
    static func getStringValue(fromJson json:[String:AnyObject], forKey key:String)-> String{
        guard let value  = json[key] else {
            return "";
        }
        
        return value as! String;
    }
    
    static func getIntValue(fromJson json:[String:AnyObject], forKey key:String)-> Int{
        guard let value:Int  = json[key] as? Int else {
            return -1;
        }
        
        return value;
    }

    static func getDictionary(fromJson json:[String:AnyObject], forKey key:String)-> [String:AnyObject]?{
        guard let value  = json[key] as? [String:AnyObject] else {
            return nil;
        }
        
        return value;
    }
    
    static func getArray(fromJson json:[String:AnyObject], forKey key:String)-> [[String:AnyObject]]?{
        guard let value  = json[key] as? [[String:AnyObject]] else {
            return nil;
        }
        
        return value;
    }

    static func isObjectType(fromJson json:AnyObject)->Bool{
        return json.isKindOfClass(NSDictionary) ? true:false
    }
    
    static func isArrayType(fromJson json:AnyObject)->Bool{
        return json.isKindOfClass(NSArray) ? true:false
    }
}