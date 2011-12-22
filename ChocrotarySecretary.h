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
//  ChocrotarySecretary.h
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import <Cocoa/Cocoa.h>
#import <secretary/secretary.h>
#import "ChocrotaryTask.h"

#import "ChocrotaryTaskObserver.h"
#import "ChocrotaryProjectObserver.h"

@interface ChocrotarySecretary : NSObject <ChocrotaryTaskObserver, ChocrotaryProjectObserver> {
	Secretary *secretary;
	NSMutableSet *tasksObservers, *projectsObservers;
	CFMutableDictionaryRef cachedObjects;
}
-(id)init;
-(id)initWithSecretary:(Secretary*) ready;

-(ChocrotaryTask*) createTask:(NSString*) description;
-(NSInteger) countTasks;
-(ChocrotaryTask*) getNthTask:(NSInteger)n;
-(void) deleteTask:(ChocrotaryTask*) task;

-(NSInteger)countScheduledTasks;
-(ChocrotaryTask*)getNthScheduledTask:(NSInteger) n;

-(NSInteger) countTasksScheduledForToday;
-(ChocrotaryTask*) getNthTaskScheduledForToday:(NSInteger)n;

-(ChocrotaryProject*) createProject:(NSString*)name;
-(NSInteger) countProjects;
-(ChocrotaryProject*) getNthProject:(NSInteger)n;
-(ChocrotaryProject*) getProjectByName:(NSString*) projectName;
-(void) deleteProject:(ChocrotaryProject*) project;

-(NSInteger) countInboxTasks;
-(ChocrotaryTask*) getNthInboxTask:(NSInteger) n;

-(void) archiveDoneInboxTasks;
-(void) archiveDoneScheduledTasks;
-(void) archiveDoneTasksScheduledForToday;

// For processing tasks
-(void) scheduleTask:(ChocrotaryTask*) task forDate:(NSDate*)date;
-(void) unscheduleTask:(ChocrotaryTask*) task;
-(void) moveTask:(ChocrotaryTask*) task toProject:(ChocrotaryProject*) project;
-(void) removeTaskFromProject:(ChocrotaryTask*) task;


-(void) archiveTask:(ChocrotaryTask*) task;
-(void) archiveTasksFromProject:(ChocrotaryProject*)project;


// For retrieving a ChocrotaryTask wrapping a Task
-(ChocrotaryTask*)wrapperForTask:(Task*) aTask;

// Publisher interface: the methods for reporting to observers that
// the secretary has changed its state.

-(void)attachTaskObserver:(id<ChocrotaryTaskObserver>)observer;
-(void)detachTasksObserver:(id<ChocrotaryTaskObserver>)observer;
-(void)attachProjectObserver:(id<ChocrotaryProjectObserver>)observer;
-(void)detachProjectsObserver:(id<ChocrotaryProjectObserver>)observer;
-(void)notifyProjectUpdate;
-(void)notifyTaskUpdate;

// Observer interface: it is through this interface that secretary
// knows when a task/project updates itself and then reports it
// to Secretary's own observers.
-(void) tasksWereUpdated:(ChocrotarySecretary*) secretary;
-(void) projectsWereUpdated:(ChocrotarySecretary*) secretary;

-(void)release;
@end
