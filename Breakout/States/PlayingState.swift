//
//  PlayingState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class PlayingState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = sceneController.currentScene() as? PlayingScene {
            scene.startBall()
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PauseState.self || stateClass == GameOverState.self || stateClass == TitleState.self  || stateClass == LevelCompletedState.self || stateClass == PlaceBallState.self
    }
}
