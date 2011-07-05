/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  ChocrotaryController.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

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
	projectArray, projectsMenu, totalLabel;

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

-(void) updateTotalLabel {
	ChocrotarySecretaryPerspective *perspective = taskTableViewDataSource.perspective;
	NSString *totals = [NSString stringWithFormat:@"%d tasks here (%d tasks everywhere)", 
						[perspective countTasks], [secretary countTasks]];
	[totalLabel setStringValue:totals];
}
@end
