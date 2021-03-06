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
//  TestChocrotaryProject.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 28/04/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotaryProject.h"
#import <secretary/project.h>
#import "ChocrotaryProject.h"
#import "ChocrotaryTask.h"
#import "ChocrotarySecretaryObserverStub.h"

@implementation TestChocrotaryProject

-(void) testZero {
	Project *wrapped = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrapped];
	STAssertEquals([project wrappedProject], wrapped, @"Should be the same");
	STAssertEqualObjects([project projectName], @"Project", @"Should be given name");
	STAssertEquals([project countTasks], 0L, @"Should have no task");
}
-(void) testChangeName {
	Project *wrapped = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrapped];
	STAssertEqualObjects([project projectName], @"Project", @"Should be given name");
	
	[project setProjectName:@"Chocrotary"];
	STAssertEqualObjects([project projectName], @"Chocrotary", @"Should be given name");
	STAssertEquals(strcmp(project_get_name(wrapped), "Chocrotary"), 0, @"Should change the name");
	
	project_set_name(wrapped, "libsecretary");
	STAssertEqualObjects([project projectName], @"libsecretary", @"Should be given name");
				   
}
-(void) testAddRemoveTask {
	Task *wrappedTask1 = task_new("Create ChocrotaryProject wrapper class"),
		 *wrappedTask2 = task_new("Use ChocrotaryProject elsewhere");
	ChocrotaryTask *task1 = [ChocrotaryTask taskWithTaskStruct:wrappedTask1],
				   *task2 = [ChocrotaryTask taskWithTaskStruct:wrappedTask2];
	
	Project *wrappedProject = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrappedProject];
	STAssertEquals([project countTasks], 0L, @"Should have no task");
	STAssertNil([project getNthTask:0], @"Should return nil");
	
	[project addTask:task1];
	STAssertEquals([project countTasks], 1L, @"Should have a task");
	STAssertEqualObjects([project getNthTask:0], task1, @"Should return the task");
	STAssertEquals(project_count_tasks(wrappedProject, false), 1, @"Should have a task");
	STAssertEquals(project_get_nth_task(wrappedProject, 0, false), wrappedTask1, @"Should have this task");
	
	project_add_task(wrappedProject, wrappedTask2);
	STAssertEquals([project countTasks], 2L, @"Should have two tasks");
	STAssertEqualObjects([project getNthTask:1], task2, @"Should return the snd task");
	
	[project removeTask:task1];
	STAssertEquals([project countTasks], 1L, @"Should have a task");
	STAssertEqualObjects([project getNthTask:0], task2, @"Should return the task");
	STAssertEquals(project_count_tasks(wrappedProject, false), 1, @"Should have a task");
	STAssertEquals(project_get_nth_task(wrappedProject, 0, false), wrappedTask2, @"Should have this task");
	
	project_remove_task(wrappedProject, wrappedTask2);
	STAssertEquals([project countTasks], 0L, @"Should have no task");
	STAssertNil([project getNthTask:0], @"Should return nil");
}

-(void) testObserver {
	Project *wrappedProject = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrappedProject];
	
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[project attachProjectObserver:stub];
	STAssertEquals([stub countProjectUpdates], 0L, @"No update");
	
	[project setProjectName:@"Project rebranded!"];
	STAssertEquals([stub countProjectUpdates], 1L, @"1 update so far");
	[project projectName];
	STAssertEquals([stub countProjectUpdates], 1L, @"No more updates for now");
	
	Task *wrappedTask = task_new("Create ChocrotaryProject wrapper class");
	ChocrotaryTask *task = [ChocrotaryTask taskWithTaskStruct:wrappedTask];
	
	[project addTask:task];
	STAssertEquals([stub countProjectUpdates], 2L, @"2 updates so far");
	[project countTasks];
	[project getNthTask:0];
	STAssertEquals([stub countProjectUpdates], 2L, @"No more updates for now");
	[project removeTask:task];
	STAssertEquals([stub countProjectUpdates], 3L, @"3 updates so far");
	
	[project notifyProjectObservers];
	STAssertEquals([stub countProjectUpdates], 4L, @"4 updates so far");
	
	[project detachProjectObserver:stub];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
	
	[project setProjectName:@"Project rebranded!"];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
	[project projectName];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
	
	[project addTask:task];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
	[project countTasks];
	[project getNthTask:0];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
	[project removeTask:task];
	STAssertEquals([stub countProjectUpdates], 4L, @"No more updates for dettached object");
}

-(void) testArchive {
	Task *wrappedTask1 = task_new("Create ChocrotaryProject wrapper class"),
		*wrappedTask2 = task_new("Use ChocrotaryProject elsewhere"),
		*wrappedTask3 = task_new("Use ChocrotaryProject elsewhere");
	ChocrotaryTask *task1 = [ChocrotaryTask taskWithTaskStruct:wrappedTask1],
		*task2 = [ChocrotaryTask taskWithTaskStruct:wrappedTask2],
		*task3 = [ChocrotaryTask taskWithTaskStruct:wrappedTask3];	
	
	Project *wrappedProject = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrappedProject];
	
	[task2 markAsDone];

	[project addTask:task1];
	[project addTask:task2];
	[project addTask:task3];
	
	STAssertEquals([project countTasks], 3L, @"Should have 3");
	STAssertEqualObjects([project getNthTask:0], task1, @"should be task 1");
	STAssertEqualObjects([project getNthTask:1], task2, @"should be task 2");
	STAssertEqualObjects([project getNthTask:2], task3, @"should be task 3");
	
	[project archiveDoneTasks];

	STAssertEquals([project countTasks], 2L, @"Should have 3");
	STAssertEqualObjects([project getNthTask:0], task1, @"should be task 1");
	STAssertEqualObjects([project getNthTask:1], task3, @"should be task 3");	
}

@end
