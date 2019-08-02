//
//  ReactToMotionEvents.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-08-02.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameController

protocol ReactToMotionEvents {
    func motionUpdate(_ motion: GCMotion) -> Void
}


