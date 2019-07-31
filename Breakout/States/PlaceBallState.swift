//
//  PlaceBallState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class PlaceBallState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = sceneController.currentScene() as? PlayingScene {
            scene.placeBall()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayingState.self || stateClass == TitleState.self
    }
}
