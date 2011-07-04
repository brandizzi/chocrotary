//
//  ChocrotaryProjectTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotarySecretaryPerspective.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"
#import "ChocrotaryTaskTableViewController.h"

@implementation ChocrotaryProjectTableViewDelegate

@synthesize controller, tableView;

-(void) tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger row = [tableView selectedRow];
	ChocrotarySecretaryPerspective *perspective = nil;
	switch (row) {
		case ChocrotaryProjectTableViewDataSourceInbox:
			perspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:controller.secretary];
			break;
		case ChocrotaryProjectTableViewDataSourceScheduled:
			perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:controller.secretary];
			break;
		case ChocrotaryProjectTableViewDataSourceScheduledForToday:
			perspective = [ChocrotarySecretaryScheduledForTodayPerspective newWithSecretary:controller.secretary];
			break;
		default:
		if (row < [controller.secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
			NSInteger projectIndex = row - ChocrotaryProjectTableViewDataSourceFirstProject;
			ChocrotaryProject *project = [controller.secretary getNthProject:projectIndex];
			perspective = [ChocrotarySecretaryProjectPerspective newWithSecretary:controller.secretary];
			[perspective setProject:project];
		}
	}
	[[controller taskTableViewDataSource] setPerspective:perspective];
	[controller reconfigureTaskTable:self];
	[controller updateTotalLabel];
}

@end
