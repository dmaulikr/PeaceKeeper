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
#import "CoreDataStackManager.h"
#import "Chore.h"
#import "AppDelegate.h"
#import "CreateHouseholdViewController.h"
#import "HouseholdViewController.h"
#import "MakeChoreViewController.h"
#import "ChoreDetailViewController.h"
#import "PresetTaskViewController.h"
#import "Choree.h"
#import "NSDate+Category.h"
#import "Functions.h"

NSString *const addChoreSegueIdentifier = @"PresetTask";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Chore *> *chores;

@end

@implementation ViewController

- (NSArray<Chore *> *)chores {
    if (!_chores) {
        NSArray *unsortedChores = [NSMutableArray arrayWithArray:[[CoreDataStackManager sharedManager] fetchChoresAndPrefetchChorees]];
        _chores = [unsortedChores sortedArrayUsingComparator:^NSComparisonResult(Chore * _Nonnull chore1, Chore *  _Nonnull chore2) {
            return [[chore1 earliestAlertDate] compare:[chore2 earliestAlertDate]];
        }];
    }
    return _chores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.topItem.title = @"Chores";
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
    
    [self cancelAllLocalNotificationsIfNoHouseholdsExist];
    [self presentCreateHouseholdViewControllerIfNeeded];
    [self performAddChoreSegueIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cancelAllLocalNotificationsIfNoHouseholdsExist {
    if (self.chores.count == 0 && [[CoreDataStackManager sharedManager] fetchHouseholdsAsObjectIDs].count == 0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)presentCreateHouseholdViewControllerIfNeeded {
    if (self.chores.count == 0 && [[CoreDataStackManager sharedManager] fetchHouseholdsAsObjectIDs].count == 0) {
        UINavigationController *createHouseholdNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateHouseholdNavigationController"];
        [self presentViewController:createHouseholdNavigationController animated:YES completion:nil];
    }
}

- (void)performAddChoreSegueIfNeeded {
    if (self.chores.count == 0 && [[CoreDataStackManager sharedManager] fetchHouseholdsAsObjectIDs].count > 0) {
        [self performSegueWithIdentifier:addChoreSegueIdentifier sender:nil];
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
    Choree *earliestChoree = [chore earliestChoree];
    cell.textLabel.text = chore.name;
    
    cell.imageView.image = iconImageFromImageName(chore.imageName);
    cell.imageView.tintColor = self.tableView.tintColor;
    
    NSString *detailText;
    
    if (earliestChoree.alertDate.isInThePast) {
        detailText = [NSString stringWithFormat:@"%@ ⚠️", earliestChoree.alertDate.descriptionOfTimeToNowInDaysHoursOrMinutes];
    } else {
        detailText = [NSString stringWithFormat:@"%@", earliestChoree.alertDate.descriptionOfTimeToNowInDaysHoursOrMinutes];
    }
    cell.detailTextLabel.text = detailText;
    return cell;
}

#pragma mark - UITableViewDelegate

@end
