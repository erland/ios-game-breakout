//
//  SceneController.swift
//  Breakout
//
//  Created by Erland Isaksson on 2019-07-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

protocol SceneController {
    func presentScene(_ scene: SKScene) -> Bool
    func currentScene() -> SKScene?
    func clearOverlayScene() -> Bool
    func setOverlayScene(_ scene: SKScene) -> Bool
}
