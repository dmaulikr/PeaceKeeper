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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

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
    [self setUpNavBarButtons];
    
    self.navigationController.navigationBar.topItem.title = @"Chores";
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
    // Dispose of any resources that can be recreated.
}

- (void)presentCreateHouseholdViewControllerIfNeeded {
    if (![Household fetchHousehold]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = (UIStoryboard *)appDelegate.window.rootViewController.storyboard;
        UINavigationController *createHouseholdNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"CreateHouseholdNavigationController"];
        CreateHouseholdViewController *createHouseholdViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateHousehold"];
        [self presentViewController:createHouseholdNavigationController animated:true completion:nil];
    }
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChoreDetail"]) {
        ChoreDetailViewController *choreDetailViewController = (ChoreDetailViewController *)segue.destinationViewController;
        choreDetailViewController.chore = self.chores[[self.tableView indexPathForSelectedRow].row];
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
//
//- (void)setUpNavBarButtons {
//    UIBarButtonItem *lulwat = [[UIBarButtonItem alloc ]initWithTitle:@"hello world" style:UIBarButtonItemStylePlain target:self action:@selector(lulwatFire)];
//    
//
//    [self.navigationController.navigationBar.topItem setRightBarButtonItem:lulwat];
//}
//
//-(void)lulwatFire{
//    NSLog(@"LULWAT SLUG");
//}

- (void)setUpNavBarButtons {
    
    UIBarButtonItem *makeChore = [[UIBarButtonItem alloc]initWithTitle:@"Make Chore" style:UIBarButtonItemStylePlain target:self action:@selector(makeChoreButtonPressed)];
    
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:makeChore];
    
    UIBarButtonItem *houseHold = [[UIBarButtonItem alloc]initWithTitle:@"Household" style:UIBarButtonItemStylePlain target:self action:@selector(householdButtonPressed)];
    
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:houseHold];
    
    
}

- (void)householdButtonPressed {
    HouseholdViewController *householdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Household"];
    [self.navigationController pushViewController:householdViewController animated:YES];
}

- (void)makeChoreButtonPressed {
    MakeChoreViewController *makeChoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeChore"];
    [self.navigationController pushViewController:makeChoreViewController animated:YES];
}

#pragma mark - UITableViewDelegate

@end
