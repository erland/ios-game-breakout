//
//  CompletedState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-30.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class LevelCompletedState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "LevelCompletedScene") {
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
        return stateClass == LoadLevelState.self
    }
}
