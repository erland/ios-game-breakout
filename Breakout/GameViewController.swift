//
//  GameViewController.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-24.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SceneController {
    
    var activeScene : SKScene?
    var activeOverlay : SKScene?
    
    func currentScene() -> SKScene? {
        if activeOverlay != nil {
            return activeOverlay
        }else {
            return activeScene
        }
    }
    
    func presentScene(_ scene: SKScene) -> Bool {
        // Present the scene
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFit
            activeScene = scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            return true
        }
        return false
    }
    
    func setOverlayScene(_ scene: SKScene) -> Bool {
        // Present the scene
        if  activeScene != nil {
            if let view = self.view as! SKView? {
                scene.scaleMode = .aspectFit
                activeOverlay = scene
                view.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
                return true
            }
        }
        return false
    }

    func clearOverlayScene() -> Bool {
        if activeOverlay != nil {
            if let view = self.view as! SKView? {
                activeOverlay = nil
                activeScene?.scaleMode = .aspectFit
                view.presentScene(activeScene!, transition: SKTransition.crossFade(withDuration: 0.5))
                return true
            }
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapInView))
        view.addGestureRecognizer(recognizer)
        Game.stateMachine.enter(TitleState.self)
    }
    
    @objc func tapInView(recognizer: UIGestureRecognizer) {
        let viewLocation = recognizer.location(in: view)
        if let scene = currentScene() {
            let sceneLocation = scene.convertPoint(fromView: viewLocation)
            if let node = nodeAtLocation(touchLocation: sceneLocation, scene: scene) {
                if let tapComponent = Game.entityManager(forScene: scene).component(forNode: node, ofType: TapEventComponent.self) {
                    tapComponent.tapped = true
                }else if let tapComponent = Game.entityManager(forScene: scene).component(forNode: scene, ofType:
                    TapEventComponent.self) {
                    tapComponent.tapped = true
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = currentScene() {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: scene)
            if let component = horizontalInputComponentAtLocation(touchLocation: touchLocation, scene: scene) {
                component.dragOffset = touchLocation.x
                component.dragPosition = touchLocation.x
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = currentScene() {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: scene)
            for component in Game.entityManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                
                if component.dragOffset != nil {
                    component.dragPosition = touchLocation.x
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = currentScene() {
            for component in Game.entityManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                
                component.dragOffset = nil
                component.dragPosition = nil
            }
        }
    }
    
    func horizontalInputComponentAtLocation(touchLocation: CGPoint, scene: SKScene) -> HorizontalInputComponent? {
        for component in Game.entityManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
            if let nodeComponent = component.entity!.component(ofType: VisualComponent.self) {
                if CGRect(x: nodeComponent.node.position.x-component.dragAreaWidth/2,
                          y: nodeComponent.node.position.y-component.dragAreaHeight/2,
                          width: component.dragAreaWidth,
                          height:component.dragAreaHeight).contains(touchLocation) {
                    
                    
                    return component
                }
            }
        }
        return nil
    }
    
    func nodeAtLocation(touchLocation: CGPoint, scene: SKScene) -> SKNode? {
        for child in scene.children {
            if child.contains(touchLocation) {
                return child
            }
        }
        if scene.contains(touchLocation) {
            return scene
        }
        return nil
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
