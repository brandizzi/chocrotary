//
//  TestChocrotaryScheduledTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryScheduledTableViewDataSource.h"
#import "ChocrotaryScheduledTableViewDataSource.h"
#import "ChocrotaryNotebook.h"
#import "ChocrotaryController.h"
#import "ChocrotaryScheduledTableViewDataSource.h"

@implementation TestChocrotaryScheduledTableViewDataSource

-(void) testColumns {
	ChocrotaryScheduledTableViewDataSource *dataSource = [[ChocrotaryScheduledTableViewDataSource alloc] init];
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

- (void) testScheduleTasks {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotarySecretary *secretary = [notebook getSecretary];
	/*ChocrotaryTask *task1 = */[secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary appoint:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[secretary schedule:task2 to:date];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60.0f];
	[secretary schedule:task3 to:[NSDate date]];
	//[secretary doTask:task3];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task3 to:project];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	ChocrotaryScheduledTableViewDataSource *dataSource = [[ChocrotaryScheduledTableViewDataSource alloc] initWithController:controller];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 2L, @"Should have two tasks");
	
	NSTableColumn *column = [dataSource getNthColumn:0];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should be done");
	 	 
	column = [dataSource getNthColumn:1];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	description = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(description, @" description co lumn should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");
	
	column = [dataSource getNthColumn:2];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(projectName, @"project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Wrong project");

	
	column = [dataSource getNthColumn:3];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");
	when = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:future] < 24*60.0, @"Should be future date");
}

@end
