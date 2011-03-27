//
//  TestChocrotaryTodayTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTodayTableViewDataSource.h"
#import "ChocrotaryTodayTableViewDataSource.h"

@implementation TestChocrotaryTodayTableViewDataSource
-(void) testColumns {
	ChocrotaryTodayTableViewDataSource *dataSource = [[ChocrotaryTodayTableViewDataSource alloc] init];
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

-(void) testScheduleForToday {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotarySecretary *secretary = [notebook getSecretary];
	/*ChocrotaryTask *task1 = */[secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary appoint:@"Buy pequi"];
	
	// Scheduled for today
	NSDate *date = [NSDate date];
	[secretary schedule:task2 to:date];
	// Scheduled for future
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];

	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task3 to:project];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	ChocrotaryTodayTableViewDataSource *dataSource = [[ChocrotaryTodayTableViewDataSource alloc] initWithController:controller];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	NSTableColumn *column = [dataSource getNthColumn:0];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	column = [dataSource getNthColumn:1];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	column = [dataSource getNthColumn:2];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	column = [dataSource getNthColumn:3];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");	
}

@end
