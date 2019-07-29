//
//  VisualComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class VisualComponent: GKSKNodeComponent {
    override func didAddToEntity() {
        if let physics = entity?.component(ofType: PhysicsComponent.self) {
            node.physicsBody = physics.physicsBody
        }
    }
    
    override func willRemoveFromEntity() {
        node.removeFromParent()
    }
}
