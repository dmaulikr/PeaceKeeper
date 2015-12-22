//
//  EditChoreViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "EditChoreViewController.h"
#import "Person.h"
#import "AddPersonViewController.h"
#import "AddPersonViewControllerDelegate.h"

@interface EditChoreViewController () <UITableViewDelegate, UITableViewDataSource, AddPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableOrderedSet<Person *> *peopleMutableCopy;
@property (strong, nonatomic) Person *currentPerson;

@end

@implementation EditChoreViewController

NSUInteger const kEditableSection = 1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];

    self.peopleMutableCopy = [NSMutableOrderedSet orderedSetWithOrderedSet:self.chore.people];
    self.currentPerson = [self.chore currentPerson];
}

- (void)toggleSaveButtonIfNeeded {
    if (![self.peopleMutableCopy containsObject:self.currentPerson] || self.peopleMutableCopy.count == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)printPeople {
    NSLog(@"[");
    for (NSInteger i = 0; i < self.peopleMutableCopy.count; i++) {
        Person *person = (Person *)[self.peopleMutableCopy objectAtIndex:i];
        if (self.currentPerson == person) {
            NSLog(@"%ld. * %@", (long)(i + 1), [person fullName]);
        } else {
            NSLog(@"%ld.   %@", (long)(i + 1), [person fullName]);
        }
    }
    NSLog(@"]");
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        UINavigationController *navController = segue.destinationViewController;
        AddPersonViewController *addPersonViewController = navController.viewControllers.firstObject;
        addPersonViewController.household = self.chore.household;
        addPersonViewController.peopleMutableCopy = self.peopleMutableCopy;
        addPersonViewController.delegate = self;
    }
}


#pragma mark - Actions

- (IBAction)markPersonUnderPressAsCurrentPerson:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressedPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPathUnderPress = [self.tableView indexPathForRowAtPoint:pressedPoint];
        if (indexPathUnderPress.section == kEditableSection && indexPathUnderPress.row < self.peopleMutableCopy.count) {
            NSUInteger prevCurrentPersonIndex = [self.peopleMutableCopy indexOfObject:self.currentPerson];
            self.currentPerson = self.peopleMutableCopy[indexPathUnderPress.row];
            if (prevCurrentPersonIndex == NSNotFound || prevCurrentPersonIndex == indexPathUnderPress.row) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathUnderPress] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathUnderPress, [NSIndexPath indexPathForRow:prevCurrentPersonIndex inSection:kEditableSection]] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self toggleSaveButtonIfNeeded];
        }
    }
}

#pragma mark - Segue
- (void)addPersonViewControllerDidSelectPerson:(Person *)selectedPerson {
    [self.peopleMutableCopy addObject:selectedPerson];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)addPersonViewControllerCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
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
                Person *person = (Person *)[self.peopleMutableCopy objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [person fullName]];
                if (self.currentPerson == person) {
                    cell.detailTextLabel.text = @"Next up";
                } else {
                    cell.detailTextLabel.text = @"";
                }
            } else {
                cell.textLabel.text = @"Add person";
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
        if (self.peopleMutableCopy.count == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Remove the Last Person From a Chore" message:@"A chore cannot have zero people." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.peopleMutableCopy removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            [self toggleSaveButtonIfNeeded];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld-%ld", (long)indexPath.section, (long)indexPath.row);
    if (indexPath.section == kEditableSection && indexPath.row == self.peopleMutableCopy.count) {
        [self performSegueWithIdentifier:@"AddPerson" sender:nil];
    }
}

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
