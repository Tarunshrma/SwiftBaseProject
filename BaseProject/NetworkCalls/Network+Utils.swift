//
//  Network+Utils.swift
//  BaseProject
//
//  Created by Xoriant on 5/23/16.
//  Copyright © 2016 Xoriant. All rights reserved.
//

import Foundation
//Suggested by http://stackoverflow.com/users/1271826/rob
extension NetworkCalls {
    
    func generateBoundaryString()-> String{
        //return String("Boundary-\(NSUUID().UUIDString)")
        return String("Boundary-011000010111000001101001")
    }
    
    func createBodyWithBoundary(_boundry:String, parameters _param:[String:AnyObject]?, filePath _path:NSURL?, fieldName _fieldName:String)->NSData{
        
        let httpData:NSMutableData = NSMutableData()
        
        //============================================================================
        //                              Start add file data
        //============================================================================
        if let filePath = _path{
            let filename:String  = filePath.lastPathComponent!;
            let data:NSData      = NSData(contentsOfURL: filePath)!;
            let mimetype:String  = filePath.mimeType();
            
            let strBoundary:String = "--\(_boundry)\r\n"
            httpData.appendData(strBoundary.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let strParameterKey:String = "Content-Disposition: form-data; name=\u{22}\(_fieldName)\u{22}; filename=\u{22}\(filename)\u{22}\r\n"
            httpData.appendData(strParameterKey.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let strParameterType:String = "Content-Type: \(mimetype)\r\n\r\n"
            httpData.appendData(strParameterType.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            httpData.appendData(data)
            
            let strParameterValue:String = "\r\n"
            httpData.appendData(strParameterValue.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        //============================================================================
        //                              End add file data
        //============================================================================
        
        //============================================================================
        //                              Start adding params (all params are strings)
        //============================================================================
        if let dictParameters:[String:AnyObject] = _param{
            for (key,value) in dictParameters{
                let strBoundary:String = "--\(_boundry)\r\n"
                httpData.appendData(strBoundary.dataUsingEncoding(NSUTF8StringEncoding)!)
                
                let strParameterKey:String = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                httpData.appendData(strParameterKey.dataUsingEncoding(NSUTF8StringEncoding)!)
                
                let strParameterValue:String = "\(value)\r\n"
                httpData.appendData(strParameterValue.dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        //============================================================================
        //                              End adding params (all params are strings)
        //============================================================================
        
        //Cloes boundary
        let strClosingBoundary:String = "--\(_boundry)--\r\n"
        httpData.appendData(strClosingBoundary.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        return httpData
    }
    
    func getPostMethodBodyFromParameter(parameter:[String:AnyObject])throws ->NSData? {
        var postData:NSData?
        
        switch self.httpParameterEncoding{
        //In case if multi form data dont append anything to httpbody, instead do it externally from request caller method
        case .MultipartFormDataEncoding:fallthrough
            
        case .FormURLParameterEncoding:
            
            let parameterString = parameter.stringFromHttpParameters()
            if let paramString:String = parameterString{
                postData = paramString.dataUsingEncoding(NSUTF8StringEncoding)!
            }else{
                throw NetworkCallAPIError.InvalidPostParameter
            }
            
        case .JSONParameterEncoding:
            
            //Post method, attach parameter list in http body
            do{
                postData = try NSJSONSerialization.dataWithJSONObject(parameter, options: NSJSONWritingOptions.PrettyPrinted)
            }catch{
                throw NetworkCallAPIError.InvalidPostParameter
            }
            
            
        }
        
        return postData
    }
    
}


extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
    }
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
    
}


enum NetworkRequestMethod:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

//Request header encoding
enum HTTPClientParameterEncoding
{
    case FormURLParameterEncoding
    case JSONParameterEncoding
    case MultipartFormDataEncoding
}
