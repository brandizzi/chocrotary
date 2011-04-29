//
//  ChocrotaryProjectTableDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
				return [project name];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)name forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	if (row < [secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
		ChocrotaryProject *project = [secretary getNthProject:row-ChocrotaryProjectTableViewDataSourceFirstProject];
		[project setName:name];
	}
	[controller reloadMenuOfProjects];
	[controller save];
}


@end
