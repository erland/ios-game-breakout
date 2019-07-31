//
//  BaseScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class BaseScene : SKScene {
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        print("Loading scene: \(type(of: self))")
        super.sceneDidLoad()
        self.lastUpdateTime = 0
    }
    
    func updateComponents(deltaTime: TimeInterval) {
        for entity in Game.sceneManager(forScene: self).entities {
            entity.update(deltaTime: deltaTime)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        updateComponents(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }

}
