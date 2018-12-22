//
//  ApiClient.swift
//  food-suggestion
//
//  Created by Jaehyuk Rhee on 12/22/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

class ApiClient {
    func makeCall(request: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
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

class YelpApiClient: ApiClient {
    func createURLWithString(term: String) -> NSURL? {
        var urlString: String = "https://api.yelp.com/v3/businesses/search?type=restaurants&sort_by=best_match&location=nyc&term="
        
        // append query term
        urlString = urlString.appendingFormat(term)
        
        print(urlString)
        
        return NSURL(string: urlString)
    }
    
    func makeCall(term: String) {
        let url = self.createURLWithString(term: term)
        let yelpApiKey = "Bearer iHwv5fTrw6hN5RRxYMAlwiVRRe82Y2rj0cHh29PrnmlqUdqEmeWDI7b3o2Ddjh4uhw_26lKcigfqgBEbRonpD2FpqoZ3PXCAUk2rim0wayPee4qIiRzsOcYzvPbsW3Yx"
        let request = NSMutableURLRequest(url:url! as URL);
        request.httpMethod = "GET"
        request.setValue(yelpApiKey, forHTTPHeaderField: "Authorization")
        
        super.makeCall(request: request)
        
    }
}
