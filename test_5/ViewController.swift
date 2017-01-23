//
//  ViewController.swift
//  test_5
//
//  Created by Experteer on 29/12/16.
//  Copyright © 2016 Experteer. All rights reserved.
//

import UIKit



class MovieTileCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: MyImageView!
    @IBOutlet weak var movieLabel: UILabel!
    func update(movie: Movie) {
        movieLabel.text = movie.original_title
        movieLabel.lineBreakMode = .byWordWrapping
        movieLabel.numberOfLines = 2

        ImageStorage.loadImage(path: movie.poster_path, imageView: movieImage)
    }
}

class MyImageView: UIImageView {
    var targetUrl: String = ""
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var freeTextInput: UITextField!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var revenueMovieCollection: UICollectionView!
    @IBOutlet weak var germanMovieCollection: UICollectionView!
    
    @IBOutlet weak var myLikedMoviesCollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blurOverlay: UIVisualEffectView!
    
    var overlay: UIVisualEffectView? = nil
    var popular_movies: [Movie] = []
    var revenue_movies: [Movie] = []
    var german_movies: [Movie] = []
    var selectedMovie: Movie?

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
         welcomeLabel.text = "Welcome \(Profile.name), you have \(Profile.coins) coins"
        myLikedMoviesCollection.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        welcomeLabel.text = "Welcome \(Profile.name), you have \(Profile.coins)  coins asd"
        freeTextInput.text = SearchCriteria.searchTerm

        // Do any additional setup after loading the view, typically from a nib.
        print("did load")
        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=1330998b6dd7abe870663439a94c8816&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
        Http.request(url: url, callback: {(data: Any) -> Void in
            print("was called list")
            if var obj = data as? [String: Any] {  // convert to object
                let arr = obj["results"] as? [[String: Any]]    // get results array
                
                for object in arr! {
                    /*for (key, value) in object  {
                        print("\(key) - \(value) ")
                    }*/
                    let movie: Movie = Movie(object: object)
                    self.popular_movies.append(movie)
                }
            }
            print("have now")
            print(self.popular_movies.count)
            self.movieCollectionView.reloadData()
        })
        
        let revenue_url = "https://api.themoviedb.org/3/discover/movie?api_key=1330998b6dd7abe870663439a94c8816&language=en-US&sort_by=revenue.desc&include_adult=false&include_video=false&page=1"
        Http.request(url: revenue_url, callback: {(data: Any) -> Void in
            print("was called list")
            if var obj = data as? [String: Any] {  // convert to object
                let arr = obj["results"] as? [[String: Any]]    // get results array
                
                for object in arr! {
                    let movie: Movie = Movie(object: object)
                    self.revenue_movies.append(movie)
                }
            }
            print("have now")
            print(self.revenue_movies.count)
            self.revenueMovieCollection.reloadData()
        })
        
        let german_url = "https://api.themoviedb.org/3/discover/movie?api_key=1330998b6dd7abe870663439a94c8816&language=en-US&region=DE&sort_by=revenue.desc&include_adult=false&include_video=false&page=1&year=2015"
        Http.request(url: german_url, callback: {(data: Any) -> Void in
            print("was called list")
            if var obj = data as? [String: Any] {  // convert to object
                let arr = obj["results"] as? [[String: Any]]    // get results array
                
                for object in arr! {
                    let movie: Movie = Movie(object: object)
                    self.german_movies.append(movie)
                }
            }
            print("have now")
            print(self.german_movies.count)
            self.germanMovieCollection.reloadData()
        })
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("was called collection view")
        print(collectionView.tag)
        if collectionView.tag == 0 {
            return min(popular_movies.count, 5)
        } else if collectionView.tag == 1 {
            return min(revenue_movies.count, 5)
        } else if collectionView.tag == 2 {
            return min(german_movies.count, 5)
        } else {
            return min(Profile.likedMovies.count, 5)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select")
        print(indexPath.row)
        
        if collectionView.tag == 0 {
            selectedMovie = popular_movies[indexPath.row]
        } else if collectionView.tag == 1 {
            selectedMovie = revenue_movies[indexPath.row]
        } else if collectionView.tag == 2 {
            selectedMovie = german_movies[indexPath.row]
        } else {
            selectedMovie = Profile.likedMovies[indexPath.row]
        }
        performSegue(withIdentifier: "movieDetail", sender: self)
    }
    
    @IBAction func startEdit(_ sender: AnyObject) {
        print("edit")
        //scrollView.isScrollEnabled = false
        /*overlay = UIVisualEffectView(frame: CGRect(x: 0, y:  100, width: self.view.frame.size.width, height: 200)
        )

        //overlay.effect = UIBlurEffect(style: .light)
        UIView.animate(withDuration: 0.5) {
            self.overlay?.effect = UIBlurEffect(style: .light)
        }
        self.view.addSubview(overlay!)*/
            }
    
    
    @IBAction func searchClicked(_ sender: AnyObject) {
        /*let blurTVC = BlurVC()
        
        blurTVC.modalPresentationStyle = .overCurrentContext
        self.present(blurTVC, animated: true, completion: nil)
        
        // search url
        // https://api.themoviedb.org/3/search/movie?api_key=1330998b6dd7abe870663439a94c8816&query=the+dark+
 */

    }
    @IBAction func primaryAction(_ sender: AnyObject) {
        print("primary action")
        freeTextInput.resignFirstResponder()
        //scrollView.isScrollEnabled = true
      //  overlay?.removeFromSuperview()
    }
    @IBAction func valueChanged(_ sender: AnyObject) {
       print("val changed")
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieTileCell", for: indexPath as IndexPath) as? MovieTileCell
       // ImageStorage.instance.loadImage(path: posterUrls[indexPath.row], imageView: (cell?.posterImage)!)
        if collectionView.tag == 0 {
            cell?.update(movie: popular_movies[indexPath.row])
        } else if collectionView.tag == 1 {
            cell?.update(movie: revenue_movies[indexPath.row])

        } else if collectionView.tag == 2 {
            cell?.update(movie: german_movies[indexPath.row])
            
        } else {
            cell?.update(movie: Profile.likedMovies[indexPath.row])
        }
        print("generate a cell")
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListSearch" {
            //let listCtrl = segue.destination as! ListViewController
            SearchCriteria.searchTerm = freeTextInput.text!
        } else if segue.identifier == "movieDetail" {
            let detailCtrl = segue.destination as! MovieDetailViewController
            detailCtrl.movie = selectedMovie
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        print(itemWidth)
        print(itemHeight)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

