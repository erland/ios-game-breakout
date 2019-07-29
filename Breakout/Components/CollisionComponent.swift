//
//  CollisionComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class CollisionComponent : BaseComponent {
    var collisions : [GKEntity] = []
    
    
    func addCollision(with entity: GKEntity?) {
        guard let entity = entity else {
            return
        }
        
        collisions.append(entity)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        collisions.removeAll()
    }
}
