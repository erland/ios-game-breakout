//
//  GameCompletedState.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-08-01.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class GameCompletedState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "GameCompletedScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                if sceneController.presentScene(sceneNode) {
                    // Success
                    return
                }
            }
        }
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == TitleState.self
    }
}
