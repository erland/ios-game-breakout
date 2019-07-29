//
//  EntityManager.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class EntityManager {
    var entities : [GKEntity] = []
    
    func addEntity(_ entity: GKEntity) {
        entities.append(entity)
    }
    
    func removeEntity(_ entity: GKEntity) {
        if let index = entities.index(of:entity) {
            entities.remove(at: index)
            for component in entity.components {
                entity.removeComponent(ofType: type(of: component))
            }
        }
    }
    
    func component<T : GKComponent>(forNode node: SKNode?, ofType: T.Type) -> T? {
        guard let node = node else {
            return nil
        }
        for entity in entities {
            if let nodeComponent = entity.component(ofType: VisualComponent.self) ?? entity.component(ofType: GKSKNodeComponent.self) {
                if nodeComponent.node === node {
                    if let component = entity.component(ofType: ofType) {
                        return component
                    }
                }
            }
        }
        return nil
    }

    func entity(forNode node: SKNode) -> GKEntity {
        for entity in entities {
            if let nodeComponent = entity.component(ofType: VisualComponent.self) ?? entity.component(ofType: GKSKNodeComponent.self) {
                if nodeComponent.node === node {
                    return entity
                }
            }
        }
        let entity = GKEntity()
        entity.addComponent(VisualComponent(node: node))
        addEntity(entity)
        return entity
    }

    func components<T : GKComponent>(ofType: T.Type) -> [T] {
        var result : [T] = []
        for entity in entities {
            if let component = entity.component(ofType: ofType) {
                result.append(component)
            }
        }
        return result
    }
}
