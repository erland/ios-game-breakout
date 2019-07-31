//
//  Entity.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-30.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class Entity : GKEntity {
    var managedBy: SceneManager
    
    init(managedBy: SceneManager) {
        self.managedBy = managedBy
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addComponent(_ component: GKComponent) {
        super.addComponent(component)
        managedBy.addComponentToSystems(component)
        if let component = component as? BaseComponent {
            component.sceneManager = managedBy
        }
    }
    
    override func __removeComponent(for componentClass: AnyClass) {
        if let componentClass = componentClass as? GKComponent.Type {
            managedBy.removeComponentFromSystems(for: componentClass, in: self)
        }
        super.__removeComponent(for: componentClass)
    }
}
