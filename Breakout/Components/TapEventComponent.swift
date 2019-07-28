//
//  TapEventComponent.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class TapEventComponent : GKComponent {
    var tapped: Bool = false
    var handler: () -> ()
    
    init(handler: @escaping () -> ()) {
        self.handler = handler
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if tapped {
            handler()
        }
        tapped = false
    }
}
