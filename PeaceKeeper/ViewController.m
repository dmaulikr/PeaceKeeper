//
//  ViewController.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ViewController.h"
#import "Household.h"
#import "Person.h"
#import "NSManagedObjectContext+Category.h"
#import "Chore.h"
#import "AppDelegate.h"
#import "CreateHouseholdViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createHouseholdButton;
@property (weak, nonatomic) IBOutlet UIButton *makeChoreButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Chore *> *chores;

@end


@implementation ViewController

- (NSArray<Chore *> *)chores {
    if (!_chores) {
        NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Chore name]];
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        _chores = results;
        
        if (error) {
            NSLog(@"Error fetching %@ objects: %@", [Chore name], error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched %@ objects", [Chore name]);
            NSLog(@"Chore count: %@", @(_chores.count));
        }
        // DELETE ME
        /*
        for (Chore *chore in _chores) {
            NSLog(@"~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ *");
            NSLog(@"CHORE NAME: %@", chore.name);
            for (Person *person in chore.people) {
                NSLog(@"%@", person.firstName);
            }
        }
        */
        // DELETE ME
    }
    return _chores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self presentCreateHouseholdViewControllerIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    self.chores = nil; // Force refetch
    [self.tableView reloadData];
    
    /*
//    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Household name]];
//    NSError *error;
//    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Household name]];
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching count of %@ objects: %@", [Household name], error.localizedDescription);
    } else {
        NSLog(@"Successfully fetched count of %@ objects: %lu", [Household name], (unsigned long)count);
        self.createHouseholdButton.enabled = false;
        self.makeChoreButton.enabled = true;
    }
    if (count == 0) {
        NSLog(@"No household to retrieve");
        self.makeChoreButton.enabled = false;
        self.createHouseholdButton.enabled = true;
    }
        NSLog(@"");
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentCreateHouseholdViewControllerIfNeeded {
    if (![Household fetchHousehold]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = (UIStoryboard *)appDelegate.window.rootViewController.storyboard;
        CreateHouseholdViewController *createHouseholdNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"CreateHouseholdNavigationController"];
//        CreateHouseholdViewController *createHouseholdViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateHousehold"];
        [self presentViewController:createHouseholdNavigationController animated:true completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AssignedChore" forIndexPath:indexPath];
    Chore *chore = self.chores[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", chore.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Next up: %@", chore.currentPerson.firstName];
    return cell;
}

#pragma mark - UITableViewDelegate

@end
