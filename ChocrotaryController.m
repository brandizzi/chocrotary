//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewDataSource.h"


@implementation ChocrotaryController

@synthesize projectTableView, taskTableView, secretary, 
	currentDataSource, inboxTableDataSource, scheduledTableDataSource, 
	todayTableDataSource, tasksInProjectTableDataSource, projectArray, projectsMenu;

-(id)init {
	return [self initWithNotebook:[[ChocrotaryNotebook alloc] init]];
}

-(id) initWithNotebook:(ChocrotaryNotebook*) aNotebook {
	[super init];
	notebook = aNotebook;
	secretary = [notebook getSecretary];
	
	projectArray = [NSMutableArray arrayWithCapacity:[secretary countProjects]*2];
	if (projectsMenu == nil) {
		projectsMenu = [NSMenu new];
	}
	[self reloadMenuOfProjects];
	return self;
}

-(ChocrotarySecretary*)secretary {
	return secretary;
}

-(void)reloadMenuOfProjects {
	[projectArray removeAllObjects];
	[projectArray addObject:@""];

	[projectsMenu removeAllItems];
	NSMenuItem *item = [projectsMenu addItemWithTitle:@"" action:nil keyEquivalent:@""];
	[item setTag:-1];
	for (int i = 0; i < [secretary countProjects]; i++) {
		ChocrotaryProject *project = [secretary getNthProject:i];
		NSString *projectName = [NSString stringWithUTF8String:project_get_name(project)];
		[projectArray addObject:projectName];
		item = [projectsMenu addItemWithTitle:projectName action:nil keyEquivalent:@""];
		[item setTag:i];
	}
	
}

-(void)save {
	[notebook save];
	[taskTableView reloadData];
	[projectTableView reloadData];
}

-(IBAction) addTask:(id)sender {
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
	[self reloadMenuOfProjects];
}

-(IBAction) removeProject:(id)sender {
	NSIndexSet* indexes = [projectTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound && index >= ChocrotaryProjectTableViewDataSourceFirstProject) {
		ChocrotaryProject *project = [secretary 
									  getNthProject: index-ChocrotaryProjectTableViewDataSourceFirstProject];
		[secretary deleteProject:project];
		index = [indexes indexGreaterThanIndex:index];
	}
	[self reloadMenuOfProjects];
	[projectTableView reloadData];
	[self save];
}

-(IBAction) reconfigureTaskTable:(id)sender {
	[taskTableView setDataSource:currentDataSource];
	[taskTableView reloadData];

}

@end
