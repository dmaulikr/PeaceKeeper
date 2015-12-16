//
//  AssignChoreViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "AssignChoreViewController.h"
#import "Person.h"
#import "Household.h"
#import "NSManagedObjectContext+Category.h"
#import "ChoreOrderViewController.h"

@interface AssignChoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Person *> *people;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *selectedRows;

@end

@implementation AssignChoreViewController

- (NSMutableArray<NSNumber *> *)selectedRows {
    if (_selectedRows) {
        if (_selectedRows.count == 0) {
            self.navigationItem.rightBarButtonItem.enabled = false;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = true;
        }
    }
    return _selectedRows;
}

- (NSArray<Person *> *)people {
    if (!_people) {
        Household *household = [Household fetchHousehold];
        if (household) {
            _people = [household.people allObjects];
        } else {
            _people = @[];
        }
    }
    return _people;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.selectedRows = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem.enabled = false;

    NSLog(@"%@", self.tempDictionary);
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChoreOrder"]) {
        ChoreOrderViewController *choreOrderViewController = (ChoreOrderViewController *)segue.destinationViewController;
        choreOrderViewController.tempDictionary = self.tempDictionary;
        NSMutableArray *selectedPeople = [NSMutableArray array];
        for (NSNumber *row in self.selectedRows) {
            [selectedPeople addObject:self.people[row.integerValue]];
        }
        choreOrderViewController.selectedPeople = selectedPeople;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    Person *person = self.people[indexPath.row];
    if ([self.selectedRows containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *selectedRow = @(indexPath.row);
    if ([self.selectedRows containsObject:selectedRow]) {
        [self.selectedRows removeObject:selectedRow];
    } else {
        [self.selectedRows addObject:selectedRow];
    }
    [self.tableView reloadData];
}


@end
