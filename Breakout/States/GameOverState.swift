//
//  GameOverState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class GameOverState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "GameOverScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                if sceneController.setOverlayScene(sceneNode) {
                    // Success
                    return
                }
            }
        }
    }
    override func willExit(to nextState: GKState) {
        _ = sceneController.clearOverlayScene()
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == TitleState.self
    }
}
