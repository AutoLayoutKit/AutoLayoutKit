//
//  View.h
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 09.07.13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View : UIView

@property (nonatomic, strong) UIButton *optionA;
@property (nonatomic, strong) UIButton *optionB;
@property (nonatomic, strong) UIButton *optionC;

@property (nonatomic, strong) UIButton *activeButton;

@end
