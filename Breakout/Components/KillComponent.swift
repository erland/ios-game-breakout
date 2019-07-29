//
//  KillComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-28.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class KillComponent : BaseComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
        if let collisions = entity?.component(ofType: CollisionComponent.self) {
            for collidingEntity in collisions.collisions {
                if let healthComponent = collidingEntity.component(ofType: HealthComponent.self) {
                    healthComponent.decreaseHealth()
                }
            }
        }
    }
}
