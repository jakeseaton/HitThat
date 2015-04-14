//
//  UIView+CFPressHoldButton.h
//  CFPressHoldButton
//
//  Created by Hiromasa OHNO on 2014/05/29.
//  Copyright (c) 2014年 CFlat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFPressHoldButtonDelegate <NSObject>

@required
- (void)didStartHolding:(UIView*)targetView;
- (void)didFinishHolding:(UIView*)targetView;

@end

@interface UIView (CFPressHoldButton)

@property (nonatomic, weak) id<CFPressHoldButtonDelegate> pressHoldButtonDelegate;

@end

