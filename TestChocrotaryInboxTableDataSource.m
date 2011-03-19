//
//  TestChocrotaryImboxTableDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryInboxTableDataSource.h"
#import "ChocrotarySecretary.h"
#import "ChocrotaryNotebook.h"
#import "ChocrotaryInboxTableDataSource.h"


@implementation TestChocrotaryInboxTableDataSource

-(void) testColumns {
	ChocrotaryInboxTableDataSource *dataSource = [[ChocrotaryInboxTableDataSource alloc] init];
	STAssertEquals([dataSource numberOfColumns], 2L, @"Should have 2 columns");
	NSTableColumn *column = [dataSource getNthColumn:0];
	STAssertEqualObjects([column identifier], @"done", @"Identifier of 1st column should be 'done'");
	column = [dataSource getNthColumn:1];
	STAssertEqualObjects([column identifier], @"description", @"Identifier of 2nd column should be 'description'");
}

-(void) testInboxTasks {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotarySecretary *secretary = [notebook getSecretary];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	ChocrotaryInboxTableDataSource *dataSource = [[ChocrotaryInboxTableDataSource alloc] initWithController:controller];

	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have only one");
	
	NSTableColumn *column = [dataSource getNthColumn:0];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	column = [dataSource getNthColumn:1];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" desxc column should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");

}
@end
