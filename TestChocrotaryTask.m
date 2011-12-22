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
//  TestChocrotaryTask.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 26/04/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotaryTask.h"
#import "ChocrotaryTask.h"
#import "ChocrotaryProject.h"
#import <secretary/secretary.h>
#import "ChocrotaryTaskObserver.h"
#import "ChocrotarySecretaryObserverStub.h"

@implementation TestChocrotaryTask

-(void) testZero {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];
	STAssertEqualObjects([task description], @"New task", @"Should have the given description");
	STAssertEquals([task wrappedTask], oldTask, @"Should be the same task");
	
	STAssertFalse([task done], @"Should not be done");
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");
	STAssertEquals([task project], (ChocrotaryProject*)NULL, @"Should not have project");
}

-(void) testChangeDescription {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];
	STAssertEqualObjects([task description], @"New task", @"Should have the given description");
	
	[task setDescription:@"Same new task"];
	STAssertEquals(strcmp(task_get_description(oldTask), "Same new task"), 0, @"Should transfer the description to oldTask");	
}

-(void) testDo {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];
	STAssertEqualObjects([task description], @"New task", @"Should have the given description");
	
	STAssertFalse([task done], @"Should not be done");
	task_mark_as_done(oldTask);
	STAssertTrue([task done], @"Should be done");
	task_unmark_as_done(oldTask);
	STAssertFalse([task done], @"Should not be done");
	
	STAssertFalse(task_is_done(oldTask), @"Should not be done");
	[task markAsDone];
	STAssertTrue(task_is_done(oldTask), @"Should be done");
	[task unmarkAsDone];
	STAssertFalse(task_is_done(oldTask), @"Should not be done");
	
}

-(void) testSchedule {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];
	
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");	time_t timedate = time(NULL);
	task_schedule(oldTask, timedate);
	STAssertTrue([task isScheduled], @"Should be scheduled");
	NSDate *scheduledDate = [task scheduledFor];
	STAssertEqualObjects(scheduledDate, [NSDate dateWithTimeIntervalSince1970:util_beginning_of_day(timedate)],
						 @"Should be today");
	task_unschedule(oldTask);
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");

	STAssertFalse(task_is_scheduled(oldTask), @"Should not be scheduled");
	[task scheduleFor:scheduledDate];
	STAssertTrue(task_is_scheduled(oldTask), @"Should be scheduled");
	STAssertEquals(task_get_scheduled_date(oldTask), util_beginning_of_day(timedate), @"Should be today");
	[task unschedule];
	STAssertFalse(task_is_scheduled(oldTask), @"Should not be scheduled");
}

-(void) testProject {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];

	STAssertNil([task project], @"Should not have project");	
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:project_new("My project")];
	[project addTask:task];
	STAssertEqualObjects([task project], project, @"Should have project");
	[project removeTask:task];
	STAssertNil([task project], @"Should not have project");
}

-(void) testObserver {
	Task *oldTask = task_new("New task");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:oldTask];
	
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	STAssertEquals([stub countTaskUpdates], 0L, @"No update so far");
	[task attachTaskObserver:stub];
	
	[task setDescription:@"Task with new name"];
	STAssertEquals([stub countTaskUpdates], 1L, @"One update so far");
	[task description];
	STAssertEquals([stub countTaskUpdates], 1L, @"No more updates for now");
	
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:project_new("project")];
	[project addTask:task];
	STAssertEquals([stub countTaskUpdates], 2L, @"2 updates so far");
	[task project];
	STAssertEquals([stub countTaskUpdates], 2L, @"No more updates for now");
	[project removeTask:task];
	STAssertEquals([stub countTaskUpdates], 3L, @"3 updates so far");
	
	[task scheduleFor:[NSDate date]];
	STAssertEquals([stub countTaskUpdates], 4L, @"4 updates so far");
	[task isScheduled];
	[task scheduledFor];
	STAssertEquals([stub countTaskUpdates], 4L, @"No more updates for now");
	[task unschedule];
	STAssertEquals([stub countTaskUpdates], 5L, @"5 updates so far");
	
	[task markAsDone];
	STAssertEquals([stub countTaskUpdates], 6L, @"6 updates so far");
	[task done];
	STAssertEquals([stub countTaskUpdates], 6L, @"No mor updates for now");
	[task unmarkAsDone];
	STAssertEquals([stub countTaskUpdates], 7L, @"7 updates so far");
	
	[task notifyTasksObservers];
	STAssertEquals([stub countTaskUpdates], 8L, @"7 updates so far");
	
	// Now detached
	[task detachTaskObserver:stub];
	
	[task setDescription:@"Task with new name"];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task description];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	
	[project addTask:task];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task project];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[project removeTask:task];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	
	[task scheduleFor:[NSDate date]];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task isScheduled];
	[task scheduledFor];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task unschedule];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	
	[task markAsDone];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task done];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	[task unmarkAsDone];
	STAssertEquals([stub countTaskUpdates], 8L, @"No more updates for detached object");
	
}

@end
