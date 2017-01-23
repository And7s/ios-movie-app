//
//  ImageStorage.swift
//  test_4
//
//  Created by Experteer on 28/12/16.
//  Copyright © 2016 Experteer. All rights reserved.
//

import UIKit

class ImageStorage {
    static private var images: [String: UIImage] = [:]
    init() {
        
    }
    
    static public func loadImage(path: String, imageView: MyImageView) {
        print("load\(path)")
        
        imageView.targetUrl = path
        if (path == "") {
            imageView.image = nil
            print("empty or invalid path requested, cant load")
            return
        }
        
        if (ImageStorage.images[path] != nil) {
            print("get image from cache")
            
            imageView.image = ImageStorage.images[path]
        } else {
            imageView.image = nil
            print("will load from server")
            
            let imageUrlString = "https://image.tmdb.org/t/p/w500\(path)"
            print(imageUrlString)
            let imageUrl:URL = URL(string: imageUrlString)!
            
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                
                DispatchQueue.main.async {
                    ImageStorage.images[path] = UIImage(data: imageData as Data)
                    
                    print("cache iamge, has now \(ImageStorage.images.count)")
                    if imageView.targetUrl == path {
                        UIView.transition(with: imageView,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            imageView.image = ImageStorage.images[path]
                            },
                                          completion: nil)
                        
                    } else {
                        print("not visible anymore")
                    }
                }
            }
        }
    }
}
