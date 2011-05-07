//
//  TestChocrotaryProjectTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryController.h"
#import "ChocrotaryTaskTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"

@implementation TestChocrotaryProjectTableViewDelegate

- (void) testTableViewSelectInbox {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setProjectTableView:projectTableView];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:0];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertTrue([controller.taskTableViewDataSource.perspective 
				  isKindOfClass:[ChocrotarySecretaryInboxPerspective class]], @"Should present inbox now");
}

- (void) testTableViewSelectScheduled {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];

	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableViewDataSource:taskDataSource];
	[controller setProjectTableView:projectTableView];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertTrue([controller.taskTableViewDataSource.perspective 
				  isKindOfClass:[ChocrotarySecretaryScheduledPerspective class]],
				 @"Should present scheduled now");
}

- (void) testTableViewSelectScheduledForToday {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	NSTableView *projectTableView = [NSTableView new];

	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableViewDataSource:taskDataSource];
	[controller setProjectTableView:projectTableView];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	STAssertTrue([controller.taskTableViewDataSource.perspective 
				  isKindOfClass:[ChocrotarySecretaryScheduledForTodayPerspective class]],
				 @"Should present scheduled for today now");
}

- (void) testTableViewSelectProject {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"A project"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Another project"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSTableView *projectTableView = [NSTableView new];
	
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	// Here controller will be needed
	projectDataSource.controller = controller;
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableViewDataSource:taskDataSource];
	[controller setProjectTableView:projectTableView];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];

	STAssertTrue([controller.taskTableViewDataSource.perspective 
				  isKindOfClass:[ChocrotarySecretaryProjectPerspective class]],
				 @"Should present scheduled for today now");
	STAssertEqualObjects(taskDataSource.perspective.project, project1, @"Should be project 1");

	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	STAssertTrue([controller.taskTableViewDataSource.perspective 
				  isKindOfClass:[ChocrotarySecretaryProjectPerspective class]],
				 @"Should present scheduled for today now");
	STAssertEqualObjects(taskDataSource.perspective.project, project2, @"Should be project 2");

}
@end
