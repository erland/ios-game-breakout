//
//  DamageComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-30.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class KillableComponent : BaseComponent {
    var life = 1
    
    override func update(deltaTime seconds: TimeInterval) {
        if let collisions = entity?.component(ofType: CollisionComponent.self) {
            for collidingEntity in collisions.collisions {
                if collidingEntity.component(ofType: DamagingComponent.self) != nil {
                    life = life - 1
                }
            }
        }

        if life <= 0 {
            sceneManager?.scheduleRemoveEntity(self.entity!)
        }
    }
}
