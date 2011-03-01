//
//  ChocrotaryTableDataSource.m
//  Chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryTableDataSource.h"


@implementation ChocrotaryTableDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [controller countTasks];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotaryTask *task = [controller getNthTask:row];
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
	ChocrotaryTask *task = [controller getNthTask:row];
	if ([[tableColumn identifier] isEqualToString: @"done" ]) {
		[controller switchDone:task];
	}
	[controller save];
}
@end
