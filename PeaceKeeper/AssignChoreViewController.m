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

@interface AssignChoreViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Person *> *people;

@end

@implementation AssignChoreViewController

- (NSArray<Person *> *)people {
    if (!_people) {
        NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Household name]];
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        if (results.count > 0) {
            Household *household = results.firstObject;
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

    NSLog(@"%@", self.tempDictionary);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person"];
    Person *person = self.people[indexPath.row];
    cell.textLabel.text = @";
    return cell;
}


@end
