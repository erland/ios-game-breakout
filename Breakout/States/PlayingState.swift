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
        if !previousState!.isKind(of: PauseState.self) {
            if let scene = GKScene(fileNamed: "PlayingScene") {
                
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! SKScene? {
                    if sceneController.presentScene(sceneNode) {
                        // Success
                        return
                    }
                }
            }
        }else {
            // Success
            return
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PauseState.self || stateClass == GameOverState.self || stateClass == TitleState.self
    }
}
