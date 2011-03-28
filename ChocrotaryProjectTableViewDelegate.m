//
//  ChocrotaryProjectTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryProjectTableViewDataSource.h"


@implementation ChocrotaryProjectTableViewDelegate

@synthesize controller, tableView;

-(void) tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger row = [tableView selectedRow];
	switch (row) {
		case ChocrotaryProjectTableViewDataSourceInbox:
			controller.currentDataSource = controller.inboxTableDataSource;
			break;
		case ChocrotaryProjectTableViewDataSourceScheduled:
			controller.currentDataSource = controller.scheduledTableDataSource;
			break;
		case ChocrotaryProjectTableViewDataSourceScheduledForToday:
			controller.currentDataSource = controller.todayTableDataSource;
			break;
		default:
		if (row < [controller.secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
			NSInteger projectIndex = row - ChocrotaryProjectTableViewDataSourceFirstProject;
			ChocrotaryProject *project = [controller.secretary getNthProject:projectIndex];
			[controller.tasksInProjectTableDataSource setProject:project];
			controller.currentDataSource = controller.tasksInProjectTableDataSource;
		}
	}

	[controller reconfigureTaskTable:self];
}

@end
