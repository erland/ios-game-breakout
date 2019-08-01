//
//  HudDisplay.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class HudDisplay {
    let sceneManager : SceneManager
    let scoreLabel : SKLabelNode?
    var score : Int = 0
    let livesLabel : SKLabelNode?
    var lives : Int = 0
    let levelLabel : SKLabelNode?
    var level : Int = 0
    
    init(sceneManager: SceneManager, score: Int, lives: Int, level: Int, scoreLabel: SKLabelNode?, livesLabel: SKLabelNode?, levelLabel: SKLabelNode?) {
        self.sceneManager = sceneManager
        self.scoreLabel = scoreLabel
        self.livesLabel = livesLabel
        self.levelLabel = levelLabel
        self.score = score
        self.lives = lives
        self.level = level
    }
    
    func update(deltaTime: TimeInterval) {
        for scoreEvent in sceneManager.events(ofType: ScoreEvent.self) {
            score = score + scoreEvent.score
        }
        for lifeEvent in sceneManager.events(ofType: LifeEvent.self) {
            lives = lives + lifeEvent.lifeChange
        }
        scoreLabel?.text = "\(score)"
        livesLabel?.text = "\(lives)"
        levelLabel?.text = "\(level)"
    }
}
