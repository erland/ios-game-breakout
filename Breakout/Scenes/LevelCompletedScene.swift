//
//  CompletedScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-30.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelCompletedScene: BaseScene {
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addSceneButton {
            Game.stateMachine.enter(LoadLevelState.self)
        }
        
        print("Scene did load: \(type(of: self))")
    }
    
    override func updateComponents(deltaTime: TimeInterval) {
        // Update components
        Game.sceneManager(forScene: self).system(for: TapEventComponent.self).update(deltaTime: deltaTime)
    }
    
}
