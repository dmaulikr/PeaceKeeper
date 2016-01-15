//
//  ChooseUnitViewController.m
//  PeaceKeeper
//
//  Created by Work on 1/14/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "ChooseUnitViewController.h"
#import "TimeService.h"

@interface ChooseUnitViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *dataArray;

@end

@implementation ChooseUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [TimeService calendarUnitStrings];
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.delegate chooseUnitViewControllerDidCancel];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate chooseUnitViewControllerDidSelectUnit:self.dataArray[indexPath.row]];
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

@end
