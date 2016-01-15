//
//  ModelTests.m
//  PeaceKeeper
//
//  Created by Work on 1/6/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CoreData;

@interface ModelTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation ModelTests

- (void)setUp {
    [super setUp];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PeaceKeeper" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
}

- (void)tearDown {
    self.managedObjectContext = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
