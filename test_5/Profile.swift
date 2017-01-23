//
//  Profile.swift
//  test_5
//
//  Created by Experteer on 06/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

class Profile {
    static var name: String = "gues"
    static var coins: Int = 3
    static var likedMovies: [Movie] = []
    
    static func likeToggle(movie: Movie) -> Bool {
        if doesLike(movie: movie).did {
            // unliking movies is "free"
            likedMovies.remove(at: doesLike(movie: movie).idx)
            return true
        } else {
            if coins > 0 {
                coins -= 1
                 likedMovies.append(movie)
                return true
            } else {
                return false
            }
        }
    }
    
    static func doesLike(movie: Movie) -> (did: Bool, idx: Int) {

        for (idx, liked) in likedMovies.enumerated() {
            if liked.id == movie.id {
                return (true, idx)
            }
        }
        return (false, -1)
    }
}
