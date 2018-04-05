//
//  GameViewController.swift
//  Cargonator
//
//  Created by Bosshammer, Benedikt on 23.02.18.
//  Copyright © 2018 Cargonator Inc. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import TwitterKit

class GameViewController: UIViewController, NavigationDelegate, SocialDelegate {
    
    // - MARK: Navigation Delegate
    
    func gameOver() {
        GameAnalytics.addProgressionEvent(with: GAProgressionStatusComplete, progression01: "openEnd", progression02: "Difficulty " + String(SettingService.shared.difficulty.rawValue), progression03: nil)
        initEndScore()
    }
    
    func enterMenu() {
        initMenuScene()
    }
    
    func gameEnded() {
        GameAnalytics.addProgressionEvent(with: GAProgressionStatusFail, progression01: "openEnd", progression02: "Difficulty " + String(SettingService.shared.difficulty.rawValue), progression03: nil)
        initMenuScene()
    }
    
    func enterSettings() {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        settingsViewController.navigationDelegate = self
        self.present(settingsViewController, animated: false, completion: nil)
    }
    
    func startGame() {
        GameAnalytics.addProgressionEvent(with: GAProgressionStatusStart, progression01: "openEnd", progression02: "Difficulty " + String(SettingService.shared.difficulty.rawValue), progression03: nil)
        initPlayScene()
    }
    
    // - MARK: Social Delegate
    
    func tweetScore() {
        if (TWTRTwitter.sharedInstance().sessionStore.session() != nil) {
            let composer = TWTRComposer()
            
            let text = "I just scored " + String(GameState.sharedInstance.getScore()) + " points in Cargonator. Join me at cargonator.wordpress.com"
            
            composer.setText(text)
            
            composer.show(from: self, completion: { (result) in
                GameAnalytics.addDesignEvent(withEventId: "result-tweet", value: NSNumber(integerLiteral: GameState.sharedInstance.getScore()))
            })
        } else {
            print("Not logged in")
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameState.sharedInstance.gameViewController = self
        initMenuScene()
    }
    
    func initPlayScene () {
        let scene = PlayScene(fileNamed: "PlayScene")
        scene?.scaleMode = .aspectFill
        scene?.playSceneDelegate = self
        
        if let view = self.view as! SKView? {
            let transition = SKTransition.fade(withDuration: 1)
            transition.pausesOutgoingScene = false
            
            view.presentScene(scene!, transition: transition)
            view.ignoresSiblingOrder = true
            
            /*view.showsFPS = true
             view.showsNodeCount = true */
        }
    }
    
    func initEndScore () {
        let scene = EndScoreScene(fileNamed: "EndScoreScene")
        scene?.scaleMode = .aspectFill
        scene?.gameViewControllerDelegate = self
        scene?.socialDelegate = self
        
        if let view = self.view as! SKView? {
            let transition = SKTransition.fade(withDuration: 1)
            transition.pausesOutgoingScene = false
            
            view.presentScene(scene!, transition: transition)
            view.ignoresSiblingOrder = true
            
            /*view.showsFPS = true
             view.showsNodeCount = true */
        }
    }
    
    func initMenuScene () {
        let scene = MenuScene(fileNamed: "MenuScene")
        scene?.scaleMode = .aspectFill
        scene?.menuSceneDelegate = self
        
        if let view = self.view as! SKView? {
            let transition = SKTransition.fade(withDuration: 1)
            transition.pausesOutgoingScene = false
            
            view.presentScene(scene!, transition: transition)
            
            view.ignoresSiblingOrder = true
            
            /*view.showsFPS = true
             view.showsNodeCount = true */
        }
    }
}
