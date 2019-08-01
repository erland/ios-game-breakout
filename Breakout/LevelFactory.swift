//
//  LevelFactory.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-08-01.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class LevelFactory {
    let scene : SKScene
    
    let levels : [[String]] = [
        ["11111111111",
         "11111111111",
         "11111111111"],
        
        ["12121212121",
        "21212121212",
        "12121212121"]
    ]
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func getLevel(levelNo: Int) -> [Entity]? {
        guard levelNo>0 && levelNo<=levels.count else {
            return nil
        }
        let level = levels[levelNo-1]
        
        var result : [Entity] = []
        for (row,rowString) in level.enumerated() {
            let columns = rowString.count
            for column in 0..<columns {
                let ch = rowString[rowString.index(rowString.startIndex, offsetBy: column)]
                let block = createBlock(ofType: ch)
                if let block = block {
                    block.addComponent(PositionComponent(position: CGPoint(x: -(columns*50/2)+column*50+25, y: 240-row*25)))
                    result.append(block)
                }
            }
        }
        return result
    }
    
    func createBlock(ofType blockType: Character) -> Entity? {

        var color : UIColor
        var life : Int
        var score : Int = 1
        switch blockType {
        case "1":
            color = .red
            life = 1
        case "2":
            color = .blue
            life = 2
        default:
            return nil
        }
        
        let brickNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: 46, height: 21))
        let entity = Entity(managedBy: Game.sceneManager(forScene: scene))
        entity.addComponent(VisualComponent(node: brickNode))
        entity.addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: brickNode.frame.size),
                                             isDynamic: false,
                                             collisionBitMask: 8,
                                             categoryBitMask: 12,
                                             contactTestBitMask: 4))
        entity.addComponent(CollisionComponent())
        if life>0 {
            entity.addComponent(KillableComponent(life: life))
        }
        entity.addComponent(ScoreComponent(score: score))
        return entity

    }
}
