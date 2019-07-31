//
//  Event.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class Event {
    var entity: GKEntity?
    
    init(entity: GKEntity?) {
        self.entity = entity
    }
}
