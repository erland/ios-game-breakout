//
//  GameOverScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-28.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: BaseScene {
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addSceneButton {
            Game.stateMachine.enter(TitleState.self)
        }
        
        print("Scene did load: \(type(of: self))")
    }

    override func updateComponents(deltaTime: TimeInterval) {
        // Update components
        Game.system(for: TapEventComponent.self)?.update(deltaTime: deltaTime)
    }

}
