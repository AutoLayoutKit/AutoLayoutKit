//
//  View.m
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 09.07.13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import "View.h"

#import "AutoLayoutKit.h"

NSString * const kLKWidth   = @"width";
NSString * const kLKHeight  = @"height";

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // view setup
    self.backgroundColor = [UIColor grayColor];
    
    // subviews
    [self setupSubviews];
    [self setupLayout];
}

#pragma mark - Animation (internal)

- (void)growButton:(UIButton *)button
{
    NSLayoutConstraint *width = [button alk_constraintWithName:kLKWidth];
    NSLayoutConstraint *height = [button alk_constraintWithName:kLKHeight];
    width.constant = 70.f;
    height.constant = 70.f;
    [button setNeedsUpdateConstraints];
}

- (void)shrinkButton:(UIButton *)button
{
    NSLayoutConstraint *width = [button alk_constraintWithName:kLKWidth];
    NSLayoutConstraint *height = [button alk_constraintWithName:kLKHeight];
    width.constant = 60.f;
    height.constant = 60.f;
    [button setNeedsUpdateConstraints];
}

#pragma mark - Button Target (internal)

- (void)buttonPressed:(UIButton *)sender
{
    NSLog(@"button %@ pressed", [sender titleForState:UIControlStateNormal]);
    
    if (nil != self.activeButton) {
        [self shrinkButton:self.activeButton];
    }
    
    self.activeButton = sender;
    
    if (nil != self.activeButton) {
        [self growButton:self.activeButton];
    }
    
    [UIView animateWithDuration:.25f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Setup (internal)

- (void)setupSubviews
{
    self.optionA = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.optionA setBackgroundColor:[UIColor whiteColor]];
    [self.optionA setTitle:@"A" forState:UIControlStateNormal];
    [self.optionA addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.optionA];
    
    self.optionB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.optionB setBackgroundColor:[UIColor whiteColor]];
    [self.optionB setTitle:@"B" forState:UIControlStateNormal];
    [self.optionB addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.optionB];
    
    self.optionC = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.optionC setBackgroundColor:[UIColor whiteColor]];
    [self.optionC setTitle:@"C" forState:UIControlStateNormal];
    [self.optionC addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.optionC];
}

- (void)setupLayout
{
    [ALKConstraints layout:self.optionA do:^(ALKConstraints *c) {
        [c set:ALKHeight to:60.f name:kLKHeight];
        [c set:ALKWidth to:60.f name:kLKWidth];
        [c make:ALKRight equalTo:self.optionB s:ALKLeft plus:-10.f];
        [c make:ALKCenterY equalTo:self s:ALKCenterY];
    }];
    
    [ALKConstraints layout:self.optionB do:^(ALKConstraints *c) {
        [c set:ALKHeight to:60.f name:kLKHeight];
        [c set:ALKWidth to:60.f name:kLKWidth];
        [c make:ALKCenterX equalTo:self s:ALKCenterX];
        [c make:ALKCenterY equalTo:self s:ALKCenterY];
    }];
    
    [ALKConstraints layout:self.optionC do:^(ALKConstraints *c) {
        [c set:ALKHeight to:60.f name:kLKHeight];
        [c set:ALKWidth to:60.f name:kLKWidth];
        [c make:ALKLeft equalTo:self.optionB s:ALKRight plus:10.f];
        [c make:ALKCenterY equalTo:self s:ALKCenterY];
    }];
}

@end
