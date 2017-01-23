//
//  MovieDetailViewController.swift
//  test_5
//
//  Created by Experteer on 02/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: MyImageView!

}

class MovieDetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var movie: Movie?

    @IBOutlet weak var backdropImageView: MyImageView!

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var posterCollectionView: UICollectionView!
    
    var posterUrls: [String] = []
    var fullScreenImage: MyImageView = MyImageView()
    
    var movieLike: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        movieLike = Profile.doesLike(movie: movie!).did
        let mov: Movie = movie!
        ImageStorage.loadImage(path: mov.backdrop_path, imageView: backdropImageView)
        likeBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        releaseDate.text = mov.release_date
        voteCount.text = "\(mov.vote_average) / 10.0, \(mov.vote_count) votes"
        popularity.text = "popularity: \(mov.popularity)"
        descriptionLabel.text = mov.overview
        self.title = movie?.original_title
        renderLike()
        
        let url = "https://api.themoviedb.org/3/movie/\(movie!.id)/images?api_key=1330998b6dd7abe870663439a94c8816&language=en-US&include_image_language=en,null"
        
        Http.request(url: url, callback: {(data: Any) -> Void in
            print("was called list")
            
            if var obj = data as? [String: Any] {  // convert to object
                
                let arr = obj["posters"] as? [[String: Any]]    // get results array
                
                for object in arr! {
                    /*for (key, value) in object  {
                     print("\(key) - \(value) ")
                     }*/
                    self.posterUrls.append((object["file_path"] as? String)!)
                }
            }
            print(self.posterUrls)
            // self.tableView.reloadData()
            self.posterCollectionView.reloadData()
        })
    }

    func renderLike() {
        if movieLike {
            likeBtn.backgroundColor = UIColor.gray
            likeBtn.setTitle("you like, unlike?", for: .normal)
        } else {
            likeBtn.backgroundColor = UIColor.clear
            likeBtn.setTitle("add to likes", for: .normal)
        }
    }
    
    @IBAction func likeMovie(_ sender: AnyObject) {
        if Profile.likeToggle(movie: movie!) {
            movieLike = !movieLike
            renderLike()
        } else {
            let alert = UIAlertController(title: "out of coins", message: "You are out of coins. Earn more coins to pay for liking.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "mmh, ok?", style: UIAlertActionStyle.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
                
                // topController should now beyour topmost view controller
            

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("did scroll")
        
        /*let offset = (scrollView.contentOffset.y + 65) * 0.002
        print(offset)
        let rect = CGRect(x: 0.0, y:-offset, width: 1, height: 1)
       
        backdropImageView.layer.contentsRect = rect*/
    }
    
    
    // Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("was called collection view")
        return posterUrls.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select")
        print(indexPath.row)
        
        //let imageView = sender.view as! UIImageView
        fullScreenImage = MyImageView(image: nil)
        
        fullScreenImage.frame = self.view.frame
        fullScreenImage.backgroundColor = .black
        fullScreenImage.contentMode = .scaleAspectFit
        fullScreenImage.isUserInteractionEnabled = true
        
        ImageStorage.loadImage(path: posterUrls[indexPath.row], imageView: fullScreenImage)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        fullScreenImage.addGestureRecognizer(tap)
        self.view.addSubview(fullScreenImage)
        
    }
    
    func dismissFullScreenImage() {
        print("remove fullscreenImage")
        fullScreenImage.removeFromSuperview()
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterView", for: indexPath as IndexPath) as? PosterCell
        ImageStorage.loadImage(path: posterUrls[indexPath.row], imageView: (cell?.posterImage)!)
        
        print("generate a cell")
        return cell!
    }
    
   /* func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        print(itemWidth)
        print(itemHeight)
        return CGSize(width: itemWidth, height: itemHeight)
    }*/


}
