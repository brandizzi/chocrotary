//
//  ChocrotaryBaseTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryBaseTableViewDataSource.h"


@implementation ChocrotaryBaseTableViewDataSource
- (id) init {
	[super init];
	return self;
}


-(NSInteger) numberOfColumns {
	return 4;
}


-(NSTableColumn *) getNthColumn:(NSInteger) index{
	NSTableColumn *column = [[NSTableColumn alloc] init];
	switch (index) {
		case 0:
			[column setIdentifier:@"done"];
			[column setWidth:20];
			return column;
		case 1:
			[column setIdentifier:@"description"];
			[column setResizingMask:NSTableColumnAutoresizingMask];
			return column;
		case 2:
			[column setIdentifier:@"project"];
			return column;
		case 3:
			[column setIdentifier:@"scheduled"];
			return column;
		default:
			return nil;
			
	}
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretary* secretary = [[self controller] secretary];
	ChocrotaryTask *task = [secretary getNthTask:row];
	NSString *columnName = [tableColumn identifier];
	if ([columnName isEqualToString: @"done" ]) {
		[secretary switchDoneStatus:task];
	} else if ([columnName isEqualToString: @"description"]) {
		const char *description = [object UTF8String];
		task_set_description(task, description);
	} else if ([columnName isEqualToString: @"scheduled"]) {
		NSString *value = object;
		if ([value length] != 0) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterMediumStyle];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			NSDate *date = [formatter dateFromString:object];
			[secretary schedule:task to:date];
		} else {
			[secretary unschedule:task];
		}
		
	}
	[[self controller] save];
}

@end
