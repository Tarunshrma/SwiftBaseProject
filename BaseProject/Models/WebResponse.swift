//
//  WebResponse.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class WebResponse:BaseModel {
    var success:String!;
    var response:[String:AnyObject]?;
    var dateTime:String!;
    var error:Error?;
}