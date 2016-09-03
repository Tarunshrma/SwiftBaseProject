//
//  NetworkRequestIdentifier.swift
//  BaseProject
//
//  Created by Tarun Sharma on 21/05/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import Foundation

enum NetworkAPIEndPoints:String {
    case BaseUrl = "http://jsonplaceholder.typicode.com/"
    case PostUserData = "posts"
    case GetUserComment = "comments"
    
    func getParser(jsonData:AnyObject)->BaseParser{
        
        var parser:BaseParser;
        
        switch self{
            case BaseUrl:
                parser =  BaseParser(response: jsonData)
            case PostUserData:
                parser =  UserDetailParser(response: jsonData)
            case GetUserComment:
                parser =  UserCommentParser(response: jsonData)
            }
        
        return parser;
    }
    
}