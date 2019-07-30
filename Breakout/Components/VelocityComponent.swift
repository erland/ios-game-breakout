//
//  VelocityComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class VelocityComponent : BaseComponent {
    var velocity : CGVector
    
    init(velocity : CGVector) {
        self.velocity = velocity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        if let component = entity?.component(ofType: PhysicsComponent.self) {
            component.physicsBody.applyImpulse(velocity)
        }
    }
    override func update(deltaTime seconds: TimeInterval) {
        if let component = entity?.component(ofType: PhysicsComponent.self) {
            velocity = component.physicsBody.velocity
            if abs(velocity.dx) <= 100.0 {
                let newVelocity = Bool.random() ? 100-abs(velocity.dx) : -(100-abs(velocity.dx))
                component.physicsBody.applyImpulse(CGVector(dx: newVelocity,dy: 0))
            }
            if abs(velocity.dy) <= 100.0 {
                let newVelocity = Bool.random() ? 100-abs(velocity.dy) : -(100-abs(velocity.dy))
                component.physicsBody.applyImpulse(CGVector(dx: 0,dy: newVelocity))
            }
            if sqrt(velocity.dx*velocity.dx+velocity.dy*velocity.dy) > 400 {
                component.physicsBody.linearDamping = 0.4
            }else {
                component.physicsBody.linearDamping = 0.0
            }
            while sqrt(velocity.dx*velocity.dx+velocity.dy*velocity.dy) < 100 {
                component.physicsBody.applyImpulse(velocity)
            }
        }
    }
}
