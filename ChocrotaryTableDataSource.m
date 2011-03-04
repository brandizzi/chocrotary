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
	NSString *columnName = [tableColumn identifier];
 	if ([columnName isEqualToString: @"done" ]) {
		NSButtonCell *button = [NSButtonCell new];
		[button setButtonType:NSSwitchButton];
		[button setState:task_is_done(task)];
		[button setTitle:@""];
		[tableColumn setDataCell:button];
		return button;
	} else if ([columnName isEqualToString: @"description"]) {
		return [[NSString alloc] initWithUTF8String:task_get_description(task) ];
	} else if ([columnName isEqualToString: @"scheduled"]) {
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDatePickerCell *datepicker = [NSDatePickerCell new];
		[datepicker setDatePickerStyle: NSClockAndCalendarDatePickerStyle];
		NSDatePickerElementFlags flags = 0;
		flags |= NSYearMonthDatePickerElementFlag;
		flags |= NSYearMonthDayDatePickerElementFlag;
		[datepicker setDatePickerElements:flags];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		[datepicker setFormatter:formatter];
		[datepicker setDatePickerMode:NSSingleDateMode];
		if (task_is_scheduled(task)) {
			struct tm scheduled_for = task_get_scheduled_date(task);
			time_t since1970 = mktime(&scheduled_for);
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:since1970];
			[datepicker setDateValue:date];
		} else {
			return @"";
		}
		return datepicker;
	} else {
		NSLog(@"But how?!");
		return @"";
	}
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotaryTask *task = [controller getNthTask:row];
	NSString *columnName = [tableColumn identifier];
	if ([columnName isEqualToString: @"done" ]) {
		[controller switchDone:task];
	} else if ([columnName isEqualToString: @"description"]) {
		[controller changeDescription:task to:object];
	} else if ([columnName isEqualToString: @"scheduled"]) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		NSDate *date = [formatter dateFromString:object];
		time_t time = [date timeIntervalSince1970];
		secretary_schedule([controller getSecretary], task, *localtime(&time));
		NSLog(@"d %d %d", task_get_scheduled_date(task).tm_mday, task_get_scheduled_date(task).tm_mon);
	}
	[controller save];
}
@end
