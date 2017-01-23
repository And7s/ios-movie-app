//
//  Http.swift
//  test_5
//
//  Created by Experteer on 29/12/16.
//  Copyright © 2016 Experteer. All rights reserved.
//

import UIKit

class Http {

    static func request(url: String, callback: @escaping (_ data: Any) -> Void) {
        // Set up the URL request
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in            // do stuff with response,
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                DispatchQueue.main.async(execute: {
                    callback(json)
                })
                
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
        
    }
}
