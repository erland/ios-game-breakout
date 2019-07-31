//
//  GameScene.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-24.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingScene: BaseScene, SKPhysicsContactDelegate {
    var lastCollision : GKEntity?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addButton(withName: "quit") {
            Game.stateMachine.enter(TitleState.self)
        }
    
        ButtonFactory(self).addButton(withName: "pause") {
            Game.stateMachine.enter(PauseState.self)
        }
        
        if let node = childNode(withName: "//Bat") {
            let entity = Game.sceneManager(forScene: self).entity(forNode: node)
            let component = HorizontalInputComponent()
            component.dragAreaHeight = node.frame.height*4
            component.dragAreaWidth = node.frame.width*4
            entity.addComponent(component)
        }
        
        if let node = childNode(withName: "//VoidWall") {
            let entity = Game.sceneManager(forScene: self).entity(forNode: node)
            entity.addComponent(KillComponent())

            entity.addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: node.frame.size),
                                                 isDynamic: false,
                                                 collisionBitMask: 1,
                                                 categoryBitMask: 5,
                                                 contactTestBitMask: 4))

            entity.addComponent(CollisionComponent())
        }
        
        for name in ["//LeftWall", "//RightWall", "//UpperWall", "//Bat", "//BatLeft", "//BatRight"] {
            if let node = childNode(withName: name) {
                let entity = Game.sceneManager(forScene: self).entity(forNode: node)
                let node = entity.component(ofType: VisualComponent.self)!.node
                
                entity.addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: node.frame.size),
                                                     isDynamic: false,
                                                     collisionBitMask: 2,
                                                     categoryBitMask: 6,
                                                     contactTestBitMask: 4))
            }
        }
        if let ballNode = childNode(withName: "//Ball") {
            let entity = Game.sceneManager(forScene: self).entity(forNode: ballNode)
            if let batNode = childNode(withName: "//Bat") {
                let physicsBody = SKPhysicsBody(circleOfRadius: ballNode.frame.width/2)
                
                entity.addComponent(PhysicsComponent(physicsBody: physicsBody,
                                                     isDynamic: true,
                                                     collisionBitMask: 4,
                                                     categoryBitMask: 3,
                                                     contactTestBitMask: 11))

                entity.addComponent(PositionComponent(position: CGPoint(x: batNode.position.x,
                                                                        y: batNode.position.y+80)))
                entity.addComponent(VelocityComponent(velocity: CGVector(dx: 0,
                                                                         dy: 200)))
                entity.addComponent(HealthComponent(health: 1))
                entity.addComponent(DamagingComponent())
            }
        }
        for y in 0..<3 {
            for x in 0..<8 {
                let brickNode = SKSpriteNode(texture: nil, color: ((y+x)%2 == 1) ? .red : .blue, size: CGSize(width: 56, height: 26))
                addChild(brickNode)
                let entity = Game.sceneManager(forScene: self).entity(forNode: brickNode)
                entity.addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: brickNode.frame.size),
                                                     isDynamic: false,
                                                     collisionBitMask: 8,
                                                     categoryBitMask: 12,
                                                     contactTestBitMask: 4))
                entity.addComponent(PositionComponent(position: CGPoint(x: -240+x*60, y: 240-y*30)))
                entity.addComponent(CollisionComponent())
                entity.addComponent(KillableComponent(sceneManager: Game.sceneManager(forScene: self)))
            }
        }
        physicsWorld.contactDelegate = self
        
        print("Scene did load: \(type(of: self))")
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        if let party = Game.sceneManager(forScene: self).component(forNode: contact.bodyA.node, ofType: CollisionComponent.self) {
            party.addCollision(with: contact.bodyB.node?.entity)
        }
        
        if let party = Game.sceneManager(forScene: self).component(forNode: contact.bodyB.node, ofType: CollisionComponent.self) {
            party.addCollision(with: contact.bodyA.node?.entity)
        }
        
    }
    
    override func updateComponents(deltaTime: TimeInterval) {
        // Update components
        Game.sceneManager(forScene: self).system(for: TapEventComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: HorizontalInputComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: KillComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: KillableComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: ScoreComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: PositionComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: VelocityComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: CollisionComponent.self).update(deltaTime: deltaTime)
        let healthComponents = Game.sceneManager(forScene: self).system(for: HealthComponent.self).components
        var dead = true
        for component in healthComponents {
            if component.health>0 {
                dead = false
                break
            }
        }
        if dead {
            Game.stateMachine.enter(GameOverState.self)
        }
        let killableComponents = Game.sceneManager(forScene: self).system(for: KillableComponent.self).components
        if killableComponents.count == 0 {
            Game.stateMachine.enter(CompletedState.self)
        }
        Game.sceneManager(forScene: self).update(deltaTime: deltaTime)
    }
}
