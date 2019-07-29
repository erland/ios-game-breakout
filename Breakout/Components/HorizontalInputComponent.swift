//
//  HorizontalInputComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-28.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class HorizontalInputComponent : BaseComponent {
    @GKInspectable
    var dragAreaWidth : CGFloat = 0

    @GKInspectable
    var dragAreaHeight : CGFloat = 0
    
    var dragOffset : CGFloat?
    var dragPosition: CGFloat?
    
    override func update(deltaTime seconds: TimeInterval) {
        if let position = dragPosition {
            if let nodeComponent = entity?.component(ofType: VisualComponent.self) {
                nodeComponent.node.position.x = position
            }
        }
    }
}
