//
//  ScoreEvent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class ScoreEvent : Event {
    let score : Int
    
    init(entity: GKEntity?, score: Int) {
        self.score = score
        super.init(entity: entity)
    }
}
