//
//  BaseParser.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

protocol BaseParserDelegate {
    func parseData()->AnyObject;
}

class BaseParser:NSObject,BaseParserDelegate{
    let jsonData:AnyObject!;
    
    init(response jsonData:AnyObject!) {
        self.jsonData = jsonData;
    }
    
    func parseData()->AnyObject{
        fatalError("parseData() is abstract and must be overriden!");
    }

}