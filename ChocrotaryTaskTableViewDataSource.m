/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  ChocrotaryTaskTableViewDataSource.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryTaskTableViewDataSource.h"


@implementation ChocrotaryTaskTableViewDataSource

@synthesize controller, perspective;

+(id)new {
	return [[ChocrotaryTaskTableViewDataSource alloc] init];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [perspective countTasks];
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotaryTask *task = [perspective getNthTask:row];
	NSString *columnName = [tableColumn identifier];
 	if ([columnName isEqualToString: ChocrotaryTaskTableColumnDone ]) {
		NSButtonCell *button = [NSButtonCell new];
		[button setButtonType:NSSwitchButton];
		[button setState:[task done]];
		[button setTitle:@""];
		[tableColumn setDataCell:button];
		return button;
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnDescription]) {
		return [task description];
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
		if ([task isScheduled]) {
			NSDate *date = [task scheduledFor];
			[datepicker setDateValue:date];
		} else {
			return @"";
		}
		return datepicker;
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnProject]) {
		ChocrotaryProject *project = [task project];
		if (project != NULL) {
			return [project name];
		} else {
			return @"";
		}
		
	} else {
		NSLog(@"But how?!");
		return @"";
	}
}
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	ChocrotaryTask *task = [perspective getNthTask:row];
	NSString *columnName = [tableColumn identifier];
	if ([columnName isEqualToString: ChocrotaryTaskTableColumnDone ]) {
		[task switchDoneStatus];
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnDescription]) {
		[task setDescription:object];
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnProject]) {
		NSNumber *number = object;
		NSInteger selectedIndex = [number integerValue];
		NSPopUpButtonCell *projectCell = [tableColumn dataCell];
		NSMenuItem *selected = [projectCell itemAtIndex:selectedIndex];
		NSInteger projectIndex = [selected tag];
		if (projectIndex != ChocrotaryControllerNoProject) {
			ChocrotaryProject *project = [perspective.secretary getNthProject:projectIndex];
			[project addTask:task];
		} else {
			[task unsetProject];
		}
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnScheduled]) {
		NSString *value = object;
		if ([value length] != 0) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterMediumStyle];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			NSDate *date = [formatter dateFromString:object];
			[task scheduleFor:date];
		} else {
			[task unschedule];
		}
		
	}
	[[self controller] reloadMenuOfProjects];
	[[self controller] save];
}



@end
