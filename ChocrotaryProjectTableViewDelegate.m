//
//  ChocrotaryProjectTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryProjectTableViewDelegate.h"


@implementation ChocrotaryProjectTableViewDelegate

@synthesize controller, tableView;

-(void) tableViewSelectionDidChange:(NSNotification *)notification {
	controller.currentDataSource = controller.inboxTableDataSource;
	[controller reconfigureTaskTable:self];
}

@end
