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
//  ChocrotarySecretary.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotarySecretary.h"
#import <time.h>
#import "ChocrotaryProject.h"


@implementation ChocrotarySecretary

-(ChocrotaryTask*) getCachedOrNewTask:(Task*)task {
	ChocrotaryTask *cached = (ChocrotaryTask *)CFDictionaryGetValue(cachedObjects, task);
	if (cached == nil) {
		cached = [ChocrotaryTask taskWithTaskStruct:task];
		[cached attachTaskObserver:self];
		CFDictionaryAddValue(cachedObjects, task, cached);
		[self notifyTaskUpdate];
	}
	return cached;
}

-(ChocrotaryProject*) getCachedOrNewProject:(Project*)project {
	ChocrotaryProject *cached = (ChocrotaryProject *)CFDictionaryGetValue(cachedObjects, project);
	if (cached == nil) {
		cached = [ChocrotaryProject projectWithProjectStruct:project];
		[cached attachProjectObserver:self];
		CFDictionaryAddValue(cachedObjects, project, cached);
		[self notifyProjectUpdate];
	}
	return cached;
}

-(id)init {
	return [self initWithSecretary:secretary_new()];
}

-(id)initWithSecretary:(Secretary*) ready {
	[super init];
	secretary = ready;
	cachedObjects = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	// Observers containers
	tasksObservers = [NSMutableSet new];
	projectsObservers = [NSMutableSet new];
	return self;
}

-(ChocrotaryTask*) createTask:(NSString*) description {
	Task *task = secretary_create_task(secretary, [description UTF8String]);
	return [self getCachedOrNewTask:task];
}

-(NSInteger) countTasks {
	return secretary_count_tasks(secretary);
}

-(ChocrotaryTask*) getNthTask:(NSInteger)n {
	Task *task =  secretary_get_nth_task(secretary, n);
	return [self getCachedOrNewTask:task];

}


-(NSInteger)countScheduledTasks {
	return secretary_count_tasks_scheduled(secretary, false);
}

-(ChocrotaryTask*)getNthScheduledTask:(NSInteger) n {
	Task *task = secretary_get_nth_task_scheduled(secretary, n, false);
	return [self getCachedOrNewTask:task];
}

-(NSInteger) countTasksScheduledForToday {
	return secretary_count_tasks_scheduled_for_today(secretary, false);
}

-(ChocrotaryTask*) getNthTaskScheduledForToday:(NSInteger)n {
	Task *task = secretary_get_nth_task_scheduled_for_today(secretary, n, false);
	return [self getCachedOrNewTask:task];
}

-(void) deleteTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_delete_task(secretary, task);
	CFDictionaryRemoveValue(cachedObjects, task);
}

-(ChocrotaryProject*) createProject:(NSString*)name {
	Project *project = secretary_create_project(secretary, [name UTF8String]);
	return [self getCachedOrNewProject:project];
}

-(ChocrotaryProject*) getNthProject:(NSInteger)n {
	Project *project = secretary_get_nth_project(secretary, n);
	return [ChocrotaryProject projectWithProjectStruct:project];
}

-(ChocrotaryProject*) getProjectByName:(NSString*) projectName {
	Project *project =  secretary_get_project(secretary, [projectName UTF8String]);
	return [ChocrotaryProject projectWithProjectStruct:project];
}

-(NSInteger) countProjects {
	return secretary_count_projects(secretary);
}

-(void) deleteProject:(ChocrotaryProject*) project {
	
	secretary_delete_project(secretary, [project wrappedProject]);
}


-(NSInteger) countInboxTasks {
	return secretary_count_inbox_tasks(secretary, false);
}

-(ChocrotaryTask*) getNthInboxTask:(NSInteger) n {
	Task *task = secretary_get_nth_inbox_task(secretary, n, false);
	return [self getCachedOrNewTask:task];

}

-(void) archiveDoneInboxTasks {
	secretary_archive_inbox_tasks(secretary);
	[self notifyTaskUpdate];
}

-(void) archiveDoneScheduledTasks {
	secretary_archive_scheduled_tasks(secretary);
	[self notifyTaskUpdate];
}

-(void) archiveDoneTasksScheduledForToday {
	secretary_archive_tasks_scheduled_for_today(secretary);
	[self notifyTaskUpdate];
}

-(ChocrotaryTask*)wrapperForTask:(Task*) aTask {
	return [self getCachedOrNewTask:aTask];
}

-(void)release {
	secretary_free(secretary);
	[super release];
}

-(void)attachTaskObserver:(id<ChocrotaryTaskObserver>)observer {
	[tasksObservers addObject:observer];
}
-(void)detachTasksObserver:(id<ChocrotaryTaskObserver>)observer {
	[tasksObservers removeObject:observer];
}

-(void)attachProjectObserver:(id<ChocrotaryProjectObserver>)observer {
	[projectsObservers addObject:observer];
}
-(void)detachProjectsObserver:(id<ChocrotaryProjectObserver>)observer {
	[projectsObservers removeObject:observer];
}

-(void)notifyProjectUpdate {
	for (id<ChocrotaryProjectObserver> observer in projectsObservers) {
		[observer projectsWereUpdated:self];
	}
}
-(void)notifyTaskUpdate {
	for (id<ChocrotaryTaskObserver> observer in tasksObservers) {
		[observer tasksWereUpdated:self];
	}
}

-(void) tasksWereUpdated:(ChocrotarySecretary *)secretary {
	[self notifyTaskUpdate];
}
-(void) projectsWereUpdated:(ChocrotarySecretary *)secretary {
	[self notifyProjectUpdate];
}

@end
