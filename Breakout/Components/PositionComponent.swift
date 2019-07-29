//
//  PositionComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class PositionComponent : BaseComponent {
    var position : CGPoint
    
    init(position : CGPoint) {
        self.position = position
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        if let node = entity?.component(ofType: VisualComponent.self) ?? entity?.component(ofType: GKSKNodeComponent.self){
            node.node.position = position
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let node = entity?.component(ofType: VisualComponent.self) ?? entity?.component(ofType: GKSKNodeComponent.self){
            self.position = node.node.position
        }
    }

}
