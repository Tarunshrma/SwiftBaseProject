//
//  UrlConstants.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 5/9/16.
//  Copyright © 2016 xoriant. All rights reserved.
//

import Foundation

class UrlConstants {
    static var getEvaluationListingUrl:String!{
        get{
            let strPath = NSBundle.mainBundle().pathForResource("02_evaluation-list-success", ofType: "json");
            return strPath;
        }
        
    };
}

