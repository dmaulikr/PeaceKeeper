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
#import "CoreDataStackManager.h"
#import "ChoreOrderViewController.h"

@interface AssignChoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Person *> *people;

@end

@implementation AssignChoreViewController

- (NSArray<Person *> *)people {
    if (!_people) {
        Household *household = [[CoreDataStackManager sharedManager] fetchHousehold];
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
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)toggleDoneButtonIfRowsAreSelected {
    if (self.tableView.indexPathsForSelectedRows.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChoreOrder"]) {
        ChoreOrderViewController *choreOrderViewController = (ChoreOrderViewController *)segue.destinationViewController;
        choreOrderViewController.choreInfo = self.choreInfo;
        NSMutableArray *selectedPeople = [NSMutableArray array];
        for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
            [selectedPeople addObject:self.people[indexPath.row]];
        }
        choreOrderViewController.selectedPeople = selectedPeople;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person"];
    Person *person = self.people[indexPath.row];
    cell.textLabel.text = [person fullName];
    return cell;
}

#pragma mark - UITableViewDelegate
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self toggleDoneButtonIfRowsAreSelected];
 }

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self toggleDoneButtonIfRowsAreSelected];
}

@end
