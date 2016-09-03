//
//  Network.swift
//  NetworkCalls
//
//  Created by Tarun Sharma on 4/18/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import UIKit

// MARK: - Exception Types -
enum NetworkCallAPIError: ErrorType {
    case InvalidURL
    case InvalidRequest
    case InvalidPostParameter
}

// MARK: - Callback methods -
protocol NetworkOperations {
    func didReceiveReposne(data: AnyObject?, forTaskIdentifer taskIdentifier:Int)
    func didReceiveError(error:NSError, forTaskIdentifer taskIdentifier:Int)
}

// MARK: - Core netowrk class responsible to make api calls -
class NetworkCalls: NSObject {
    
    // MARK: - Private Member Variables -
    private var delegate : NetworkOperations?
    private var taskIdentifer : Int?
    private var baseUrl: NSURL
    
    var httpParameterEncoding:HTTPClientParameterEncoding
    
    // MARK: - Class methods -
    /*!
     * @discussion Constructer to initialize NetworkCalls object with delegate base url
     * @param _baseURL: base url or hostname where to make api calls
     * @param _delegate: Callback delegate
     * @return instance of NetworkCalls
     */
    //Handle try catch to check if proper netowork object is formed
    init(baseUrl _baseurl:String, delegate _delegate:NetworkOperations) {
        self.baseUrl = NSURL(string: _baseurl)!;
        self.delegate = _delegate;
        
        //Default encoding is form url
        self.httpParameterEncoding = .JSONParameterEncoding
        //self.requestIdentifer = _requestIdentifer;
    }
    
    /*!
     * @discussion This method returns the request object based on passed parameter, http method & api endpoint
     * @param method: HTTP method e.g. GET,POST etc
     * @param apiEndPoint: API Path where to make the call
     * @param apiEndPoint: API parameters
     * @return Instance of NSMutableURLRequest, wrap around all request data, Invalid url exception if url is invalid
     */
    func requestWithMethod(method _method:NetworkRequestMethod, apiEndPoint _endPoint:NetworkAPIEndPoints, parameters _parameters:[String:AnyObject]?)throws ->NSMutableURLRequest{
        
        //Append the path to base url
        var url = NSURL(string: _endPoint.rawValue, relativeToURL: self.baseUrl)
        
        let request:NSMutableURLRequest = NSMutableURLRequest();
        request.HTTPMethod = _method.rawValue;
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let boundary:String = self.generateBoundaryString()
        
        //        //Set the content type based on http parameter encoding
        switch self.httpParameterEncoding{
        case .FormURLParameterEncoding:
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        case .JSONParameterEncoding:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .MultipartFormDataEncoding:
            let contentType:String = "multipart/form-data; boundary=\(boundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        if let param = _parameters{
            switch _method{
            case .GET:
                //Get method, attach parameter list as query string
                let parameterString = param.stringFromHttpParameters()
                url = NSURL(string:"\(url!.absoluteString)?\(parameterString)")!
                break
            case .POST:
                //Post method, attach parameter list in http body
                do{
                    request.HTTPBody = try getPostMethodBodyFromParameter(param)
                }catch{
                    throw NetworkCallAPIError.InvalidPostParameter
                }
                
                break
            default: ()
            }
        }
        
        //throw invalid url type exception
        guard url != nil else{
            throw NetworkCallAPIError.InvalidURL
        }
        
        request.URL = url;
        
        return request;
    }
    //multipart/x-zip
    //Suggested by http://stackoverflow.com/users/1271826/rob
    func mutipartRequestWithMethod(method _method:NetworkRequestMethod, apiEndPoint _endPoint:NetworkAPIEndPoints, parameters _parameters:[String:AnyObject]?, filePath _filePath:NSURL, fileName _fileName:String)throws ->NSMutableURLRequest{
        assert(_method != .GET , "GET method not allowed for multipart request")
        
        let request:NSMutableURLRequest
        
        do{
            self.httpParameterEncoding  = .MultipartFormDataEncoding
            request = try self.requestWithMethod(method: _method, apiEndPoint: _endPoint, parameters: nil)
        }catch NetworkCallAPIError.InvalidURL{
            throw NetworkCallAPIError.InvalidURL
        }
        
        //Add mutipart form data to content type header
        let boundary:String = self.generateBoundaryString()
        //        let contentType:String = "multipart/form-data; boundary=\(boundary)"
        //        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        //Create mutipart boundry
        let mutipartBody:NSData = self.createBodyWithBoundary(boundary, parameters: _parameters, filePath: _filePath, fieldName: _fileName)
        
        request.HTTPBody = mutipartBody
        
        return request
    }
    
    /*!
     * @discussion API call to fetch/post data
     * @param Request object of type NSMutableURLRequest
     * @return Instance of task
     */
    func dataAPIWithRequest(_req:NSMutableURLRequest)-> NSURLSessionTask{
        
        let session = NSURLSession.sharedSession()
        var task:NSURLSessionTask?
        task =  session.dataTaskWithRequest(_req, completionHandler: { ( data: NSData?, response: NSURLResponse?, err: NSError?) -> Void in
            
            self.taskIdentifer = task!.taskIdentifier
            
            //if error found then return to delegate
            if (err != nil){
                self.delegate!.didReceiveError(err!,forTaskIdentifer: self.taskIdentifer!);
                return;
            }
            
            //Try to parse the recieved data to dictionary
            do {
                // Parse the JSON to get the IP
                let jsonDictionary:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                //Handle generic error recieved from status header
                let objResponse:NSHTTPURLResponse = response as! NSHTTPURLResponse;
                if (objResponse.statusCode != 200) {
                    //Something bad happened
                    var errorMessage:String = ""
                    
                    //try to get error message
                    if let strErrorMessage:String = jsonDictionary["error_description"] as? String{
                        errorMessage = strErrorMessage
                    }
                    
                    if let strErrorMessage:String = jsonDictionary["Message"] as? String{
                        errorMessage = strErrorMessage
                    }
                    
                    if let strErrorMessage: String = jsonDictionary["ErroMessage"] as? String{
                        errorMessage = strErrorMessage
                    }
                    
                    let error = NSError(domain: "HTTPError", code: objResponse.statusCode, userInfo: [NSLocalizedDescriptionKey:errorMessage])
                    
                    self.delegate!.didReceiveError(error,forTaskIdentifer: self.taskIdentifer!);
                    return;
                }
                
                self.delegate?.didReceiveReposne(jsonDictionary, forTaskIdentifer: self.taskIdentifer!)
            }catch let error as NSError {
                //Handle Error
                self.delegate!.didReceiveError(error,forTaskIdentifer: self.taskIdentifer!);
            }
        })
        task!.resume();
        return task!;
    }
    
    
}
