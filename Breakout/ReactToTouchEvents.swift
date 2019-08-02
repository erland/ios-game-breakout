//
//  ReactToTouchEvents.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-08-02.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

protocol ReactToTouchEvents {
    func touchUpdate(x: Float, y: Float) -> Void
}
