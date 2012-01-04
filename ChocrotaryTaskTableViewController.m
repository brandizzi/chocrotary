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
//  ChocrotaryTaskTableViewController.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryTaskTableViewController.h"


@implementation ChocrotaryTaskTableViewController

@synthesize controller, perspective;

+(id)new {
	return [[ChocrotaryTaskTableViewController alloc] init];
}

// FOR DATA SOURCE PROTOCOL

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
		[datepicker setLocale:[NSLocale currentLocale]];
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
			return [project projectName];
		} else {
			return @"";
		}
		
	} else {
		NSLog(@"But how?!");
		return @"";
	}
}
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object 
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
			[perspective.secretary moveTask:task toProject:project];
		} else {
			[perspective.secretary removeTaskFromProject:task];
		}
	} else if ([columnName isEqualToString: ChocrotaryTaskTableColumnScheduled]) {
		NSString *value = object;
		if ([value length] != 0) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterMediumStyle];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			NSDate *date = [formatter dateFromString:object];
			[perspective.secretary scheduleTask:task forDate:date];
		} else {
			[perspective.secretary unscheduleTask:task];
		}
		
	}
#warning use observer to call these methods
	[controller reloadMenuOfProjects];
	[[controller notebook] save];
	[controller updateTotalLabel];
	[aTableView reloadData];
}

// FOR DELEGATE PROTOCOL

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([[tableColumn identifier] isEqualToString:ChocrotaryTaskTableColumnProject]) {
		ChocrotaryTask *task = [perspective getNthTask:row];
		ChocrotaryProject *project = [task project];
		
		NSPopUpButtonCell *projectPopUpButton = cell;
		NSString *selected = @"";
		if (project) {
			selected = [project projectName];
		}
		[projectPopUpButton selectItemWithTitle:selected];
	}
}


@end
