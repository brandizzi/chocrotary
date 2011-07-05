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
//  ChocrotaryProject.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 28/04/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryProject.h"


@implementation ChocrotaryProject

-(ChocrotaryTask*) getCachedOrNewTask:(Task*)task {
	ChocrotaryTask *cached = (ChocrotaryTask *)CFDictionaryGetValue(cachedTaskObjects, task);
	if (cached == nil) {
		cached = [ChocrotaryTask taskWithTaskStruct:task];
		CFDictionaryAddValue(cachedTaskObjects, task, cached);
	}
	return cached;
}

-(id)initWithProjectStruct:(Project*) aProject {
	[super init];
	cachedTaskObjects = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	project = aProject;
	observers = [NSMutableSet new];
	return self;
}

+(id)projectWithProjectStruct:(Project*) aProject {
	return [[ChocrotaryProject alloc] initWithProjectStruct:aProject];
}

-(Project*) wrappedProject {
	return project;
}

-(NSString*) name {
	return [NSString stringWithUTF8String:project_get_name(project)];
}

-(void)setName:(NSString*) aName {
	project_set_name(project, [aName UTF8String]);
	[self notifyProjectObservers];
}

-(NSInteger) countTasks {
	return project_count_tasks(project, false);
}

-(ChocrotaryTask*) getNthTask:(NSInteger) index {
	if (index < project_count_tasks(project, false)) {
		Task *task = project_get_nth_task(project, index, false);
		return [self getCachedOrNewTask:task];
	}
	return nil;
}

-(void) addTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	project_add_task(project, task);
	CFDictionaryAddValue(cachedTaskObjects, task, aTask);
	[aTask notifyTasksObservers];
	[self notifyProjectObservers];
}

-(void) removeTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	project_remove_task(project, task);
	CFDictionaryRemoveValue(cachedTaskObjects, task);
	[aTask notifyTasksObservers];
	[self notifyProjectObservers];
}

-(void) archiveDoneTasks {
	project_archive_tasks(project);
#warning should report to observers
}

-(void) attachProjectObserver:(id<ChocrotaryProjectObserver>) observer {
	[observers addObject:observer];
}
-(void) detachProjectObserver:(id<ChocrotaryProjectObserver>) observer {
	[observers removeObject:observer];
}
-(void) notifyProjectObservers {
	for (id<ChocrotaryProjectObserver> observer in observers) {
		[observer projectsWereUpdated:self];
	}
}

-(BOOL)isEqual:(id)object {
	if ([object respondsToSelector:@selector(wrappedProject)]) {
		return project == [object wrappedProject];
	}
	return NO;
}
-(NSInteger)hash {
	return (NSInteger)project;
}

@end
