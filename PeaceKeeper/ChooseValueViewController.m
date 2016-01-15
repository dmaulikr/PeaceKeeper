//
//  ChooseValueViewController.m
//  PeaceKeeper
//
//  Created by Work on 1/14/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "ChooseValueViewController.h"

@interface ChooseValueViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.delegate chooseValueViewControllerDidCancel];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [self.delegate chooseValueViewControllerDidSelectIntegerNumber:@(indexPath.row + 1)];
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

@end
