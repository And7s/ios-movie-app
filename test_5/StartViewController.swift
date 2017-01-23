//
//  StartViewController.swift
//  test_5
//
//  Created by Experteer on 06/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var imagePaths = ["movieBG.jpg", "bg2.jpg", "bg3.jpg"]
    var curIdx = 0
    
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var myImageBG: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(StartViewController.changeImages), userInfo: nil, repeats: true)
        
        
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.1
        pulseAnimation.fromValue = NSNumber(value: 0.9)
        pulseAnimation.toValue = NSNumber(value: 1.0)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        logo.layer.add(pulseAnimation, forKey: nil)
        
        
    }
    
      
    func changeImages() {
        curIdx = (curIdx + 1) % imagePaths.count
        
        let toImage = UIImage(named: imagePaths[curIdx])
        UIView.transition(with: self.myImageBG,
                          duration: 1.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.myImageBG.image = toImage
            },
                          completion: nil)
        
        
    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
