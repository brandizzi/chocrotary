//
//  TestChocrotaryTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTaskTableViewDataSource.h"
#import "ChocrotaryTaskTableViewDataSource.h"
#import "ChocrotaryNotebook.h"
#import "ChocrotaryController.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"

@implementation TestChocrotaryTaskTableViewDataSource
-(void) testInboxTasks {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	[task2 scheduleFor:[NSDate date]];
	
	ChocrotaryTaskTableViewDataSource *dataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have only one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" desxc column should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:@"scheduled"];
	NSString *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when,@"", @"Should be today");	
	
}

- (void) testScheduleTasks {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[task2 scheduleFor:date];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60.0f];
	[task3 scheduleFor:future];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task3];
	
	ChocrotaryTaskTableViewDataSource *dataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];	
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 2L, @"Should have two tasks");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should be not done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	description = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(description, @" description co lumn should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(projectName, @"project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Wrong project");
	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");
	when = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:future] < 24*60.0, @"Should be future date");
}

-(void) testScheduleForToday {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	// Scheduled for today
	NSDate *date = [NSDate date];
	[task2 scheduleFor:date];
	// Scheduled for future
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[task3 scheduleFor:future];
	
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task3];
	
	ChocrotaryTaskTableViewDataSource *dataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledForTodayPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");	
}

-(void) testProject {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"];
	[project1 addTask:task1];
	ChocrotaryProject *project2 = [secretary createProject:@"libsecretary"];
	[project2 addTask:task2];
	[task1 scheduleFor:[NSDate date]];
	
	ChocrotaryTaskTableViewDataSource *dataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryProjectPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	// Testing with one project
	[(ChocrotarySecretaryProjectPerspective*)perspective setProject:project1];
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Improve interface", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Should have project Chocrotary");	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceNow] < 10, @"Should be today");	
	
	// Testing with another project
	[(ChocrotarySecretaryProjectPerspective*)perspective setProject:project2];
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	[column setIdentifier:@"done"];
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"libsecretary", @"Should have project Chocrotary");	
	
	[column setIdentifier:@"scheduled"];
	NSString *nothing = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(nothing, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(nothing, @"", @"Should have no date");	
}


@end
