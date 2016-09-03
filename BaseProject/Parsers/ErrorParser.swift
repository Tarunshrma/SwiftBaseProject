//
//  ErrorParser.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class ErrorParser:BaseParser{

    override init(response jsonData:[String:AnyObject]) {
        super.init(response: jsonData);
    }
    
    func parseData()-> Error?{

        guard let errJson = self.jsonData else{
            return nil;
        }
        
        let userInfo: [NSObject : AnyObject] =
        [
            NSLocalizedDescriptionKey :  JsonUtility.getStringValue(fromJson: errJson, forKey: "message"),
        ]
        
        let error = Error(domain: "HttpResponseErrorDomain", code: JsonUtility.getIntValue(fromJson: errJson, forKey: "code"), userInfo: userInfo)
        
        return error;
    }
}