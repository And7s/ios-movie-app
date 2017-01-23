//
//  ListViewController.swift
//  test_5
//
//  Created by Experteer on 31/12/16.
//  Copyright © 2016 Experteer. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieImage: MyImageView!
    
    @IBOutlet weak var hearBtn: UIButton!
    
    var doLikeMovie: Bool = false
    var movie: Movie?
    
    func update(movie: Movie) {
        self.movie = movie
        doLikeMovie = Profile.doesLike(movie: movie).did
        movieLabel.text = movie.original_title
        movieDescription.text = movie.overview
        ImageStorage.loadImage(path: movie.poster_path, imageView: movieImage)
        
        if doLikeMovie {
            hearBtn.backgroundColor = UIColor.gray
        } else {
            hearBtn.backgroundColor = UIColor.clear
        }

    }
    
    @IBAction func likeMovie(_ sender: AnyObject) {
        if Profile.likeToggle(movie: movie!) {
            doLikeMovie = !doLikeMovie
            if doLikeMovie {
                hearBtn.backgroundColor = UIColor.gray
            } else {
                hearBtn.backgroundColor = UIColor.clear
            }
        } else {
            let alert = UIAlertController(title: "out of coins", message: "You are out of coins. Earn more coins to pay for liking.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "mmh, ok?", style: UIAlertActionStyle.default, handler: nil))
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)

                // topController should now be your topmost view controller
            }
            
            
        }
       
        
    }
}


protocol UpdateSearchCriteriaDelegate {
    func updateCriteria()
}


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UpdateSearchCriteriaDelegate {
    var movies: [Movie] = []

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchInformation: UILabel!
    let transition = CircularTransition()
    @IBOutlet weak var adjustSearchButton: UIButton!
    var selectedMovieIdx: Int = 0
    
    
    
    func updateCriteria() {
        print("UPDATE CRITERA")
        
        //let url = "https://api.themoviedb.org/3/discover/movie?api_key=1330998b6dd7abe870663439a94c8816&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
        
        let url = "https://api.themoviedb.org/3/search/movie?api_key=1330998b6dd7abe870663439a94c8816&query=\(SearchCriteria.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        print("query URL: \(url)")
        
        Http.request(url: url, callback: {(data: Any) -> Void in
            print("was called list")
            self.movies = []
            if var obj = data as? [String: Any] {  // convert to object
                let err = obj["errors"] as? [String]
                if (err != nil) {
                    print("Request returned an error")
                    return;
                }
                let arr = obj["results"] as? [[String: Any]]    // get results array
                
                for object in arr! {
                    /*for (key, value) in object  {
                     print("\(key) - \(value) ")
                     }*/
                    let movie: Movie = Movie(object: object)
                    self.movies.append(movie)
                }
            }
            print("have now")
            print(self.movies.count)
            self.listTableView.reloadData()
        })
        searchInformation.text = "search for \(SearchCriteria.searchTerm)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        updateCriteria()
        
        let alert = UIAlertController(title: "Out of coins", message: "You are out of coins. Earn more coins to pay for liking.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "mmh, ok?", style: UIAlertActionStyle.default, handler: nil))
        
        
        //  present(alert, animated: true, completion: nil)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue ")
        print(segue.identifier)
        if segue.identifier == "changeSearch" {
            let listCtrl = segue.destination as! BlurVC
            listCtrl.delegate = self
            listCtrl.modalPresentationStyle = .overCurrentContext
            self.present(listCtrl, animated: true, completion: nil)
        } else if segue.identifier == "movieDetail" {
            let movieDetail = segue.destination as! MovieDetailViewController
            movieDetail.movie = movies[selectedMovieIdx]
        }
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieListTableCell", for: indexPath) as? MovieCell else {
            fatalError("The dequeued cell is not an instance of MovieCell.")
        }
        cell.movieLabel.text = "asd"
        cell.update(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        print(indexPath.row)
        selectedMovieIdx = indexPath.row
        performSegue(withIdentifier: "movieDetail", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
