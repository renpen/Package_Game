//
//  Truck.swift
//  Cargonator
//
//  Created by Bosshammer, Benedikt on 07.03.18.
//  Copyright © 2018 Cargonator Inc. All rights reserved.
//

import UIKit
import SpriteKit

class Truck: SKSpriteNode {
    var origin_position = CGPoint()
    
    var driveDirection: String?
    
    // variables for detecting swipe
    private let minimum_detect_distance: CGFloat = 5
    private var moveAmtX: CGFloat = 0
    private var moveAmtY: CGFloat = 0
    private var initialTouch: CGPoint = CGPoint.zero
    private var initialPosition: CGPoint = CGPoint.zero
    
    var acceptance = ""
    
    func checkAcceptance () -> Bool {
        return true
    }
    
    // - MARK: Swipe Detection
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch! {
            
            if (touch.tapCount > 1) {
                print("Double Tap")
            } else { // swipe
                
                initialTouch = touch.location(in: self.scene!.view)
                moveAmtY = 0
                moveAmtX = 0
                initialPosition = self.position
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch! {
            
            let movingPoint: CGPoint = touch.location(in: self.scene!.view)
            
            moveAmtX = movingPoint.x - initialTouch.x
            //moveAmtY = movingPoint.y - initialTouch.y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var swipeDirection = ""
        if (moveAmtX != 0){
            if fabs(moveAmtX) > minimum_detect_distance {
                
                //must be moving side to side
                if moveAmtX < 0 {
                    swipeDirection = "left"
                }
                else {
                    swipeDirection = "right"
                }
                
            }
            
            if (swipeDirection == driveDirection) {
                moveOut()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.driveOutSpeed)) {
                self.moveBack()
            }
            
            //moveAmtY = 0
            moveAmtX = 0
        } else {
            // double tap
        }
        
        
    }
    
    var driveOutSpeed = 3
    var driveInSpeed = 5
    
    func moveOut() {
        let position = self.position
        
        self.origin_position = position
        
        var moveOutAction = SKAction()
        
        if (self.driveDirection == "right") {
            moveOutAction = SKAction.move(to: CGPoint(x: (position.x) + ((size.width) * 1.5),y: (position.y)), duration: TimeInterval(self.driveOutSpeed))
        } else if (self.driveDirection == "left") {
            moveOutAction = SKAction.move(to: CGPoint(x: (position.x) - ((size.width) * 1.5),y: (position.y)), duration: TimeInterval(self.driveOutSpeed))
        }
        
        self.run(moveOutAction)
        
        self.isUserInteractionEnabled = false
    }
    
    func moveBack () {
        let moveInAction = SKAction.move(to: CGPoint(x: (self.origin_position.x),y: (self.origin_position.y)), duration: TimeInterval(self.driveInSpeed))
        
        self.run(moveInAction)
        
        self.isUserInteractionEnabled = true
        
        // update truck acceptance here
    }
    
}