//
//  ViewController.swift
//  MixApp-iOS
//
//  Created by Mark Prichard on 3/22/16.
//  Copyright © 2016 AppDynamics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getHttpRequestHeaders(request: NSMutableURLRequest) {
        let infoPoint = ADEumInstrumentation.beginCall(self, selector: __FUNCTION__);
        let httpRequest = request
        let headers = httpRequest.allHTTPHeaderFields! as [String : String]
        NSLog("HTTP Request Headers: " + headers.description)
        ADEumInstrumentation.endCall(infoPoint)
    }
    
    func getHttpCookies(response: NSURLResponse,
        url : NSURL) {
            let infoPoint = ADEumInstrumentation.beginCall(self, selector: __FUNCTION__);
            let httpResponse = response as! NSHTTPURLResponse
            let headers = httpResponse.allHeaderFields as? [String : String]
            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(headers!, forURL: httpResponse.URL!)
            
            for cookie in cookies {
                NSLog(cookie.description)
            }
            ADEumInstrumentation.endCall(infoPoint)
    }

    
    func doHttpGet(url: NSURL) {
        let infoPoint = ADEumInstrumentation.beginCall(self, selector: __FUNCTION__);
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"

        NSLog(request.description)
        getHttpRequestHeaders(request)
        
        session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                NSLog(httpResponse.description)
                if (data != nil) {
                    //print(NSString(data: (data)!, encoding: NSUTF8StringEncoding)!)
                }
            }
            if (error != nil) {
                print("Error: \(error)")
                return
            }
        }).resume()
        ADEumInstrumentation.endCall(infoPoint)
    }
    
    @IBAction func onTestHttpConnection(sender: AnyObject) {
        NSLog("Test HTTP Connection")
        let url = NSUserDefaults.standardUserDefaults().stringForKey("url")
        self.doHttpGet(NSURL(string: url!)!)
    }

    @IBAction func TestJavaConnection(sender: AnyObject) {
        NSLog("Test Java Connection")
        var url = NSUserDefaults.standardUserDefaults().stringForKey("url")
        url = "\(url!)\(":3003/")"
        self.doHttpGet(NSURL(string: url!)!)
    }
    
    @IBAction func TestPHPConnection(sender: AnyObject) {
        NSLog("Test PHP Connection")
        var url = NSUserDefaults.standardUserDefaults().stringForKey("url")
        url = "\(url!)\(":3002/")"
        self.doHttpGet(NSURL(string: url!)!)
    }
    
    @IBAction func TestPythonConnection(sender: AnyObject) {
        NSLog("Test Python Connection")
        var url = NSUserDefaults.standardUserDefaults().stringForKey("url")
        url = "\(url!)\(":3001/")"
        self.doHttpGet(NSURL(string: url!)!)
    }
    
    @IBAction func TestNodejsConnection(sender: AnyObject) {
        NSLog("Test Node.js Connection")
        var url = NSUserDefaults.standardUserDefaults().stringForKey("url")
        url = "\(url!)\(":3000/")"
        self.doHttpGet(NSURL(string: url!)!)
    }
}

