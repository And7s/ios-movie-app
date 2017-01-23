//
//  Movie.swift
//  test_5
//
//  Created by Experteer on 02/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

class Movie {
    var id: Int = 0
    var original_title: String = ""
    var release_date: String = ""
    var overview: String = ""
    var poster_path: String = ""
    var backdrop_path: String = ""
    var vote_count: Int = 0
    var vote_average: Double = 0
    var popularity: Double = 0
    var original_language: String = ""
    var genre_ids: [Int] = []
    
    init(object: [String: Any]) {
        original_title = (object["original_title"] as? String)!
        id = (object["id"] as? Int)!
        release_date = (object["release_date"] as? String)!
        overview = (object["overview"] as? String)!
        if let val = object["backdrop_path"] as? String {
            backdrop_path =  val
        } else {
            backdrop_path = ""
        }
        if let val = object["poster_path"] as? String {
            poster_path = val
        } else {
            poster_path = ""
        }
        
        
        vote_count = (object["vote_count"] as? Int)!
        vote_average = (object["vote_average"] as? Double)!
        popularity = (object["popularity"] as? Double)!
        original_language = (object["original_language"] as? String)!
        for ids in (object["genre_ids"] as? [Int])! {
            genre_ids.append(ids)
        }
    }
}
