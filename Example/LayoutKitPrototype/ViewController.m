//
//  ViewController.m
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 03.07.13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import "ViewController.h"

#import "View.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    View *view = [[View alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
