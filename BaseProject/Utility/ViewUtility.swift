//
//  ViewUtility.swift
//  CEAC
//
//  Created by Tarun Sharma on 5/10/16.
//  Copyright © 2016 Shival. All rights reserved.
//

import Foundation
import UIKit

class ViewUtility{
    
    static func getCustomLabel(text:String, font:UIFont, frame:CGRect)-> UILabel{
        let lbl = UILabel(frame: frame);
        lbl.text = text;
        lbl.font = font;
//        lbl.backgroundColor = UIColor.orangeColor();
        return lbl;
    }
    
/*!
 * @discussion This method is used to get the height of label at runtime based on text
 * @param text input text that will be displayed in label
 * @param font label font
 * @warning width label fixed width
 * @return height of label based on label attribute
 */
   static func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 20
    }
}