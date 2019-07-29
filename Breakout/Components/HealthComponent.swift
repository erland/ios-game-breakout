//
//  HealthComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class HealthComponent : BaseComponent {
    var health : Int
    
    init(health: Int) {
        self.health = health
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decreaseHealth() {
        health = health - 1
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if health<=0 {
            Game.stateMachine.enter(GameOverState.self)
        }
    }
}
