//
//  ChocrotaryProjectTableDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryProjectTableDataSource.h"
#import "secretary/project.h"


@implementation ChocrotaryProjectTableDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return secretary_count_project([controller getSecretary])+2;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller getSecretary];
	switch (row) {
		case 0:
			return @"Inbox";
			break;
		case 1:
			return @"Scheduled";
			break;
		default:
			if (row < secretary_count_project(secretary)+2) {
				ChocrotaryProject *project = secretary_get_nth_project(secretary, row-2);
				return [NSString stringWithUTF8String:project_get_name(project)];
			}
			break;
	}
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary *secretary = [controller getSecretary];
	if (row < secretary_count_project(secretary)+2) {
		NSString *name = object;
		ChocrotaryProject *project = secretary_get_nth_project(secretary, row-2);
		project_set_name(project, [name UTF8String]);
	}
	[controller save];
}


@end
