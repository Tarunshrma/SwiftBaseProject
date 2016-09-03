//
//  CacheManager.swift
//  CEAC
//
//  Created by Tarun Sharma on 5/11/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import Foundation

typealias ServiceResponse = (AnyObject?, NSError?) -> Void

// MARK: - Wrap around network tasks for tracking purpose -
class NetworkRequest {
    private var tasks:NSURLSessionTask!;
    private var completionHandler:ServiceResponse!;
    private var apiEndPoint:NetworkAPIEndPoints!
    
    init(withTask task: NSURLSessionTask, request requestIdentier:NetworkAPIEndPoints, completionHandler completion:ServiceResponse){
        self.tasks = task;
        self.completionHandler = completion;
        self.apiEndPoint = requestIdentier;
    }
}

// MARK: Extension Class to handle Queue-Dequeue of active tasks
extension NetworkManager{
    
    /*!
    * @discussion Enqueue all incoming api requests to track the active running tasks
    */
    private func enqueueNetworkRequest(networkRequest:NetworkRequest){
        self.activeTasks.append(networkRequest)
    }
    
    /*!
    * @discussion Dequeue api requests once recieved response from server
    */
    private func deQueueNetworkRequest(networkRequest:NetworkRequest){
        
        let index = self.activeTasks.indexOf{$0 === networkRequest}
        guard let idx = index where idx>=0 && idx<self.activeTasks.count else{
            //Do nothing
            return
        }
        
        self.activeTasks.removeAtIndex(idx)
    }
    
    /*!
    * @discussion Get instance of network request(urlsession task+completion handler) from task identifier.
    */
    private func getNetworkRequest(forTaskIdentifier taskIdentifier:Int)->NetworkRequest?{
        
        var filteredRequest = self.activeTasks.filter( { (networkRequest: NetworkRequest) -> Bool in
            return networkRequest.tasks.taskIdentifier == taskIdentifier;
        });
        
        guard let objRequest:NetworkRequest = filteredRequest[0] else{
            return nil;
        }
        
        return objRequest;
    }
    
}

// MARK: Extension Class to handle netowork api calls
extension NetworkManager{
    //TEST POST METHOD
    func postUserData(data:[String:String],completionHandler: ServiceResponse){
        //Define the endpoint of API
        let apiEndPoint:NetworkAPIEndPoints = .PostUserData
        callAPI(apiEndPoint,method: .POST , data: data, completionHandler: completionHandler)
    }

    //TEST GET METHOD
    func getUserComments(data:[String:String],completionHandler: ServiceResponse){
        //Define the endpoint of API
        let apiEndPoint:NetworkAPIEndPoints = .GetUserComment
        callAPI(apiEndPoint,method: .GET ,data: data, completionHandler: completionHandler)
    }

    
}

// MARK: NetworkManager class to handle all network api calls
class NetworkManager:NSObject,NetworkOperations {

    // MARK: - Private Member Variables -
    private var activeTasks:[NetworkRequest] = [NetworkRequest](); //initilize empty active running request
    
    /*!
    * @discussion Static class method to get singleton instance of NetworkManager class
    */
    class var sharedManager: NetworkManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    func callAPI(endPoint:NetworkAPIEndPoints,method:NetworkRequestMethod, data:[String:String],completionHandler: ServiceResponse){
        
        //Define the endpoint of API
        let apiEndPoint:NetworkAPIEndPoints = endPoint
        
        //Create instance of network core class
        let op = NetworkCalls(baseUrl: NetworkAPIEndPoints.BaseUrl.rawValue, delegate: self)
        
        do{
            let req = try op.requestWithMethod(method: method, apiEndPoint: apiEndPoint, parameters: data)
            
            let task:NSURLSessionTask = op.dataAPIWithRequest(req)
            
            //Enqueue request
            let objRequest = NetworkRequest(withTask: task, request: apiEndPoint, completionHandler: completionHandler)
            self.enqueueNetworkRequest(objRequest)
            
        }catch NetworkCallAPIError.InvalidURL{
            print("Invalid url type, plase check the url")
        }catch let error as NSError {
            print("Unbknown error \(error)")
            completionHandler(nil,error)
        }
    }

    
    // MARK: - API Delegate Methods -
    
    /*!
    * @discussion Callback delegate method to response recieved from server response
    * @param data: Response recieved
    * @param taskIdentifier: Task identifier to de-queue network request object from active running tasks
    */
    func didReceiveReposne(data: AnyObject?, forTaskIdentifer taskIdentifier:Int){
        
        //Fetch the netowrk request object from active running tasks queue
        guard let networkRequest = self.getNetworkRequest(forTaskIdentifier: taskIdentifier) else{
            return;
        }
        
        //Parse the data
        let parsedData:AnyObject = networkRequest.apiEndPoint.getParser(data!).parseData();
        
        //get the callback from aboe fetched object
        let callback:ServiceResponse = networkRequest.completionHandler
        
        //Received reposne from API.
        if let webResponse:AnyObject = parsedData{
            //Return Error
            callback(webResponse, nil)
        }else{
            let error = Error(domain: "HttpResponseErrorDomain", code:111 , userInfo: nil)
            callback(nil, error)
        }
        
         //De-queue the request object from active running tasks list
        self.deQueueNetworkRequest(networkRequest)
    }
    
    /*!
    * @discussion Callback delegate method to handle error recieved from server response
    * @param error: Error recieved
    * @param taskIdentifier: Task identifier to de-queue network request object from active running tasks
    */
    func didReceiveError(error: NSError, forTaskIdentifer taskIdentifier:Int) {
        // received error
        guard let networkRequest = self.getNetworkRequest(forTaskIdentifier: taskIdentifier) else{
            return;
        }
        
        let callback:ServiceResponse = networkRequest.completionHandler
        callback(nil, error)
        
        //De-queue the request object from active running tasks list
        self.deQueueNetworkRequest(networkRequest)
    }

}