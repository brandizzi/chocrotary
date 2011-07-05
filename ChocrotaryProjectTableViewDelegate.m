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
//  ChocrotaryProjectTableViewDelegate.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

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
