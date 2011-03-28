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
-(void) testColumns {
	ChocrotaryTasksInProjectTableViewDataSource *dataSource = [[ChocrotaryTasksInProjectTableViewDataSource alloc] init];
	STAssertEquals([dataSource numberOfColumns], 4L, @"Should have 4 columns");
	
	NSTableColumn *column = [dataSource getNthColumn:0];
	STAssertNotNil(column, @"1st column not found");
	STAssertEqualObjects([column identifier], @"done", @"Identifier of 1st column should be 'done'");
	
	column = [dataSource getNthColumn:1];
	STAssertNotNil(column, @"2nd column not found");
	STAssertEqualObjects([column identifier], @"description", @"Identifier of 2nd column should be 'description'");
	
	column = [dataSource getNthColumn:2];
	STAssertNotNil(column, @"2rd column not found");
	STAssertEqualObjects([column identifier], @"project", @"Identifier of 3nd column should be 'project'");
	
	column = [dataSource getNthColumn:3];
	STAssertNotNil(column, @"4th column not found");
	STAssertEqualObjects([column identifier], @"scheduled", @"Identifier of 4nd column should be 'scheduled'");
}
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
	
	NSTableColumn *column = [dataSource getNthColumn:0];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	column = [dataSource getNthColumn:1];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Improve interface", @"Wrong task description");
	
	column = [dataSource getNthColumn:2];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Should have project Chocrotary");	
	
	column = [dataSource getNthColumn:3];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceNow] < 10, @"Should be today");	
	
	// Testing with another project
	dataSource.project = project2;
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	column = [dataSource getNthColumn:0];
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	column = [dataSource getNthColumn:1];
	description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	column = [dataSource getNthColumn:2];
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"libsecretary", @"Should have project Chocrotary");	
	
	column = [dataSource getNthColumn:3];
	NSString *nothing = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(nothing, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(nothing, @"", @"Should have no date");	
}
@end
