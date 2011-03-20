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
	switch ([tableView selectedRow]) {
		case ChocrotaryProjectTableViewDataSourceInbox:
			controller.currentDataSource = controller.inboxTableDataSource;
			break;
		case ChocrotaryProjectTableViewDataSourceScheduled:
			controller.currentDataSource = controller.scheduledTableDataSource;
			break;
		default:
			break;
	}

	[controller reconfigureTaskTable:self];
}

@end
