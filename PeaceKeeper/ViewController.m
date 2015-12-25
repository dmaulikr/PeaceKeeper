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
#import "HouseholdViewController.h"
#import "MakeChoreViewController.h"
#import "ChoreDetailViewController.h"
#import "PresetTaskViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Chore *> *chores;

@end

@implementation ViewController

- (NSArray<Chore *> *)chores {
    if (!_chores) {
        NSString *entityName = [Chore name];
        NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        _chores = results;
        if (error) {
            NSLog(@"Error fetching %@ objects: %@", entityName, error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched %@ objects", entityName);
            NSLog(@"%@ count: %@", entityName, @(_chores.count));
        }
    }
    return _chores;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.topItem.title = @"PeaceKeeper";
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    self.chores = nil; // Force refetch
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentCreateHouseholdViewControllerIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentCreateHouseholdViewControllerIfNeeded {
    if (![Household fetchHousehold]) {
        UINavigationController *createHouseholdNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateHouseholdNavigationController"];
        [self presentViewController:createHouseholdNavigationController animated:YES completion:nil];
    }
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChoreDetail"]) {
        ChoreDetailViewController *choreDetailViewController = (ChoreDetailViewController *)segue.destinationViewController;
        choreDetailViewController.chore = self.chores[[self.tableView indexPathForSelectedRow].row];
    }
    if ([segue.identifier isEqualToString:@"PresetTask"]) {
        
    }
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Chore" forIndexPath:indexPath];
    Chore *chore = self.chores[indexPath.row];
    cell.textLabel.text = chore.name;
    return cell;
}

- (void)makeChoreButtonPressed {
//    MakeChoreViewController *makeChoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeChore"];
//    [self.navigationController pushViewController:makeChoreViewController animated:YES];
    
    
    PresetTaskViewController *presetTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"presetTaskVC"];
    
    [self.navigationController pushViewController:presetTaskVC animated:YES];
    
}

#pragma mark - UITableViewDelegate

@end
