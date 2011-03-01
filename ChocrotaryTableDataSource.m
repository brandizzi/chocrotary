//
//  ChocrotaryTableDataSource.m
//  Chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryTableDataSource.h"
#import "secretary/notebook.h"


@implementation ChocrotaryTableDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	Secretary *secretary = [controller getSecretary];
	return secretary_count_task(secretary);
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	Task *task = secretary_get_nth_task([controller getSecretary], row);
	if ([[tableColumn identifier] isEqualToString: @"done" ]) {
		NSButtonCell *button = [NSButtonCell new];
		[button setButtonType:NSSwitchButton];
		[button setState:task_is_done(task)];
		[button setTitle:@""];
		[tableColumn setDataCell:button];
		
		return button;
	} else {
		return [[NSString alloc] initWithUTF8String:task_get_description(task) ];
	}
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	Task *task = secretary_get_nth_task([controller getSecretary], row);
	if ([[tableColumn identifier] isEqualToString: @"done" ]) {
		BOOL value = [object boolValue];
		if (value) {
			secretary_do(secretary, task);
		} else {
			secretary_undo(secretary, task);
		}
	}
	[controller save];
}
@end
