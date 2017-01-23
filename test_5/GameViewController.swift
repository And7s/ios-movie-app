//
//  GameViewController.swift
//  test_5
//
//  Created by Experteer on 04/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

// Delegate protocol declared here
// @class_protocol means it can only be adopted by Class types
protocol GameBoardUIViewDelegate {
    func updateUI(view: PongGame)
}

class GameViewController: UIViewController, GameBoardUIViewDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drawingView: PongGame!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawingView.delegate = self
    }
    
    @IBAction func pauseToggle(_ sender: AnyObject) {
        print("TOGGLE")
        if (drawingView.Status == .pause) {
            drawingView.Status = .playing
            pauseButton.setTitle("pause", for: .normal)
            
        } else {
            drawingView.Status = .pause
            pauseButton.setTitle("continue", for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegte protocol method
    func updateUI(view: PongGame) {
        print("GOT message")
        
        scoreLabel.text = "Player: \(view.ScorePlayer) - Enemy: \(view.ScoreEnemy)"
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        drawingView.Status = .pause
        Profile.coins += drawingView.ScorePlayer - drawingView.ScoreEnemy
        self.dismiss(animated: true, completion: nil)
    }
}
