//
//  EditChoreViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "EditChoreViewController.h"
#import "Person.h"

@interface EditChoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableOrderedSet<Person *> *peopleMutableCopy;
@property (strong, nonatomic) NSNumber *currentPersonIndexCopy;

@end

@implementation EditChoreViewController

NSUInteger const kEditableSection = 1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setEditing:YES animated:YES];

    self.peopleMutableCopy = [NSMutableOrderedSet orderedSetWithOrderedSet:self.chore.people];
    self.currentPersonIndexCopy = [self.chore.currentPersonIndex copy];
}

- (void)toggleDoneButtonIfRowsAreSelected {
    if (self.tableView.indexPathsForSelectedRows.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)printPeople {
    NSLog(@"[");
    for (NSInteger i = 0; i < self.peopleMutableCopy.count; i++) {
        if (self.currentPersonIndexCopy.integerValue == i) {
            NSLog(@"%ld. * %@", (long)i, [((Person *)[self.peopleMutableCopy objectAtIndex:i]) fullName]);
        } else {
            NSLog(@"%ld.   %@", (long)i, [((Person *)[self.peopleMutableCopy objectAtIndex:i]) fullName]);
        }
    }
    NSLog(@"]");
}

#pragma mark - Actions

- (IBAction)markPersonUnderPressAsCurrentPerson:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressedPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPathUnderPress = [self.tableView indexPathForRowAtPoint:pressedPoint];
        if (indexPathUnderPress.section == kEditableSection && indexPathUnderPress.row < self.peopleMutableCopy.count) {
            self.currentPersonIndexCopy = @(indexPathUnderPress.row);
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.peopleMutableCopy.count + 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Notification: FIXME";
            break;
        case 1:
            if (indexPath.row < self.peopleMutableCopy.count) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [((Person *)[self.peopleMutableCopy objectAtIndex:indexPath.row]) fullName]];
                if (self.currentPersonIndexCopy.integerValue == indexPath.row) {
                    cell.detailTextLabel.text = @"Next up";
                } else {
                    cell.detailTextLabel.text = @"";
                }
            } else {
                cell.textLabel.text = @"Add another person";
                cell.detailTextLabel.text = @"";
            }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kEditableSection && indexPath.row < self.peopleMutableCopy.count) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Person *movedPerson = [self.peopleMutableCopy objectAtIndex:sourceIndexPath.row];
    [self.peopleMutableCopy removeObjectAtIndex:sourceIndexPath.row];
    [self.peopleMutableCopy insertObject:movedPerson atIndex:destinationIndexPath.row];
    [self printPeople];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.peopleMutableCopy.count > 1) {
            [self.peopleMutableCopy removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Delete Last Person" message:[NSString stringWithFormat:@"“%@” must have at least one person.", self.chore.name] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }

    }
    [self printPeople];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == kEditableSection) {
        return @"Press and hold on a person to make them next up.";
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kEditableSection) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kEditableSection) {
        if (indexPath.row < self.peopleMutableCopy.count) {
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
