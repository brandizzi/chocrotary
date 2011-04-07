//
//  TestChocrotaryTaskTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 06/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTaskTableViewDelegate.h"
#import "ChocrotaryController.h"
#import "ChocrotaryTasksInProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryTaskTableViewDelegate.h"

@implementation TestChocrotaryTaskTableViewDelegate

-(void) testSelectProjectInPopUpMenu {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotaryProject *project1 = [notebook.secretary start:@"A project"];
	ChocrotaryProject *project2 = [notebook.secretary start:@"Another project"];
	
	ChocrotaryTask *task1 = [notebook.secretary appoint:@"task 1"],
		*task2 = [notebook.secretary appoint:@"task 2"];
	[notebook.secretary move:task1 to:project1];
	[notebook.secretary move:task2 to:project2];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	
	NSPopUpButtonCell *projectCell = [NSPopUpButtonCell new];
	[projectCell addItemWithTitle:@"A project"];
	[projectCell addItemWithTitle:@"Another project"];
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"project"];
	[column setDataCell:projectCell];
	[taskTableView addTableColumn:column];

	// Finally!!!
	ChocrotaryTaskTableViewDelegate *tableViewDelegate = [[ChocrotaryTaskTableViewDelegate alloc] 
														  init];
	[taskTableView setDelegate:tableViewDelegate];
	
	ChocrotaryTasksInProjectTableViewDataSource *tipDataSource = 
	[[ChocrotaryTasksInProjectTableViewDataSource alloc] initWithController:controller];
	
	ChocrotaryProjectTableViewDataSource *projectDataSource =
	[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
	[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	// Here controller will be needed
	projectDataSource.controller = controller;
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setTasksInProjectTableDataSource:tipDataSource];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// The actually relevant part is here
	[tableViewDelegate tableView:taskTableView willDisplayCell:projectCell 
				  forTableColumn:column row:0];
	STAssertEqualObjects([projectCell titleOfSelectedItem], @"A project", @"Should be the first project");
	
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	// The actually relevant part is here
	[tableViewDelegate tableView:taskTableView willDisplayCell:projectCell 
				  forTableColumn:column row:0];
	STAssertEqualObjects([projectCell titleOfSelectedItem], @"Another project", @"Should be the second project");
	
}
@end
