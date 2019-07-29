//
//  BaseComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class BaseComponent : GKComponent {
    override func didAddToEntity() {
        if let system = Game.system(for: type(of: self)) {
            system.addComponent(self)
        }
    }
    
    override func willRemoveFromEntity() {
        if let system = Game.system(for: type(of: self)) {
            system.removeComponent(self)
        }
    }
}
