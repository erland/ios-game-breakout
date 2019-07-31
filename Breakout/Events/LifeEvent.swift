//
//  LifeEvent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class LifeEvent : Event {
    let lifeChange : Int
    
    init(entity: GKEntity?, lifeChange: Int) {
        self.lifeChange = lifeChange
        super.init(entity: entity)
    }
}
