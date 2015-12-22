//
//  AddPersonViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "AddPersonViewController.h"
#import "Person.h"

@interface AddPersonViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Person *> *dataArray;

@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.delegate addPersonViewControllerCancel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.household.people.allObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Person *person = self.household.people.allObjects[indexPath.row];
    cell.textLabel.text = [person fullName];
    if ([self.peopleMutableCopy containsObject:person]) {
        cell.textLabel.textColor = [UIColor grayColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = self.household.people.allObjects[indexPath.row];
    if (![self.peopleMutableCopy containsObject:person]) {
        [self.delegate addPersonViewControllerDidSelectPerson:person];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
