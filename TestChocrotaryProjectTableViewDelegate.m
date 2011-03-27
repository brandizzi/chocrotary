//
//  TestChocrotaryProjectTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryController.h"
#import "ChocrotaryInboxTableViewDataSource.h"
#import "ChocrotaryScheduledTableViewDataSource.h"
#import "ChocrotaryTodayTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"

@implementation TestChocrotaryProjectTableViewDelegate

- (void) testTableViewSelectInbox {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryInboxTableViewDataSource *inboxDataSource = 
		[[ChocrotaryInboxTableViewDataSource alloc] initWithController:controller];
	ChocrotaryProjectTableViewDataSource *projectDataSource =
		[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
		[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setInboxTableDataSource:inboxDataSource];
	
	NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:0];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertEqualObjects([controller currentDataSource], inboxDataSource, @"Should display inbox now");
	STAssertEquals([taskTableView numberOfColumns], 2L, @"Inbox table should have 2 columns");
}

- (void) testTableViewSelectScheduled {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryScheduledTableViewDataSource *scheduledDataSource = 
		[[ChocrotaryScheduledTableViewDataSource alloc] initWithController:controller];
	ChocrotaryProjectTableViewDataSource *projectDataSource =
		[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
		[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setScheduledTableDataSource:scheduledDataSource];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertEqualObjects([controller currentDataSource], scheduledDataSource, @"Should display scheduled now");
	STAssertEquals([taskTableView numberOfColumns], 4L, @"scheduled table should have 4 columns");
}

- (void) testTableViewSelectScheduledForToday {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTodayTableViewDataSource *todayDataSource = 
	[[ChocrotaryTodayTableViewDataSource alloc] initWithController:controller];
	ChocrotaryProjectTableViewDataSource *projectDataSource =
	[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
	[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setTodayTableDataSource:todayDataSource];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertEqualObjects([controller currentDataSource], todayDataSource, @"Should display scheduled now");
	STAssertEquals([taskTableView numberOfColumns], 4L, @"scheduled table should have 4 columns");
}


@end
