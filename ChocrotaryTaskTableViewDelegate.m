//
//  ChocrotaryTaskTableViewDelegate.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryTaskTableViewDelegate.h"
#import "ChocrotaryBaseTableViewDataSource.h"

@implementation ChocrotaryTaskTableViewDelegate

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([[tableColumn identifier] isEqualToString:ChocrotaryTaskTableColumnProject]) {
		ChocrotaryBaseTableViewDataSource *dataSource = (ChocrotaryBaseTableViewDataSource*)[tableView dataSource];
		ChocrotarySecretaryView *view = [dataSource secretaryView];
		ChocrotaryTask *task = [view getNthTask:row];
		ChocrotaryProject *project = task_get_project(task);
	
		NSPopUpButtonCell *projectPopUpButton = cell;
		NSString *selected = @"";
		if (project) {
			selected = [NSString stringWithUTF8String:project_get_name(project)];
		}
		[projectPopUpButton selectItemWithTitle:selected];
	}
}
@end
