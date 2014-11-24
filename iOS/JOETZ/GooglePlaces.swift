//this service is free of charge
//atm limited to 100 requests per 24 hours
//can be upgraded to 10000 by supplying credit card information, still free of charge
//further upgrades can still be requested but require detailed explanation of usage.

import MapKit
import CoreLocation
import Foundation

class GooglePlaces {
    
    let URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    let KEY = "key=AIzaSyA0QRZtyzsOl4xcLKRxSX_DCD9TPGAabEg"
    
    // ------------------------------------------------------------------------------------------
    // Google Places search with callback
    // ------------------------------------------------------------------------------------------
    
    func search(
        query : String,
        completitionHandler:(items : [MKPlacemark]?, errorDescription : String?) -> Void) {
            
            
            var urlEncodedQuery = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            var urlString = "\(URL)\(KEY)&query=\(urlEncodedQuery!)"
            var url = NSURL(string: urlString)
            var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            session.dataTaskWithURL(url!, completionHandler: { (data : NSData!, response : NSURLResponse!, error : NSError!) -> Void in
                
                if error != nil {
                    completitionHandler(items: nil, errorDescription: error.localizedDescription)
                }
                
                if let statusCode = response as? NSHTTPURLResponse {
                    if statusCode.statusCode != 200 {
                        completitionHandler(items: nil, errorDescription: "Could not continue.  HTTP Status Code was \(statusCode)")
                    }
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completitionHandler(items: GooglePlaces.parseFromData(data), errorDescription: nil)
                })
                
            }).resume()
    }
    class func parseFromData(data : NSData) -> [MKPlacemark] {
        var pms = [MKPlacemark]()
        
        var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var results = json["results"] as? Array<NSDictionary>
        //println("results = \(results!.count)")
        
        for result in results! {
            
            var name = result["name"] as String
            
            var coordinate : CLLocationCoordinate2D!
            
            if let geometry = result["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    var lat = location["lat"] as CLLocationDegrees
                    var long = location["lng"] as CLLocationDegrees
                    coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    var pm = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                    pms.append(pm)
                }
            }
        }
        
        return pms
    }
}