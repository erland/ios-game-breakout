//
//  FollowComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-31.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class FollowNodeComponent : BaseComponent {
    let offset : CGPoint
    let followNode : SKNode
    
    init(node: SKNode, offset : CGPoint) {
        self.followNode = node
        self.offset = offset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let node = entity?.component(ofType: VisualComponent.self) ?? entity?.component(ofType: GKSKNodeComponent.self){
            node.node.position.x = followNode.position.x + offset.x
            node.node.position.y = followNode.position.y + offset.y
        }
    }
    
}
