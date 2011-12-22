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
//  ChocrotaryTask.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 26/04/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryTask.h"
#import "ChocrotaryProject.h"


@implementation ChocrotaryTask

+(id)taskWithTaskStruct:(Task*) aTask {
	return [[ChocrotaryTask alloc] initWithTaskStruct:aTask];
}

-(id)initWithTaskStruct:(Task*) aTask {
	task = aTask;
	observers = [NSMutableSet new];
	return self;
}
-(NSString*) description {
	return [NSString stringWithUTF8String:task_get_description(task)];
}

-(void) setDescription:(NSString*) aDescription {
	task_set_description(task, [aDescription UTF8String]);
	[self notifyTasksObservers];
}

-(Task*) wrappedTask {
	return task;
}

-(BOOL) done {
	return task_is_done(task);
}

-(void) markAsDone {
	task_mark_as_done(task);
	[self notifyTasksObservers];
}

-(void) unmarkAsDone {
	task_unmark_as_done(task);	
	[self notifyTasksObservers];
}

-(void) switchDoneStatus {
	task_switch_done_status(task);
	[self notifyTasksObservers];
}

-(BOOL) isScheduled {
	return task_is_scheduled(task);
}

-(NSDate*) scheduledFor {
	if (task_is_scheduled(task)) {
		time_t secondsSinceEpoch = task_get_scheduled_date(task);
		return [NSDate dateWithTimeIntervalSince1970:secondsSinceEpoch];
	} else {
		return nil;
	}
}

-(void) scheduleFor:(NSDate*) aDate {
	time_t secondsSinceEpoch = [aDate timeIntervalSince1970];
	task_schedule(task, secondsSinceEpoch);
	[self notifyTasksObservers];
}

-(void) unschedule {
	task_unschedule(task);
	[self notifyTasksObservers];
}

-(ChocrotaryProject*) project {
	Project *project = task_get_project(task);
	if (project)
		return [ChocrotaryProject projectWithProjectStruct:project];
	return nil;
}

-(void) setProject:(ChocrotaryProject*) aProject {
	Project *project = [aProject wrappedProject];
	task_set_project(task, project);
	[self notifyTasksObservers];
}

-(void) unsetProject {
	task_unset_project(task);
	[self notifyTasksObservers];
}

-(void) attachTaskObserver:(id<ChocrotaryTaskObserver>) anObserver {
	[observers addObject:anObserver];
}

-(void) detachTaskObserver:(id<ChocrotaryTaskObserver>) anObserver {
	[observers removeObject:anObserver];
}
-(void) notifyTasksObservers {
	for (id<ChocrotaryTaskObserver> observer in observers) {
		[observer tasksWereUpdated:self];
	}
}


-(BOOL)isEqual:(id)object {
	if ([object respondsToSelector:@selector(wrappedTask)]) {
		return task == [object wrappedTask];
	}
	return NO;
}
-(NSInteger)hash {
	return (NSInteger) task;
}

@end
