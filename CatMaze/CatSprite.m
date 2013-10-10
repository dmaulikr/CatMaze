//
//  CatSprite.m
//  CatThief
//
//  Created by Ray Wenderlich on 6/7/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "CatSprite.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"


@implementation CatSprite

@synthesize numBones = _numBones;


- (CCAnimation *)createCatAnimation:(NSString *)animType {
    CCAnimation *animation = [CCAnimation animation];
    for(int i = 1; i <= 2; ++i) {
        [animation addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                             [NSString stringWithFormat:@"cat_%@_%d.png", animType, i]]];
    }
    animation.delay = 0.2;
    return animation;
}

- (void)runAnimation:(CCAnimation *)animation {
    
    if (_curAnimation == animation) return;
    _curAnimation = animation;
    
    if (_curAnimate != nil) {
        [self stopAction:_curAnimate];
    }
    
    _curAnimate = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [self runAction:_curAnimate];
}

- (id)initWithLayer:(HelloWorldLayer *)layer {
    if ((self = [super initWithSpriteFrameName:@"cat_forward_1.png"])) {
        _layer = layer;
        
        _facingForwardAnimation = [[self createCatAnimation:@"forward"] retain];
        _facingBackAnimation = [[self createCatAnimation:@"back"] retain];
        _facingLeftAnimation = [[self createCatAnimation:@"left"] retain];
        _facingRightAnimation = [[self createCatAnimation:@"right"] retain];
        
    }
    return self;
}

- (void)moveToward:(CGPoint)target {
    
    CGPoint diff = ccpSub(target, self.position);
    CGPoint desiredTileCoord = [_layer tileCoordForPosition:self.position];
    
    if (abs(diff.x) > abs(diff.y)) {
        if (diff.x > 0) {
            desiredTileCoord.x += 1;
            [self runAnimation:_facingRightAnimation];
        } else {
            desiredTileCoord.x -= 1; 
            [self runAnimation:_facingLeftAnimation];
        }    
    } else {
        if (diff.y > 0) {
            desiredTileCoord.y -= 1;
            [self runAnimation:_facingBackAnimation];
        } else {
            desiredTileCoord.y += 1;
            [self runAnimation:_facingForwardAnimation];
        }
    }

    if ([_layer isWallAtTileCoord:desiredTileCoord]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hitWall.wav"];
    } else {
        self.position = [_layer positionForTileCoord:desiredTileCoord];
        
        if ([_layer isBoneAtTilecoord:desiredTileCoord]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"pickup.wav"];
            _numBones++;
            [_layer showNumBones:_numBones];
            [_layer removeObjectAtTileCoord:desiredTileCoord];
        } else if ([_layer isDogAtTilecoord:desiredTileCoord]) { 
            if (_numBones == 0) {
                [_layer loseGame];            
            } else {                
                _numBones--;
                [_layer showNumBones:_numBones];
                [_layer removeObjectAtTileCoord:desiredTileCoord];
                [[SimpleAudioEngine sharedEngine] playEffect:@"catAttack.wav"];
            }
        } else if ([_layer isExitAtTilecoord:desiredTileCoord]) {
            [_layer winGame];
        } else {
            [[SimpleAudioEngine sharedEngine] playEffect:@"step.wav"];
        }
    }
    
}

@end
