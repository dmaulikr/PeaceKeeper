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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createHouseholdButton;
@property (weak, nonatomic) IBOutlet UIButton *makeChoreButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationController.view.backgroundColor = [UIColor whiteColor];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
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

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
