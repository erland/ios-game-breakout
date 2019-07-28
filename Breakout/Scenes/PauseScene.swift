//
//  PauseScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class PauseScene: BaseScene {
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addSceneButton {
            Game.stateMachine.enter(PlayingState.self)
        }

        print("Scene did load: \(type(of: self))")
    }
    
}
