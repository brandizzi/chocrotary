//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryTaskTableViewController.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"
#import "ChocrotaryTaskTableViewController.h"


@implementation ChocrotaryController

@synthesize projectTableView, taskTableView, taskTableViewDataSource, secretary, 
	projectArray, projectsMenu;

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
	return self;
}

-(void) awakeFromNib {
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
	[projectTableView selectRowIndexes:indexes byExtendingSelection:NO];
	[self reloadMenuOfProjects];
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
		NSString *projectName = [project name];
		[projectArray addObject:projectName];
		item = [projectsMenu addItemWithTitle:projectName action:nil keyEquivalent:@""];
		[item setTag:i];
	}
	
}

-(void)save {
	[notebook save];
//	[projectTableView reloadData];
//	[taskTableView reloadData];
}

-(IBAction) addTask:(id)sender {
	[taskTableViewDataSource.perspective addTask];
	[taskTableView reloadData];
	NSInteger lastRow = [taskTableView numberOfRows]-1;
	[taskTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[taskTableView editColumn:1 row:lastRow withEvent:nil select:YES];
}

-(IBAction) removeTask:(id)sender {
	ChocrotaryTaskTableViewController *dataSource = 
		(ChocrotaryTaskTableViewController*)[taskTableView dataSource];
	NSIndexSet* indexes = [taskTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound) {
		ChocrotaryTask *task = [dataSource.perspective getNthTask:index];
		[secretary deleteTask:task];
		index = [indexes indexGreaterThanIndex:index];
	}
	[taskTableView reloadData];
	[self save];
}

-(IBAction) archiveTasksOfCurrentPerspective:(id)sender {
	[taskTableViewDataSource.perspective archiveAllDoneTasks];
	[taskTableView reloadData];
	[self save];
}

-(IBAction) addProject:(id)sender {
	[secretary createProject:@""];
	[projectTableView reloadData];
	NSInteger lastRow = [projectTableView numberOfRows]-1;
	[projectTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[projectTableView editColumn:0 row:lastRow withEvent:nil select:YES];
	[self reloadMenuOfProjects];
}

-(IBAction) removeProject:(id)sender {
	NSIndexSet* indexes = [projectTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex], greater = index;
	while (index != NSNotFound && index >= ChocrotaryProjectTableViewDataSourceFirstProject) {
		if (index > greater) {
			greater = index;
		}
		ChocrotaryProject *project = [secretary 
									  getNthProject: index-ChocrotaryProjectTableViewDataSourceFirstProject];
		[secretary deleteProject:project];
		index = [indexes indexGreaterThanIndex:index];
	}

	[self save];	

	NSInteger projects = [notebook.secretary countProjects],
	numberOfRows = projects+ChocrotaryProjectTableViewDataSourceFirstProject;
	indexes = [NSIndexSet indexSetWithIndex:0];
	[projectTableView selectRowIndexes:indexes byExtendingSelection:NO];
	if (greater >= numberOfRows) {
		indexes = [NSIndexSet indexSetWithIndex:numberOfRows-1];
	} else {
		indexes = [NSIndexSet indexSetWithIndex:greater];
	}
	[projectTableView selectRowIndexes:indexes byExtendingSelection:NO];
	[projectTableView reloadData];
	[self reloadMenuOfProjects];
	
}

-(IBAction) reconfigureTaskTable:(id)sender {
	[taskTableView reloadData];
}

@end
