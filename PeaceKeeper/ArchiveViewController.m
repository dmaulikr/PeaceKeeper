//
//  ArchiveViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/16/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ArchiveViewController.h"
#import "CompletedChore.h"
#import "CoreDataStackManager.h"
#import "Chore.h"
#import "Person.h"
#import "Functions.h"

@interface ArchiveViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<CompletedChore *> *completedChores;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ArchiveViewController

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    return _dateFormatter;
}

- (NSArray<CompletedChore *> *)completedChores {
    if (!_completedChores) {
        NSString *entityName = [CompletedChore name];
        NSManagedObjectContext *managedObjectContext = [[CoreDataStackManager sharedManager] managedObjectContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Error fetching %@ objects: %@", entityName, error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched %@ objects", entityName);
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"completionDate" ascending:NO];
        _completedChores = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    return _completedChores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.completedChores = nil; // Force refetch
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completedChores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CompletedChore" forIndexPath:indexPath];
    CompletedChore *completedChore = self.completedChores[indexPath.row];
    cell.imageView.image = iconImageFromImageName(completedChore.imageName);
    cell.imageView.tintColor = self.tableView.tintColor;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", completedChore.chore
                           .name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Completed by %@ on %@", completedChore.person.firstName, [self.dateFormatter stringFromDate:completedChore.completionDate]];
    return cell;
}

#pragma mark - UITableViewDelegate

@end
