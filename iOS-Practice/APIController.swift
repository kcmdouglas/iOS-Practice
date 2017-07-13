//
//  APIController.swift
//  iOS-Practice
//
//  Created by Kassidy M Douglas on 7/3/17.
//  Copyright © 2017 Kassidy M Douglas. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {
    var delegate: APIControllerProtocol?
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: <#T##CharacterSet#>) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = URL(string: urlPath)
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                if(error != nil) {
                    print(error?.localizedDescription as Any)
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] {
                        if let results: NSArray = jsonResult["results"] as? NSArray {
                            self.delegate?.didReceiveAPIResults(results: results)
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            })
            
            task.resume()
        }
    }
}
