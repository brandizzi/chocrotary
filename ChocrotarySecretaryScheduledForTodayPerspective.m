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
//  ChocrotarySecretaryScheduledForTodayView.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotarySecretaryScheduledForTodayPerspective.h"


@implementation ChocrotarySecretaryScheduledForTodayPerspective
- (NSInteger) countTasks {
	return [secretary countTasksScheduledForToday];
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	return [secretary getNthTaskScheduledForToday:n];
}
- (void) addTask {
	ChocrotaryTask *task = [secretary createTask:@""];
	[task scheduleFor:[NSDate date]];
}

- (void) archiveAllDoneTasks {
	[secretary archiveDoneTasksScheduledForToday];
}
@end
