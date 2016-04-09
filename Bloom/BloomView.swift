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
    func startBloom() {
        let scene = BloomScene(size: self.bounds.size)
        self.presentScene(scene)
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
        for i in 0...80 {
            addFlower(rect, delay: NSTimeInterval(i) * 0.1)
        }
    }
    
    private func addFlower(rect: CGRect, delay: NSTimeInterval) {
        let flower = Flower(rect: rect, delay: delay)
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
        
        init(rect: CGRect, delay: NSTimeInterval) {
            spriteNode = self.dynamicType.newFlowerNode(rect)
            self.delay = delay
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
                let normalizedDuration = (currentTime - (startTime + delay)) / self.dynamicType.Duration
                scale = normalizedDuration
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
