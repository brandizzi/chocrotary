//
//  ChocrotarySecretary.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretary.h"
#import <time.h>
#import "ChocrotaryProject.h"


@implementation ChocrotarySecretary

-(ChocrotaryTask*) getCachedOrNewTask:(Task*)task {
	ChocrotaryTask *cached = (ChocrotaryTask *)CFDictionaryGetValue(cachedTaskObjects, task);
	if (cached == nil) {
		cached = [ChocrotaryTask taskWithTaskStruct:task];
		CFDictionaryAddValue(cachedTaskObjects, task, cached);
	}
	return cached;
}

-(id)init {
	return [self initWithSecretary:secretary_new()];
}

-(id)initWithSecretary:(Secretary*) ready {
	[super init];
	secretary = ready;
	cachedTaskObjects = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	// Observers containers
	tasksObservers = [NSMutableSet new];
	projectsObservers = [NSMutableSet new];
	return self;
}

-(ChocrotaryTask*) appoint:(NSString*) description {
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

-(void)schedule:(ChocrotaryTask*)aTask to:(NSDate*) date {
	Task *task = [aTask wrappedTask];
	time_t time = [date timeIntervalSince1970];
	secretary_schedule(secretary, task, *localtime(&time));
}

-(void)unschedule:(ChocrotaryTask*)aTask {
	Task *task = [aTask wrappedTask];
	secretary_unschedule_task(secretary, task);
}

-(NSInteger)countScheduledTasks {
	return secretary_count_tasks_scheduled(secretary);
}

-(ChocrotaryTask*)getNthScheduledTask:(NSInteger) n {
	Task *task = secretary_get_nth_task_scheduled(secretary, n);
	return [self getCachedOrNewTask:task];
}

-(NSInteger) countTasksScheduledForToday {
	return secretary_count_tasks_scheduled_for_today(secretary);
}

-(ChocrotaryTask*) getNthTaskScheduledForToday:(NSInteger)n {
	Task *task = secretary_get_nth_task_scheduled_for_today(secretary, n);
	return [self getCachedOrNewTask:task];
}

-(void)doTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_mark_task_as_done(secretary, task);
}

-(void)undo:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_unmark_task_as_done(secretary, task);
}

-(void)switchDoneStatus: (ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	if ([aTask done]) {
		secretary_unmark_task_as_done(secretary, task);
	} else {
		secretary_mark_task_as_done(secretary, task);
	}
}

-(void) deleteTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_delete_task(secretary, task);
	CFDictionaryRemoveValue(cachedTaskObjects, task);
}

-(ChocrotaryProject*) start:(NSString*)name {
	Project *project = secretary_create_project(secretary, [name UTF8String]);
	return [ChocrotaryProject projectWithProjectStruct:project];
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

-(void) move:(ChocrotaryTask*) aTask to:(ChocrotaryProject*) aProject {
	Task *task = [aTask wrappedTask];
	Project *project =  [aProject wrappedProject];
	secretary_move_to_project(secretary, task, project);
}

-(void)moveTaskToInbox:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_remove_from_project(secretary, task);
}


-(NSInteger) countInboxTasks {
	return secretary_count_inbox_tasks(secretary);
}

-(ChocrotaryTask*) getNthInboxTask:(NSInteger) n {
	Task *task = secretary_get_nth_inbox_task(secretary, n);
	return [self getCachedOrNewTask:task];

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
}
-(void) projectsWereUpdated:(ChocrotarySecretary *)secretary {
}

@end
