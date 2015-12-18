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

#import "MMParallaxCell.h"
#import "PresetTaskViewController.h"

#import "HomeCell.h"

#import "ImageArchiverService.h"

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
    }
    return _chores;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView layoutIfNeeded];
    
    // FIXME
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.images) {
        NSMutableArray *images = [ImageArchiverService getMutableImagesArray];
        if (images) {
            appDelegate.images = images;
        } else {
            appDelegate.images = [NSMutableArray array];
        }
    }
    
    [self setUpNavBarButtons];
    [self setupNavigationBar];
    
    //setting up custom cell
//    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil]
//         forCellReuseIdentifier:@"homeCell"];
    self.navigationItem.title = @"PeaceKeeper";
}



-(void) setupNavigationBar {
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:25]}];

    UIColor *navColor = [UIColor colorWithRed:212.0f/255.0f green:64.0f/255.0f blue:75.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.barTintColor = navColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setBarTintColor:navColor];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    self.chores = nil; // Force refetch
    [self.tableView reloadData];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:25]}];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentCreateHouseholdViewControllerIfNeeded];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:25]}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentCreateHouseholdViewControllerIfNeeded {
    if (![Household fetchHousehold]) {
        UINavigationController *createHouseholdNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateHouseholdNavigationController"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ChoreDetail" sender:nil];
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MMParallaxCell *cell = (MMParallaxCell *)[self.tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    
    Chore *chore = self.chores[indexPath.row];
    
    MMParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (cell == nil)
    {
        cell = [[MMParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
        cell.parallaxRatio = 1.8f;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [cell.parallaxImage setImage:appDelegate.images[indexPath.row]];
    
    //NEW CODE
    cell.taskLabel.text = [self.chores[indexPath.row] name];
    cell.taskLabel.frame = CGRectMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height / 2 - 10, 400, 50);
    cell.taskLabel.textColor = [UIColor whiteColor];
    //cell.taskLabel.backgroundColor = [UIColor blackColor];
    cell.taskLabel.center = CGPointMake(cell.taskLabel.frame.origin.x, cell.taskLabel.frame.origin.y);
    cell.taskLabel.textAlignment = NSTextAlignmentCenter;
    cell.taskLabel.font = [UIFont systemFontOfSize:25];
    cell.taskLabel.font = [UIFont fontWithName:@"Avenir" size:25];

    
    cell.personLabel.text = [NSString stringWithFormat:@"Next up: %@",[[self.chores[indexPath.row] currentPerson] firstName]];
    cell.personLabel.frame = CGRectMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height / 2 + 60, 400, 50);
    cell.personLabel.textColor = [UIColor whiteColor];
    cell.personLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    cell.personLabel.center = CGPointMake(cell.personLabel.frame.origin.x, cell.personLabel.frame.origin.y);
    cell.personLabel.textAlignment = NSTextAlignmentCenter;
    cell.personLabel.font = [UIFont systemFontOfSize:25];
    cell.personLabel.font = [UIFont fontWithName:@"Avenir" size:25];
    
    return cell;

    
}



- (void)setUpNavBarButtons {
    
    UIBarButtonItem *makeChore = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addChoreIcon"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(makeChoreButtonPressed)];
    
    makeChore.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:makeChore];
    
    UIBarButtonItem *houseHold = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"householdIcon"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(householdButtonPressed)];
    
    houseHold.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:houseHold];
}

- (void)householdButtonPressed {
    HouseholdViewController *householdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Household"];
    [self.navigationController pushViewController:householdViewController animated:YES];
    
    
}

- (void)makeChoreButtonPressed {
//    MakeChoreViewController *makeChoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeChore"];
//    [self.navigationController pushViewController:makeChoreViewController animated:YES];
    
    
    PresetTaskViewController *presetTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"presetTaskVC"];
    
    [self.navigationController pushViewController:presetTaskVC animated:true];
    
}

#pragma mark - UITableViewDelegate

@end
