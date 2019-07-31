//
//  EntityManager.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-27.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import GameplayKit

class SceneManager {
    var entities : [GKEntity] = []
    var __entitiesToBeRemoved : [GKEntity] = []
    var systems : [GKComponentSystem<GKComponent>] = []

    func addEntity(_ entity: GKEntity) {
        entities.append(entity)
    }
    
    func scheduleRemoveEntity(_ entity: GKEntity) {
        __entitiesToBeRemoved.append(entity)
    }
    
    func removeEntity(_ entity: GKEntity) {
        if let index = entities.index(of:entity) {
            entities.remove(at: index)
            for component in entity.components {
                entity.removeComponent(ofType: type(of: component))
            }
        }
    }
    
    func addComponentToSystems<T: GKComponent>(_ component: T) {
        system(for: type(of: component)).addComponent(component)
    }
    
    func removeComponentFromSystems<T: GKComponent>(for componentClass: T.Type, in entity: GKEntity) {
        system(for: componentClass).removeComponent(foundIn: entity)
    }
    
    func system<T : GKComponent>(for componentType: T.Type) -> GKComponentSystem<T> {
        for system in systems {
            if system.componentClass == componentType {
                return system as! GKComponentSystem<T>
            }
        }
        let system = GKComponentSystem(componentClass: componentType)
        systems.append(system)
        return system as! GKComponentSystem<T>
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
        let entity = Entity(managedBy: self)
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
    
    func update(deltaTime: TimeInterval) {
        for entity in __entitiesToBeRemoved {
            removeEntity(entity)
        }
        __entitiesToBeRemoved.removeAll()
    }
}
