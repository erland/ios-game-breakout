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
            let entity = Game.entityManager(forScene: self).entity(forNode: node)
            let component = HorizontalInputComponent()
            component.dragAreaHeight = node.frame.height*4
            component.dragAreaWidth = node.frame.width*4
            entity.addComponent(component)
        }
        
        if let node = childNode(withName: "//VoidWall") {
            let entity = Game.entityManager(forScene: self).entity(forNode: node)
            entity.addComponent(KillComponent())
            if node.physicsBody == nil {
                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                node.physicsBody?.friction = 0.0
                node.physicsBody?.restitution = 1.0
                node.physicsBody?.linearDamping = 0.0
                node.physicsBody?.angularDamping = 0.0
                node.physicsBody?.collisionBitMask = 1
                node.physicsBody?.categoryBitMask = 5
                node.physicsBody?.contactTestBitMask = 4
            }
        }
        
        for name in ["//LeftWall", "//RightWall", "//UpperWall", "//Bat", "//BatLeft", "//BatRight"] {
            if let node = childNode(withName: name) {
                let entity = Game.entityManager(forScene: self).entity(forNode: node)
                entity.addComponent(PhysicsComponent())
                let node = entity.component(ofType: GKSKNodeComponent.self)!.node
                if node.physicsBody == nil {
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
                    node.physicsBody?.affectedByGravity = false
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.friction = 0.0
                    node.physicsBody?.restitution = 1.0
                    node.physicsBody?.linearDamping = 0.0
                    node.physicsBody?.angularDamping = 0.0
                    node.physicsBody?.collisionBitMask = 2
                    node.physicsBody?.categoryBitMask = 6
                    node.physicsBody?.contactTestBitMask = 4
                }
            }
        }
        if let ballNode = childNode(withName: "//Ball") {
            let entity = Game.entityManager(forScene: self).entity(forNode: ballNode)
            if let batNode = childNode(withName: "//Bat") {
                let component = BallComponent()
                component.position = CGPoint(x: batNode.position.x, y: batNode.position.y+80)
                ballNode.position = component.position
                if ballNode.physicsBody == nil {
                    ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.frame.width/2)
                    ballNode.physicsBody?.affectedByGravity = false
                    ballNode.physicsBody?.isDynamic = true
                    ballNode.physicsBody?.friction = 0.0
                    ballNode.physicsBody?.restitution = 1.0
                    ballNode.physicsBody?.linearDamping = 0.0
                    ballNode.physicsBody?.angularDamping = 0.0
                    ballNode.physicsBody?.mass = 1.0
                    ballNode.physicsBody?.collisionBitMask = 4
                    ballNode.physicsBody?.categoryBitMask = 3
                    ballNode.physicsBody?.contactTestBitMask = 3
                }
                ballNode.physicsBody?.applyImpulse(CGVector(dx: 200, dy: 200))
                entity.addComponent(component)
            }
        }
        physicsWorld.contactDelegate = self
        
        print("Scene did load: \(type(of: self))")
    }
    func isBallEntity(_ node: SKNode?) -> Bool {
        return node != nil && node!.entity != nil && node!.entity!.component(ofType: BallComponent.self) != nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var ballEntity : GKEntity?
        var otherEntity : GKEntity?
        if isBallEntity(contact.bodyA.node) {
            ballEntity = contact.bodyA.node!.entity!
            otherEntity = contact.bodyB.node!.entity!
        }else if isBallEntity(contact.bodyB.node) {
            ballEntity = contact.bodyB.node!.entity!
            otherEntity = contact.bodyA.node!.entity!
        }
        if ballEntity != nil && otherEntity != nil {
            if otherEntity!.component(ofType: KillComponent.self) != nil {
                Game.stateMachine.enter(GameOverState.self)
            }
        }
    }
}
