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

-(id) init {
	notebook = notebook_new("/Users/brandizzi/Documents/software/secretary/Chocrotary/secretary.notebook");
	secretary = notebook_get_secretary(notebook);
	return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return secretary_count_task(secretary);
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	Task *task = secretary_get_nth_task(secretary, row);
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


@end
