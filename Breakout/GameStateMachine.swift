//
//  GameController.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class GameStateMachine : GKStateMachine {

    init(sceneController: SceneController) {
        super.init(states: [TitleState(sceneController: sceneController),
                            LaunchGameState(sceneController: sceneController),
                            LoadLevelState(sceneController: sceneController),
                            PlaceBallState(sceneController: sceneController),
                            PlayingState(sceneController: sceneController),
                            PauseState(sceneController: sceneController),
                            CompletedState(sceneController: sceneController),
                            GameOverState(sceneController: sceneController)])
    }
    
    func isPaused() -> Bool {
        return currentState!.isKind(of: PauseState.self)
    }
    
    func start() {
        enter(TitleState.self)
    }
}
