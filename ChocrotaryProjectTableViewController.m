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
//
//  ChocrotaryProjectTableViewController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"
#import "ChocrotaryProject.h"
#import "ChocrotaryProjectTableViewController.h"
#import "ChocrotaryTaskTableViewController.h"
#import "ChocrotarySecretaryPerspectives.h"


@implementation ChocrotaryProjectTableViewController

@synthesize controller, tableView;

// DATA SOURCE PROTOCOL

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[controller secretary] countProjects ]+ChocrotaryProjectTableViewControllerFirstProject;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	switch (row) {
		case ChocrotaryProjectTableViewControllerInbox:
			return @"Inbox";
			break;
		case ChocrotaryProjectTableViewControllerScheduled:
			return @"Scheduled";
			break;
		case ChocrotaryProjectTableViewControllerScheduledForToday:
			return @"For today";
			break;			
		default:
			if (row < [secretary countProjects]+ChocrotaryProjectTableViewControllerFirstProject) {
				ChocrotaryProject *project = [secretary getNthProject: row-ChocrotaryProjectTableViewControllerFirstProject];
				return [project projectName];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)name forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	if (row < [secretary countProjects]+ChocrotaryProjectTableViewControllerFirstProject) {
		ChocrotaryProject *project = [secretary getNthProject:row-ChocrotaryProjectTableViewControllerFirstProject];
		[project setProjectName:name];
	}
	[controller reloadMenuOfProjects];
	[[controller notebook] save];
}

// DELEGATE PROTOCOL
-(void) tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger row = [tableView selectedRow];
	ChocrotarySecretaryPerspective *perspective = nil;
	switch (row) {
		case ChocrotaryProjectTableViewControllerInbox:
			perspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:controller.secretary];
			break;
		case ChocrotaryProjectTableViewControllerScheduled:
			perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:controller.secretary];
			break;
		case ChocrotaryProjectTableViewControllerScheduledForToday:
			perspective = [ChocrotarySecretaryScheduledForTodayPerspective newWithSecretary:controller.secretary];
			break;
		default:
			if (row < [controller.secretary countProjects]+ChocrotaryProjectTableViewControllerFirstProject) {
				NSInteger projectIndex = row - ChocrotaryProjectTableViewControllerFirstProject;
				ChocrotaryProject *project = [controller.secretary getNthProject:projectIndex];
				perspective = [ChocrotarySecretaryProjectPerspective newWithSecretary:controller.secretary];
				[perspective setProject:project];
			}
	}
	[[controller taskTableViewController] setPerspective:perspective];
	[controller reconfigureTaskTable];
	[controller updateTotalLabel];
}
@end
