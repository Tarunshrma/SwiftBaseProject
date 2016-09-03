//
//  DateUtility.swift
//  CEAC
//
//  Created by Tarun Sharma on 5/11/16.
//  Copyright © 2016 Shival. All rights reserved.
//



import Foundation

class DateUtility{

    static func getElapsedTime(serverDateStr: String) -> String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy, hh:mm a"
        let currentDate = NSDate()
        let serverDate: NSDate! = dateFormatter.dateFromString(serverDateStr)
        let timeInSeconds = currentDate.timeIntervalSinceDate(serverDate);
        let uiStr:String!;
        if(timeInSeconds < 3600){
            let minutes = Int(timeInSeconds / 60);
            uiStr = "\(minutes) mins ago";
        }else if(timeInSeconds < (3600 * 24)){
            let hours = Int(timeInSeconds / 3600);
            uiStr = "\(hours) hours ago";
        }else{
            let days = Int(timeInSeconds / (3600 * 24));
            uiStr = "\(days) days ago";
        }
        
        return uiStr;
    }
    
}