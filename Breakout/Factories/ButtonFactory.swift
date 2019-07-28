//
//  ButtonFactory.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit
import SpriteKit

class ButtonFactory {
    let scene : SKScene
    init(_ scene: SKScene) {
        self.scene = scene
    }
    
    func addButton(withName name: String, _ handler: @escaping () -> ()) {
        if let node = scene.childNode(withName: name) {
            let entity = GKEntity()
            entity.addComponent(GKSKNodeComponent(node: node))
            entity.addComponent(TapEventComponent(handler: handler))
            Game.entityManager(forScene: scene).addEntity(entity)
        }
    }

    func addSceneButton(_ handler: @escaping () -> ()) {
        let entity = GKEntity()
        entity.addComponent(GKSKNodeComponent(node: scene))
        entity.addComponent(TapEventComponent(handler: handler))
        Game.entityManager(forScene: scene).addEntity(entity)
    }
}
