//  LKPMainMenuController.m
//  AutoLayoutKitPrototype
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 12/25/13.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "LKPMainMenuController.h"
#import "LKPMainMenuItem.h"

NSString * const kLKPMainMenuMainCellIdentifier = @"kLKPMainMenuMainCellIdentifier";

@interface LKPMainMenuController ()

@property (nonatomic, strong, readwrite) NSArray *menuItems;

@end

@implementation LKPMainMenuController

@synthesize tableView = _tableView;

#pragma mark - Memory Management

- (void)dealloc
{
    [self tearDownTableView];
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        [self setup];
        self.tableView = tableView;
    }
    return self;
}

- (void)setup
{
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:1];
    LKPMainMenuItem *item;
    
    item = [LKPMainMenuItem simpleMenuItem];
    [menuItems addObject:item];
    
    self.menuItems = [NSArray arrayWithArray:menuItems];
}

#pragma mark - UITableView

- (void)setTableView:(UITableView *)tableView
{
    if (_tableView) {
        [self tearDownTableView];
        _tableView = nil;
    }
    
    if (_tableView == nil) {
        _tableView = tableView;
        [self setupTableView];
    }
}

#pragma mark - UITableView (internal)

- (void)setupTableView
{
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLKPMainMenuMainCellIdentifier];
}

- (void)tearDownTableView
{
    _tableView.dataSource = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKPMainMenuMainCellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    LKPMainMenuItem *item = self.menuItems[indexPath.row];
    
    [cell.textLabel setText:item.title];
    
    return cell;
}

@end
