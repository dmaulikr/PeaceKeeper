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
#import "EditAlertViewController.h"

@interface EditChoreViewController () <UITableViewDelegate, UITableViewDataSource, AddPersonViewControllerDelegate, EditAlertViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL userDidUpdateStartDateOrRepeatInterval;

@end

@implementation EditChoreViewController

NSUInteger const kAlertSection = 0;
NSUInteger const kEditableSection = 1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    
    self.userDidUpdateStartDateOrRepeatInterval = NO;
}

- (void)toggleSaveButtonIfNeeded {
    if (![self.mutablePeople containsObject:self.currentPerson] || self.mutablePeople.count == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)printPeople {
    NSLog(@"[");
    for (NSInteger i = 0; i < self.mutablePeople.count; i++) {
        Person *person = (Person *)[self.mutablePeople objectAtIndex:i];
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
        addPersonViewController.alreadySelected = self.mutablePeople;
        addPersonViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"EditAlert"]) {
        UINavigationController *navController = segue.destinationViewController;
        EditAlertViewController *editAlertViewController = navController.viewControllers.firstObject;
        editAlertViewController.initialDate = self.startDate;
        editAlertViewController.initialRepeatIntervalString = self.repeatIntervalUnit;
        editAlertViewController.delegate = self;
    }
}


#pragma mark - Actions

- (IBAction)markPersonUnderPressAsCurrentPerson:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressedPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPathUnderPress = [self.tableView indexPathForRowAtPoint:pressedPoint];
        if (indexPathUnderPress.section == kEditableSection && indexPathUnderPress.row < self.mutablePeople.count) {
            NSUInteger prevCurrentPersonIndex = [self.mutablePeople indexOfObject:self.currentPerson];
            self.currentPerson = self.mutablePeople[indexPathUnderPress.row];
            if (prevCurrentPersonIndex == NSNotFound || prevCurrentPersonIndex == indexPathUnderPress.row) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathUnderPress] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathUnderPress, [NSIndexPath indexPathForRow:prevCurrentPersonIndex inSection:kEditableSection]] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self toggleSaveButtonIfNeeded];
        }
    }
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    [self.delegate editChoreViewControllerDidSaveWithPeople:self.mutablePeople currentPerson:self.currentPerson startDate:self.startDate repeatIntervalValue:@(1) repeatIntervalUnit:self.repeatIntervalUnit];
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.delegate editChoreViewControllerDidCancel];
}

#pragma mark - AddPersonViewControllerDelegate
- (void)addPersonViewControllerDidSelectPerson:(Person *)selectedPerson {
    [self.mutablePeople addObject:selectedPerson];
    [self toggleSaveButtonIfNeeded];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)addPersonViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EditAlertViewControllerDelegate

- (void)editAlertViewControllerDidSelectStartDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit {
    if (![startDate isEqualToDate:self.startDate] || ![repeatIntervalUnit isEqualToString:self.repeatIntervalUnit]) {
        self.startDate = startDate;
        self.repeatIntervalUnit = repeatIntervalUnit;
        self.userDidUpdateStartDateOrRepeatInterval = YES;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kAlertSection] withRowAnimation:UITableViewRowAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editAlertViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kAlertSection:
            return 1;
        case kEditableSection:
            return self.mutablePeople.count + 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case kAlertSection:
            cell.textLabel.text = @"Edit Alert";
            cell.detailTextLabel.text = @"";
            break;
        case kEditableSection:
            if (indexPath.row < self.mutablePeople.count) {
                Person *person = (Person *)[self.mutablePeople objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [person fullName]];
                if (self.currentPerson == person) {
                    cell.detailTextLabel.text = @"Next up";
                } else {
                    cell.detailTextLabel.text = @"";
                }
            } else {
                cell.textLabel.text = @"Add Person";
                cell.detailTextLabel.text = @"";
            }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kEditableSection && indexPath.row < self.mutablePeople.count) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Person *movedPerson = [self.mutablePeople objectAtIndex:sourceIndexPath.row];
    [self.mutablePeople removeObjectAtIndex:sourceIndexPath.row];
    [self.mutablePeople insertObject:movedPerson atIndex:destinationIndexPath.row];
    [self printPeople];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self performSegueWithIdentifier:@"AddPerson" sender:nil];
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.mutablePeople removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [self toggleSaveButtonIfNeeded];
        /*
        if (self.mutablePeople.count == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Remove the Last Person From a Chore" message:@"A chore cannot have zero people." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.mutablePeople removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            [self toggleSaveButtonIfNeeded];
        }
        */
    }
    [self printPeople];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == kAlertSection) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        NSString *timeString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        NSString *lowercaseRepeatIntervalUnit = [self.repeatIntervalUnit lowercaseString];
        if (self.userDidUpdateStartDateOrRepeatInterval) {
            return [NSString stringWithFormat:@"Updated alert will start on %@ at %@ and repeat every %@.", dateString, timeString, lowercaseRepeatIntervalUnit];
        }
        return [NSString stringWithFormat:@"Alerts currently start on %@ at %@ and repeat every %@.", dateString, timeString, lowercaseRepeatIntervalUnit];
    }
    
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
    if (indexPath.section == kEditableSection && indexPath.row == self.mutablePeople.count) {
        [self performSegueWithIdentifier:@"AddPerson" sender:nil];
    }
    if (indexPath.section == kAlertSection) {
        [self performSegueWithIdentifier:@"EditAlert" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kEditableSection) {
        if (indexPath.row < self.mutablePeople.count) {
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

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == kEditableSection && proposedDestinationIndexPath.row < self.mutablePeople.count) {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

@end
