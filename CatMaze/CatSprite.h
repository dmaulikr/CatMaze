//
//  CatSprite.h
//  CatThief
//
//  Created by Ray Wenderlich on 6/7/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface CatSprite : CCSprite {
    HelloWorldLayer * _layer;
    CCAnimation *_facingForwardAnimation;
    CCAnimation *_facingBackAnimation;
    CCAnimation *_facingLeftAnimation;
    CCAnimation *_facingRightAnimation;
    CCAnimation *_curAnimation;
    CCAnimate *_curAnimate;
    int _numBones;
}

@property (nonatomic, assign, readonly) int numBones;

- (id)initWithLayer:(HelloWorldLayer *)layer;
- (void)moveToward:(CGPoint)target;

@end
