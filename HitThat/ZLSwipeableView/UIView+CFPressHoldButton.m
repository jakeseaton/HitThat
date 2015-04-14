//
//  UIView+CFPressHoldButton.m
//  CFPressHoldButton
//
//  Created by Hiromasa OHNO on 2014/05/29.
//  Copyright (c) 2014年 CFlat. All rights reserved.
//

#import "UIView+CFPressHoldButton.h"
#import <objc/runtime.h>

@implementation UIView (CFPressHoldButton)

@dynamic pressHoldButtonDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.pressHoldButtonDelegate){
        [self.pressHoldButtonDelegate didStartHolding:self];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.pressHoldButtonDelegate){
        [self.pressHoldButtonDelegate didFinishHolding:self];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.pressHoldButtonDelegate){
        [self.pressHoldButtonDelegate didFinishHolding:self];
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)setPressHoldButtonDelegate:(id<CFPressHoldButtonDelegate>)pressHoldButtonDelegate
{
    objc_setAssociatedObject(self, _cmd, pressHoldButtonDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<CFPressHoldButtonDelegate>)pressHoldButtonDelegate
{
    return objc_getAssociatedObject(self, @selector(setPressHoldButtonDelegate:));
}

@end

