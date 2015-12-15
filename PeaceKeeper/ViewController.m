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

@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationController.view.backgroundColor = [UIColor whiteColor];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Household name]];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
