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
//  ChocrotaryProjectTableDataSource.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProject.h"


@implementation ChocrotaryProjectTableViewDataSource

@synthesize controller;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[controller secretary] countProjects ]+ChocrotaryProjectTableViewDataSourceFirstProject;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	switch (row) {
		case ChocrotaryProjectTableViewDataSourceInbox:
			return @"Inbox";
			break;
		case ChocrotaryProjectTableViewDataSourceScheduled:
			return @"Scheduled";
			break;
		case ChocrotaryProjectTableViewDataSourceScheduledForToday:
			return @"For today";
			break;			
		default:
			if (row < [secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
				ChocrotaryProject *project = [secretary getNthProject: row-ChocrotaryProjectTableViewDataSourceFirstProject];
				return [project projectName];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)name forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	if (row < [secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
		ChocrotaryProject *project = [secretary getNthProject:row-ChocrotaryProjectTableViewDataSourceFirstProject];
		[project setProjectName:name];
	}
	[controller reloadMenuOfProjects];
	[controller save];
}


@end
