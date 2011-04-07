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

-(id) controller {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(ChocrotarySecretaryView*) secretaryView {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	ChocrotarySecretaryView* view = [self secretaryView];
	return [view countTasks];
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretaryView* view = [self secretaryView];
	ChocrotaryTask *task = [view getNthTask:row];
	NSString *columnName = [tableColumn identifier];
 	if ([columnName isEqualToString: ChocrotaryTaskTableColumnDone ]) {
		NSButtonCell *button = [NSButtonCell new];
		[button setButtonType:NSSwitchButton];
		[button setState:task_is_done(task)];
		[button setTitle:@""];
		[tableColumn setDataCell:button];
		return button;
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnDescription]) {
		return [[NSString alloc] initWithUTF8String:task_get_description(task) ];
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnScheduled]) {
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
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnProject]) {
		ChocrotaryProject *project = task_get_project(task);
		if (project != NULL) {
			return [[NSString alloc] initWithUTF8String:project_get_name(project) ];
		} else {
			return @"";
		}

	} else {
		NSLog(@"But how?!");
		return @"";
	}
}
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotarySecretaryView* view = [self secretaryView];
	ChocrotaryTask *task = [view getNthTask:row];
	NSString *columnName = [tableColumn identifier];
	if ([columnName isEqualToString: ChocrotaryTaskTableColumnDone ]) {
		[view.secretary switchDoneStatus:task];
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnDescription]) {
		const char *description = [object UTF8String];
		task_set_description(task, description);
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnScheduled]) {
		NSString *value = object;
		if ([value length] != 0) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterMediumStyle];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			NSDate *date = [formatter dateFromString:object];
			[view.secretary schedule:task to:date];
		} else {
			[view.secretary unschedule:task];
		}
		
	}
	[[self controller] save];
}

@end
