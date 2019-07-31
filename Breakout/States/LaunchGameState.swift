//
//  LaunchGame.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class LaunchGameState : GKState {
    let sceneController: SceneController
    
    init(sceneController: SceneController) {
        self.sceneController = sceneController
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "PlayingScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                if sceneController.presentScene(sceneNode) {
                    stateMachine?.enter(LoadLevelState.self)
                    return
                }
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == LoadLevelState.self
    }
}
