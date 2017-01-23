//
//  myView.swift
//  drawing_1
//
//  Created by Experteer on 04/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

enum GameStatus {
    case pause
    case starting
    case playing
}
class PongGame: UIView {
    
    var attached: Bool = false
    var x: CGFloat = 20
    var y: CGFloat = 20
    var vx: CGFloat = 1
    var vy: CGFloat = 1
    var start = DispatchTime.now()
    var circlePath: UIBezierPath = UIBezierPath()
    let size: CGFloat = 20
    
    let paddleWidth: CGFloat = 100
    var playerPos: CGFloat = 20
    var enemyPos: CGFloat = 20
    var distanceFromBorder: CGFloat = 40
    var paddleHeight: CGFloat = 20
    
    var ScorePlayer = 0
    var ScoreEnemy = 0
    var acc: CGFloat = 1.06
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    var Status: GameStatus = .pause
    
    // GameBoardUIView has a delegate property that conforms to the protocol
    // weak to prevent retain cycles
    var delegate:GameBoardUIViewDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        width = rect.width
        height = rect.height
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()!
        let end = DispatchTime.now()   // <<<<<<<<<<   end time
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let msTime = nanoTime / 1000000
        start = end
        //print("update called after \(msTime)ms")
        
        //delegate?.updateUI(view: self)
        x += vx
        y += vy
        
        
        // draw the player
        let rectangle = CGRect(x: playerPos, y: height - distanceFromBorder - paddleHeight, width: paddleWidth, height: paddleHeight)
        ctx.setFillColor(UIColor.white.cgColor)
        
        ctx.setLineWidth(0)
        ctx.addRect(rectangle)
        ctx.drawPath(using: .fillStroke)
        
        // draw the enemy
        let rectangleEnemy = CGRect(x: enemyPos, y: distanceFromBorder, width: paddleWidth, height: paddleHeight)
        ctx.addRect(rectangleEnemy)
        ctx.drawPath(using: .fillStroke)
        
        collision()
        
        
        // draw the ball
        
        circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: size, height: size)))
        
        
        ctx.setLineWidth(0)
        ctx.addPath(circlePath.cgPath)
        ctx.drawPath(using: .fillStroke)
        
        
        if !attached {
            nextBall()
            Status = .playing
            delegate?.updateUI(view: self)
            attached = true
            Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
        
        // move enemy
        var dx = (x + size / 2) - (enemyPos + paddleWidth / 2)
        let sign: CGFloat = (dx > 0 ? 1: -1)
        dx = sqrt(abs(dx))
        enemyPos += dx / 6 * sign
        // print(dx)
        
    }
    
    func collision() {
        if x < 0 || x > width - size {
            vx = -vx * acc
            vy *= acc
        }
        
        
        // collision with player
        if (y + size >= height - paddleHeight - distanceFromBorder) {
            if (x + size > playerPos && x < playerPos + paddleWidth) {
                
                let colPos = (x) - playerPos + size // position on the paddle where to collide
                
                let colRad = colPos / (paddleWidth + size) * CGFloat(M_PI)
                let changeX = -cos(colRad)
                let changeY = -sin(colRad)
                let speed = sqrt(vx * vx + vy * vy)
                
                
                vx = (vx / speed + changeX) * speed / 2 * acc
                vy = (-vy / speed + changeY) * speed / 2 * acc
            } else {
                ScoreEnemy += 1
                delegate?.updateUI(view: self)
                nextBall()
            }
        }
        
        // collision with enemy
        if (y  <= paddleHeight + distanceFromBorder) {
            if (x + size > enemyPos && x < enemyPos + paddleWidth) {
                let colPos = (x) - enemyPos + size // position on the paddle where to collide
                
                let colRad = colPos / (paddleWidth + size) * CGFloat(M_PI)
                let changeX = -cos(colRad)
                let changeY = sin(colRad)
                let speed = sqrt(vx * vx + vy * vy)
                
                
                vx = (vx / speed + changeX) * speed / 2 * acc
                vy = (-vy / speed + changeY) * speed / 2 * acc
            } else {
                ScorePlayer += 1
                delegate?.updateUI(view: self)
                nextBall()
            }
        }
    }
    
    func nextBall() {
        x = (width - size) / 2
        y = (height - size) / 2
        let sign = Double(arc4random_uniform(2)) * 2 - 1
        // angle from 45 to 135 deg
        let angle = Double(arc4random_uniform(90)) + 45.0
        // +- in radians
        let rad = angle * sign / 180.0 * M_PI
        vx = cos(CGFloat(rad)) * 8
        vy = sin(CGFloat(rad)) * 8
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("start touche")
        //print(touches.first.debugDescription)
        let touch = touches.first
        //print(touch?.location(in: self))
        playerPos = (touch?.location(in: self).x)! - paddleWidth / 2
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("move")
        let touch = touches.first
        playerPos = (touch?.location(in: self).x)! - paddleWidth / 2
        
    }
    
    func update() {
        //print("update")
        if (Status == .playing) {
            self.layer.setNeedsDisplay()
            
        }
    }
    
    //[NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    
    
}
