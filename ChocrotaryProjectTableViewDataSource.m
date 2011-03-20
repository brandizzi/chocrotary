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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[controller secretary] countProjects ]+2;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	switch (row) {
		case 0:
			return @"Inbox";
			break;
		case 1:
			return @"Scheduled";
			break;
		default:
			if (row < [secretary countProjects ]+2) {
				ChocrotaryProject *project = [secretary getNthProject: row-2];
				return [NSString stringWithUTF8String:project_get_name(project)];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller secretary];
	if (row < [secretary countProjects]+2) {
		NSString *name = object;
		ChocrotaryProject *project = [secretary getNthProject:row-2];
		project_set_name(project, [name UTF8String]);
	}
	[controller save];
}


@end
