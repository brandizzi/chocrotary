//
//  ChocrotaryProjectTableDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryProjectTableViewDataSource.h"
#import "secretary/project.h"


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
				return [NSString stringWithUTF8String:project_get_name(project)];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	if (row < [secretary countProjects]+ChocrotaryProjectTableViewDataSourceFirstProject) {
		NSString *name = object;
		ChocrotaryProject *project = [secretary getNthProject:row-ChocrotaryProjectTableViewDataSourceFirstProject];
		project_set_name(project, [name UTF8String]);
	}
	[controller reloadMenuOfProjects];
	[controller save];
}


@end
