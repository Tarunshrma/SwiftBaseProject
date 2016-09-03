//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Tarun Sharma on 21/05/16.
//  Copyright © 2016 Tarun Sharma. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var vwActivityIndicator:UIView?
    private var activityIndicator:UIActivityIndicatorView?
    
    private let IndicatorViewWidth:CGFloat = 120
    private let IndicatorViewHeight:CGFloat = 80
    private let ActivityIndicatorViewSize:CGFloat = 35

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupActivityIndicator(){
        
        if (self.vwActivityIndicator != nil)
        {
            self.vwActivityIndicator?.removeFromSuperview()
            self.vwActivityIndicator = nil
        }
        
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        var xCordinate = screenBounds.size.width/2-IndicatorViewWidth/2
        var yCordinate = screenBounds.size.height/2-IndicatorViewHeight/2
        
        self.vwActivityIndicator = UIView(frame: CGRectMake(xCordinate, yCordinate, IndicatorViewWidth, IndicatorViewHeight))
        
        self.vwActivityIndicator?.backgroundColor = UIColor.blackColor()
        self.vwActivityIndicator?.alpha = 0.8
        self.vwActivityIndicator?.layer.borderColor = UIColor.whiteColor().CGColor
        self.vwActivityIndicator?.layer.borderWidth = 3.0
        self.vwActivityIndicator?.layer.cornerRadius = 5.0

        xCordinate = IndicatorViewWidth/2-ActivityIndicatorViewSize/2
        yCordinate = IndicatorViewHeight/2-ActivityIndicatorViewSize/2

        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(xCordinate,yCordinate,ActivityIndicatorViewSize,ActivityIndicatorViewSize))
        self.vwActivityIndicator?.addSubview(self.activityIndicator!)
        self.activityIndicator?.startAnimating()
        
        self.view.addSubview(self.vwActivityIndicator!)
    }
    
    func showNetworkActivityIndicator(){
        self.view.userInteractionEnabled = false
        setupActivityIndicator()
    }
    
    func hideNetworkActivityIndicator(){
        self.view.userInteractionEnabled = true
        self.vwActivityIndicator?.removeFromSuperview()
    }
    
    
}