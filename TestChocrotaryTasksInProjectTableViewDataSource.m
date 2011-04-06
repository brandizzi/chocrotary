//
//  TestChocrotaryTasksInProjectTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTasksInProjectTableViewDataSource.h"
#import "ChocrotaryTasksInProjectTableViewDataSource.h"

@implementation TestChocrotaryTasksInProjectTableViewDataSource

-(void) testProject {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project1];
	ChocrotaryProject *project2 = [secretary start:@"libsecretary"];
	[secretary move:task2 to:project2];
	[secretary schedule:task1 to:[NSDate date]];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	ChocrotaryTasksInProjectTableViewDataSource *dataSource = [[ChocrotaryTasksInProjectTableViewDataSource alloc] 
															   initWithController:controller];
	// Testing with one project
	dataSource.project = project1;
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
	dataSource.project = project2;
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
