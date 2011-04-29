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
		ChocrotarySecretaryPerspective *view = [dataSource secretaryPerspective];
		ChocrotaryTask *task = [view getNthTask:row];
		ChocrotaryProject *project = [task project];
	
		NSPopUpButtonCell *projectPopUpButton = cell;
		NSString *selected = @"";
		if (project) {
			selected = [project name];
		}
		[projectPopUpButton selectItemWithTitle:selected];
	}
}
@end
