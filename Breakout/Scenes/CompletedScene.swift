//
//  CompletedScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-30.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class CompletedScene: BaseScene {
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addSceneButton {
            Game.stateMachine.enter(PlayingState.self)
        }
        
        print("Scene did load: \(type(of: self))")
    }
    
    override func updateComponents(deltaTime: TimeInterval) {
        // Update components
        Game.entityManager(forScene: self).system(for: TapEventComponent.self).update(deltaTime: deltaTime)
    }
    
}
