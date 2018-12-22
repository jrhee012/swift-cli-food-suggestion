//
//  ApiClient.swift
//  food-suggestion
//
//  Created by Jaehyuk Rhee on 12/22/18.
//  Copyright © 2018 Jaehyuk Rhee. All rights reserved.
//

import Foundation

class ApiClient {
    func syncRequest(request: NSMutableURLRequest) -> NSDictionary {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var result:NSDictionary = [:]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    result = convertedJsonIntoDict
                    semaphore.signal()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
    
    public func makeCall(request: NSMutableURLRequest) {
        
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
    private func createURLWithString(term: String) -> NSURL? {
        var urlString: String = "https://api.yelp.com/v3/businesses/search?type=restaurants&sort_by=best_match"
        
        // append query term
        let location = "nyc"
        urlString = urlString.appendingFormat("&location=" + location)
        urlString = urlString.appendingFormat("&term=" + term)
        
//        print(urlString)
        
        return NSURL(string: urlString)
    }
    
    private func getHighestRating(businesses: NSArray) -> NSDictionary {
        var result: NSDictionary = [:]
        var rating: Float = 0.0
        var id: String = ""
        for business in businesses {
            let currentRating = ((business as! NSDictionary)["rating"] ?? 0.0) as! Float
            let currentId = ((business as! NSDictionary)["id"] ?? "") as! String
            if currentRating >= rating {
                rating = currentRating
                id = currentId
            }
        }
        
        for business in businesses {
            let currentId = ((business as! NSDictionary)["id"] ?? "") as! String
            if currentId == id {
                result = business as! NSDictionary
            }
        }
        
        return result
    }
    
    private func printResult(business: NSDictionary) {
        let display_phone = business["display_phone"] ?? ""
        let name = business["name"] ?? ""
        let location = business["location"] as! NSDictionary
        let address = location["display_address"] as! NSArray
        var display_address: String = ""
        for addr in address {
            display_address += (addr as? String ?? "") + " "
        }
        
        print("Best Match:")
        print("==================================================")
        print("Name         : ", name)
        print("Address      : ", display_address)
        print("Phone number : ", display_phone)
        
    }
    
    private func makeCall(term: String) {
        let url = self.createURLWithString(term: term)
        let yelpApiKey = "Bearer iHwv5fTrw6hN5RRxYMAlwiVRRe82Y2rj0cHh29PrnmlqUdqEmeWDI7b3o2Ddjh4uhw_26lKcigfqgBEbRonpD2FpqoZ3PXCAUk2rim0wayPee4qIiRzsOcYzvPbsW3Yx"
        let request = NSMutableURLRequest(url:url! as URL);
        request.httpMethod = "GET"
        request.setValue(yelpApiKey, forHTTPHeaderField: "Authorization")
        
        let results = super.syncRequest(request: request)
        
        if let businesses = results["businesses"] as? NSArray {
            let final = self.getHighestRating(businesses: businesses)
//            print(final)
            self.printResult(business: final)
        }
        
    }
    
    public func queryTerm(term: String) {
        let spaceRemoved = term.replacingOccurrences(of: " ", with: "")
        self.makeCall(term: spaceRemoved)
    }
    
}
