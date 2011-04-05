//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"
#import "ChocrotaryInboxTableViewDataSource.h"


@implementation ChocrotaryController

@synthesize projectTableView, taskTableView, secretary, 
	currentDataSource, inboxTableDataSource, scheduledTableDataSource, 
	todayTableDataSource, tasksInProjectTableDataSource, projectArray;

-(id)init {
	return [self initWithNotebook:[[ChocrotaryNotebook alloc] init]];
}

-(id) initWithNotebook:(ChocrotaryNotebook*) n {
	[super init];
	notebook = n;
	secretary = [notebook getSecretary];
	
	projectArray = [NSMutableArray arrayWithCapacity:[secretary countProjects]*2];
	for (int i = 0; i < [secretary countProjects]; i++) {
		ChocrotaryProject *project = [secretary getNthProject:i];
		[projectArray addObject:[NSString stringWithUTF8String:project_get_name(project)] ];
	}
	
	return self;
}

-(ChocrotarySecretary*)secretary {
	return secretary;
}

-(void)save {
	[notebook save];
	[taskTableView reloadData];
	[projectTableView reloadData];
}

-(IBAction) addTask:(id)sender {
	// TODO That is ugly as HELL!
	[secretary appoint:@""];
	[taskTableView reloadData];
	NSInteger lastRow = [taskTableView numberOfRows]-1;
	[taskTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[taskTableView editColumn:1 row:lastRow withEvent:nil select:YES];
}

-(IBAction) removeTask:(id)sender {
	NSIndexSet* indexes = [taskTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound) {
		Task *task = [secretary getNthTask:index];
		[secretary deleteTask:task];
		index = [indexes indexGreaterThanIndex:index];
	}
	[taskTableView reloadData];
	[self save];
}

-(IBAction) addProject:(id)sender {
	[secretary start:@""];
	[projectTableView reloadData];
	NSInteger lastRow = [projectTableView numberOfRows]-1;
	[projectTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[projectTableView editColumn:0 row:lastRow withEvent:nil select:YES];
	[projectArray addObject:@""];
	[self save];
}

-(IBAction) removeProject:(id)sender {
	NSIndexSet* indexes = [projectTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound && index >= 2) {
		ChocrotaryProject *project = [secretary getNthProject: index-2];
		[secretary deleteProject:project];
		index = [indexes indexGreaterThanIndex:index];
	}
	[projectTableView reloadData];
	[self save];
}

-(IBAction) reconfigureTaskTable:(id)sender {
	/*for (NSTableColumn *tableColumn in [[taskTableView tableColumns] copy]) {
		[taskTableView removeTableColumn:tableColumn];
	}
	for (NSInteger i = 0; i < [currentDataSource numberOfColumns]; i++) {
		[taskTableView addTableColumn:[currentDataSource getNthColumn:i]];
	}*/
	[taskTableView setDataSource:currentDataSource];
}

@end
