//
//  LoadLevelState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class LoadLevelState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = sceneController.currentScene() as? PlayingScene {
            scene.loadLevel()
            stateMachine?.enter(PlaceBallState.self)
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlaceBallState.self
    }
}

