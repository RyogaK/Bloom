//
//  BloomView.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/10/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit
import SpriteKit

class BloomView: SKView {
    var bloomScene : BloomScene!
    
    func startBloom() {
        self.bloomScene = BloomScene(size: self.bounds.size)
        self.presentScene(self.bloomScene)
    }
    
    func addBloom() {
        self.bloomScene.addFlower(self.bounds, delay: 0.3, nowSended: true)
    }
}

class BloomScene: SKScene {
    private var contentCreated = false
    private var flowers: Array<Flower> = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .AspectFit
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        if self.contentCreated == false {
            self.contentCreated = true
            self.createContents(view.bounds)
        }
    }
    
    private func createContents(rect: CGRect) {
        for i in 0...40 {
            addFlower(rect, delay: NSTimeInterval(i) * 0.03, nowSended: false)
        }
    }
    
    private func addFlower(rect: CGRect, delay: NSTimeInterval, nowSended: Bool) {
        let flower = Flower(rect: rect, delay: delay, senderMode: nowSended)
        self.flowers.append(flower)
        self.addChild(flower.spriteNode)
    }
    
    override func update(currentTime: NSTimeInterval) {
        for flower in self.flowers {
            flower.update(currentTime)
        }
    }
    
    private class Flower {
        private static let Duration = 0.2
        
        var spriteNode: SKSpriteNode!
        
        var startTime: NSTimeInterval = 0
        var rotationOffset: CGFloat
        var rotationSpeed: CGFloat
        var delay: NSTimeInterval
        
        let senderMode: Bool
        
        init(rect: CGRect, delay: NSTimeInterval, senderMode: Bool) {
            spriteNode = self.dynamicType.newFlowerNode(rect)
            self.delay = delay
            self.senderMode = senderMode
            self.rotationOffset = self.dynamicType.randomBetween0and1() * 2 * CGFloat(M_PI)
            self.rotationSpeed = (self.dynamicType.randomBetween0and1() - 0.5)
        }
        
        func update(currentTime: NSTimeInterval) {
            if startTime == 0 {
                startTime = currentTime
            }
            
            var scale: Double = 1
            if currentTime - startTime < delay {
                scale = 0
            } else if currentTime < (startTime + delay + self.dynamicType.Duration) {
                if self.senderMode {
                    let normalizedDuration = (currentTime - (startTime + delay)) / self.dynamicType.Duration
                    scale = 2 - normalizedDuration
                    spriteNode.alpha = CGFloat(normalizedDuration)
                } else {
                    let normalizedDuration = (currentTime - (startTime + delay)) / self.dynamicType.Duration
                    scale = normalizedDuration
                }
            }
            spriteNode.setScale(CGFloat(scale))
            spriteNode.zRotation = CGFloat(currentTime) * rotationSpeed + self.rotationOffset
        }
        
        private static func newFlowerNode(rect: CGRect) -> SKSpriteNode {
            let i: UInt32 = (arc4random() % 2) + 1
            let flowerNode = SKSpriteNode(imageNamed: "dummy-flower\(i)")
            flowerNode.position = CGPointMake(randomBetween0and1() * rect.width, randomBetween0and1() * rect.height)
            return flowerNode
        }
        
        private static func randomBetween0and1() -> CGFloat {
            return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        }
    }
}
