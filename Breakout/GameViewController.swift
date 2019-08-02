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
import GameController

class GameViewController: UIViewController, SceneController, ReactToMotionEvents, ReactToTouchEvents {
    
    var activeScene : SKScene?
    var activeOverlay : SKScene?
    var touchReleased : Date?
    
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

        #if os (tvOS)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        appDelegate.touchDelegate = self
        #endif

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapInView))
        view.addGestureRecognizer(recognizer)
        Game.stateMachine.enter(TitleState.self)
    }
    
    @objc func tapInView(recognizer: UIGestureRecognizer) {
        let viewLocation = recognizer.location(in: view)
        if let scene = currentScene() {
            let sceneLocation = scene.convertPoint(fromView: viewLocation)
            if let node = nodeAtLocation(touchLocation: sceneLocation, scene: scene) {
                if let tapComponent = Game.sceneManager(forScene: scene).component(forNode: node, ofType: TapEventComponent.self) {
                    tapComponent.tapped = true
                }else if let tapComponent = Game.sceneManager(forScene: scene).component(forNode: scene, ofType:
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
            for component in Game.sceneManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                
                if component.dragOffset != nil {
                    component.dragPosition = touchLocation.x
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = currentScene() {
            for component in Game.sceneManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                
                component.dragOffset = nil
                component.dragPosition = nil
            }
        }
    }
    
    func motionUpdate(_ motion: GCMotion) {
        if let scene = currentScene() {
            if touchReleased != nil && touchReleased!.timeIntervalSinceNow < -1 {
                for component in Game.sceneManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                    if component.dragPosition == nil {
                        component.dragPosition = 0
                    }
                    component.dragPosition = component.dragPosition! + CGFloat(motion.rotationRate.x*7)
                    if component.dragPosition! < -300 {
                        component.dragPosition = -300
                    }
                    if component.dragPosition! > 300 {
                        component.dragPosition = 300
                    }
                }
            }
        }
    }
    
    func touchUpdate(x: Float, y: Float) {
        if let scene = currentScene() {
            if x==0 && y==0 {
                touchReleased = Date()
            }else {
                touchReleased = nil
            }
            for component in Game.sceneManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
                if component.dragPosition == nil {
                    component.dragPosition = 0
                }
                component.dragPosition = CGFloat(x*300)
                if component.dragPosition! < -300 {
                    component.dragPosition = -300
                }
                if component.dragPosition! > 300 {
                    component.dragPosition = 300
                }
            }
        }

    }
    func horizontalInputComponentAtLocation(touchLocation: CGPoint, scene: SKScene) -> HorizontalInputComponent? {
        for component in Game.sceneManager(forScene: scene).components(ofType: HorizontalInputComponent.self) {
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
    
#if os (iOS)
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
#endif
    
}
