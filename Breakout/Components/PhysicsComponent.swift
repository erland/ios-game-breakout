//
//  PhysicsComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-28.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class PhysicsComponent : BaseComponent {
    let physicsBody : SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    convenience init(physicsBody: SKPhysicsBody,
                     isDynamic: Bool,
                     collisionBitMask: UInt32,
                     categoryBitMask: UInt32,
                     contactTestBitMask: UInt32) {
        self.init(physicsBody: physicsBody)
        physicsBody.isDynamic = isDynamic
        physicsBody.collisionBitMask = collisionBitMask
        physicsBody.categoryBitMask = categoryBitMask
        physicsBody.contactTestBitMask = contactTestBitMask
        
        physicsBody.affectedByGravity = false
        physicsBody.friction = 0.0
        physicsBody.restitution = 1.0
        physicsBody.linearDamping = 0.0
        physicsBody.angularDamping = 0.0
        physicsBody.mass = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        if let node = entity?.component(ofType: VisualComponent.self) ?? entity?.component(ofType: GKSKNodeComponent.self){
            node.node.physicsBody = physicsBody
        }
    }
    
    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()
        if let node = entity?.component(ofType: VisualComponent.self) ?? entity?.component(ofType: GKSKNodeComponent.self) {
            node.node.physicsBody = nil
        }
    }
}
