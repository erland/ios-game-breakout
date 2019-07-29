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
        }
    }
}
