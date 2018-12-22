//
//  ApiClient.swift
//  food-suggestion
//
//  Created by Jaehyuk Rhee on 12/22/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

class ApiClient {
    func createURLWithString(term: String) -> NSURL? {
        var urlString: String = "https://api.yelp.com/v3/businesses/search?type=restaurants&sort_by=best_match&location=nyc&term="
        
        // append params
        urlString = urlString.appendingFormat(term)
        
        print(urlString)
        
        return NSURL(string: urlString)
    }
    
//    func createURLWithComponents(date: NSDate) -> NSURL? {
//        let urlComponents = NSURLComponents()
//        urlComponents.scheme = "https";
//        urlComponents.host = "api.yelp.com";
//        urlComponents.path = "/v3/businesses/search";
//
//        return urlComponents.URL
//    }
    
    func makeCall(term: String) {
        let url = self.createURLWithString(term: term)
        let yelpApiKey = "Bearer iHwv5fTrw6hN5RRxYMAlwiVRRe82Y2rj0cHh29PrnmlqUdqEmeWDI7b3o2Ddjh4uhw_26lKcigfqgBEbRonpD2FpqoZ3PXCAUk2rim0wayPee4qIiRzsOcYzvPbsW3Yx"
//        let myUrl = NSURL(string: url);
        let request = NSMutableURLRequest(url:url! as URL);
        request.httpMethod = "GET"
        request.setValue(yelpApiKey, forHTTPHeaderField: "Authorization")
        // If needed you could add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
//        request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
//    YELP_API_KEY=iHwv5fTrw6hN5RRxYMAlwiVRRe82Y2rj0cHh29PrnmlqUdqEmeWDI7b3o2Ddjh4uhw_26lKcigfqgBEbRonpD2FpqoZ3PXCAUk2rim0wayPee4qIiRzsOcYzvPbsW3Yx
//        YELP_CLIENT_ID=XZ8W1NIkO-iJSMFjEiGw9Q
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
//            Print out response string
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("responseString = \(String(describing: responseString))")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
}
