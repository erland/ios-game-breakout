//
//  Game.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Game {
    static var sceneController : SceneController!
    static var stateMachine: GameStateMachine!
    static var entityManagers: [SKScene:EntityManager] = [:]
    
    init(sceneController: SceneController) {
        Game.stateMachine = GameStateMachine(sceneController: sceneController)
        Game.sceneController = sceneController
    }
    
    static func entityManager(forScene scene: SKScene) -> EntityManager {
        if let entityManager = entityManagers[scene] {
            return entityManager
        }else {
            entityManagers[scene] = EntityManager()
            return entityManagers[scene]!
        }
    }
    
}
