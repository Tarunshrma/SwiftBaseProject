//
//  WebResponseParser.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class WebResponseParser:BaseParser{
    
    override init(response jsonData:[String:AnyObject]) {
        super.init(response: jsonData);
    }
    
    func parseData()-> WebResponse{
        let webResponse = WebResponse();
        webResponse.success = JsonUtility.getStringValue(fromJson: self.jsonData, forKey: "success");
        webResponse.response = JsonUtility.getDictionary(fromJson: self.jsonData, forKey: "response");
        webResponse.dateTime = JsonUtility.getStringValue(fromJson: self.jsonData, forKey: "date-time");
        
        if let errorJson:[String:AnyObject] = JsonUtility.getDictionary(fromJson: self.jsonData, forKey: "error") {
            let errorParser = ErrorParser(response: errorJson);
            webResponse.error = errorParser.parseData();
        }else{
            webResponse.error = nil;
        }
        
        
        return webResponse;
    }
}