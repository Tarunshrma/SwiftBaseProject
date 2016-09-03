//
//  Error.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class Error:NSError{
    
    override init(domain: String, code: Int, userInfo dict: [NSObject : AnyObject]?) {
        super.init(domain: domain, code: code, userInfo: dict);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}