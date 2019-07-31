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
    var hudDisplay : HudDisplay?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ButtonFactory(self).addButton(withName: "quit") {
            Game.stateMachine.enter(TitleState.self)
        }
    
        ButtonFactory(self).addButton(withName: "pause") {
            Game.stateMachine.enter(PauseState.self)
        }
        
        ButtonFactory(self).addSceneButton {
            if let state = Game.stateMachine.currentState {
                if state.isKind(of: PlaceBallState.self) {
                    Game.stateMachine.enter(PlayingState.self)
                }
            }
        }
        
        hudDisplay = HudDisplay(sceneManager: Game.sceneManager(forScene: self),
                                score: 0,
                                lives: 3,
                                scoreLabel: childNode(withName: "//score") as? SKLabelNode,
                                livesLabel: childNode(withName: "//lives") as? SKLabelNode)
        
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
        physicsWorld.contactDelegate = self
        
        print("Scene did load: \(type(of: self))")
    }

    func placeBall() {
        let ballNode = SKSpriteNode(texture: nil, color: .green, size: CGSize(width: 30, height: 30))
        ballNode.name = "Ball"
        addChild(ballNode)

        let entity = Game.sceneManager(forScene: self).entity(forNode: ballNode)
        entity.removeComponent(ofType: PhysicsComponent.self)
        entity.removeComponent(ofType: VelocityComponent.self)
        if let batNode = childNode(withName: "//Bat") {
            
            entity.addComponent(PositionComponent(position: CGPoint(x: batNode.position.x,
                                                                    y: batNode.position.y+80)))
            entity.addComponent(HealthComponent(health: 1))
            entity.addComponent(DamagingComponent())
            entity.addComponent(FollowNodeComponent(node: batNode, offset: CGPoint(x: 0, y: 80)))
        }
    }
    
    func startBall() {
        if let ballNode = childNode(withName: "//Ball") {
            let entity = Game.sceneManager(forScene: self).entity(forNode: ballNode)
            entity.removeComponent(ofType: FollowNodeComponent.self)
            let physicsBody = SKPhysicsBody(circleOfRadius: ballNode.frame.width/2)
            
            entity.addComponent(PhysicsComponent(physicsBody: physicsBody,
                                                 isDynamic: true,
                                                 collisionBitMask: 4,
                                                 categoryBitMask: 3,
                                                 contactTestBitMask: 11))
            entity.addComponent(VelocityComponent(velocity: CGVector(dx: 0,
                                                                     dy: 200)))
        }
    }
    
    func loadLevel() {
        self.enumerateChildNodes(withName: "//LevelData") {
            (node, stop) in
            
            if let entity = node.entity {
                Game.sceneManager(forScene: self).scheduleRemoveEntity(entity)
            }
        }
        
        for y in 0..<3 {
            for x in 0..<8 {
                let brickNode = SKSpriteNode(texture: nil, color: ((y+x)%2 == 1) ? .red : .blue, size: CGSize(width: 56, height: 26))
                brickNode.name = "LevelData"
                addChild(brickNode)
                let entity = Game.sceneManager(forScene: self).entity(forNode: brickNode)
                entity.addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: brickNode.frame.size),
                                                     isDynamic: false,
                                                     collisionBitMask: 8,
                                                     categoryBitMask: 12,
                                                     contactTestBitMask: 4))
                entity.addComponent(PositionComponent(position: CGPoint(x: -240+x*60, y: 240-y*30)))
                entity.addComponent(CollisionComponent())
                entity.addComponent(KillableComponent())
                entity.addComponent(ScoreComponent(score: 1))
            }
        }
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
        Game.sceneManager(forScene: self).system(for: FollowNodeComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: KillComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: KillableComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: ScoreComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: PositionComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: VelocityComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: CollisionComponent.self).update(deltaTime: deltaTime)
        Game.sceneManager(forScene: self).system(for: HealthComponent.self).update(deltaTime: deltaTime)
        hudDisplay?.update(deltaTime: deltaTime)
        
        if hudDisplay!.lives<=0 {
            Game.stateMachine.enter(GameOverState.self)
        }else {
            for lifeEvent in Game.sceneManager(forScene: self).events(ofType: LifeEvent.self) {
                if lifeEvent.lifeChange<0 {
                    Game.stateMachine.enter(PlaceBallState.self)
                }
            }
        }
        let killableComponents = Game.sceneManager(forScene: self).system(for: KillableComponent.self).components
        if killableComponents.count == 0 {
            for component in Game.sceneManager(forScene: self).components(ofType: HealthComponent.self) {
                Game.sceneManager(forScene: self).scheduleRemoveEntity(component.entity)
            }
            Game.stateMachine.enter(CompletedState.self)
        }
        Game.sceneManager(forScene: self).update(deltaTime: deltaTime)
    }
}
