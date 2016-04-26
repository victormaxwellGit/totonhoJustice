//
//  GameScene.swift
//  TotonhoJustice
//
//  Created by Victor Maxwell on 19/04/16.
//  Copyright (c) 2016 Bepid. All rights reserved.
//

import SpriteKit

enum Direction  {
    case LEFT
    case RIGHT
}

class GameScene: SKScene {
    var totonho: SKSpriteNode?
    var leftArrow: SKSpriteNode?
    var rightArrow: SKSpriteNode?
    var buttonA: SKSpriteNode?
    var buttonB: SKSpriteNode?
    
    var buttonsCreated = [SKSpriteNode]()
    var pressedButtons = [SKSpriteNode]()
    
    var speedT: CGFloat = 20.0
    var direction: Direction = Direction.RIGHT

    var isJumping = false
    
    override func didMoveToView(view: SKView) {
        totonho = self.childNodeWithName("totonho") as? SKSpriteNode
        
        if (totonho != nil) {
            leftArrow = totonho!.childNodeWithName("leftArrow") as? SKSpriteNode
            buttonsCreated.append(leftArrow!)
            
            rightArrow = totonho!.childNodeWithName("rightArrow") as? SKSpriteNode
            buttonsCreated.append(rightArrow!)
            
            buttonA = totonho!.childNodeWithName("buttonA") as? SKSpriteNode
            buttonsCreated.append(buttonA!)
            
            buttonB = totonho!.childNodeWithName("buttonB") as? SKSpriteNode
            buttonsCreated.append(buttonB!)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(totonho!)
            for button in buttonsCreated {
                if button.containsPoint(location) && pressedButtons.indexOf(button) == nil {
                    pressedButtons.append(button)
                }
            }
        }
        
        for button in buttonsCreated {
            if pressedButtons.indexOf(button) == nil {
                button.alpha = 0.2
            } else {
                button.alpha = 0.8
            }
        }
    }
    
    func walk(direction: Direction) {
        print(#function)
        //velocity = (velocity.speed, direction)
        if direction == Direction.RIGHT {
            totonho!.position = CGPoint(x: (totonho!.position.x) + speedT,
                                    y: totonho!.position.y)
        } else {
            totonho!.position = CGPoint(x: (totonho!.position.x) - speedT,
                                    y: totonho!.position.y)
        }
    }
    
    func simpleJump() {
        print(#function)
        if !isJumping {
            totonho!.physicsBody?.applyImpulse(CGVectorMake(0, 800))
            isJumping = true
        }
    }
    
    func jump() {
        if !isJumping {
            if (direction == Direction.LEFT) {
                totonho!.physicsBody?.applyImpulse(CGVectorMake(-20, 800))
            } else {
                totonho!.physicsBody?.applyImpulse(CGVectorMake(20, 800))
            }
            isJumping = true
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if pressedButtons.indexOf(buttonA!) != nil {
            if pressedButtons.indexOf(leftArrow!) != nil {
                jump()
            } else if pressedButtons.indexOf(rightArrow!) != nil {
                jump()
            } else {
                simpleJump()
            }
        }
        
        if pressedButtons.indexOf(rightArrow!) != nil && pressedButtons.indexOf(buttonA!) != nil {
            jump()
        }
        
        if pressedButtons.indexOf(leftArrow!) != nil {
            walk(Direction.LEFT)
        }
        if pressedButtons.indexOf(rightArrow!) != nil {
            walk(Direction.RIGHT)
        }
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(totonho!)
            let previousLocation = touch.previousLocationInNode(totonho!)
            
            for button in buttonsCreated {
                if button.containsPoint(previousLocation) && !button.containsPoint(location) {
                    let index = pressedButtons.indexOf(button)
                    if index != nil {
                        pressedButtons.removeAtIndex(index!)
                    }
                } else if !button.containsPoint(previousLocation) && button.containsPoint(location) && pressedButtons.indexOf(button) == nil {
                    pressedButtons.append(button)
                }
            }
        }
        
        for button in buttonsCreated {
            if pressedButtons.indexOf(button) == nil {
                button.alpha = 0.2
            } else {
                button.alpha = 0.8
            }
        }
    }
    
    func touchsEndOrCancelled(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(totonho!)
            let previousLocation = touch.previousLocationInNode(totonho!)
            
            for button in buttonsCreated {
                if button.containsPoint(location) {
                    let index = pressedButtons.indexOf(button)
                    if index != nil {
                        pressedButtons.removeAtIndex(index!)
                    }
                }
                else if (button.containsPoint(previousLocation)) {
                    let index = pressedButtons.indexOf(button)
                    if index != nil {
                        pressedButtons.removeAtIndex(index!)
                    }
                }
            }
        }
        for button in buttonsCreated {
            if pressedButtons.indexOf(button) == nil {
                button.alpha = 0.2
            }
            else {
                button.alpha = 0.8
            }
        }
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchsEndOrCancelled(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchsEndOrCancelled(touches!, withEvent: event)
    }

}
