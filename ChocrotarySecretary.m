//
//  ChocrotarySecretary.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretary.h"
#import <time.h>


@implementation ChocrotarySecretary

-(ChocrotaryTask*) getCachedOrNewTask:(Task*)task {
	ChocrotaryTask *cached = (ChocrotaryTask *)CFDictionaryGetValue(cachedTaskObjects, task);
	if (cached == nil) {
		cached = [ChocrotaryTask newWithWrappedTask:task];
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
	observers = [NSMutableSet new];
	return self;
}

-(ChocrotaryTask*) appoint:(NSString*) description {
	Task *task = secretary_appoint(secretary, [description UTF8String]);
	return [self getCachedOrNewTask:task];
}

-(NSInteger) countTasks {
	return secretary_count_task(secretary);
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
	secretary_unschedule(secretary, task);
}

-(NSInteger)countScheduledTasks {
	return secretary_count_scheduled(secretary);
}

-(ChocrotaryTask*)getNthScheduledTask:(NSInteger) n {
	Task *task = secretary_get_nth_scheduled(secretary, n);
	return [self getCachedOrNewTask:task];
}

-(NSInteger) countTasksScheduledForToday {
	return secretary_count_scheduled_for_today(secretary);
}

-(ChocrotaryTask*) getNthTaskScheduledForToday:(NSInteger)n {
	Task *task = secretary_get_nth_scheduled_for_today(secretary, n);
	return [self getCachedOrNewTask:task];
}

-(void)doTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_do(secretary, task);
}

-(void)undo:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_undo(secretary, task);
}

-(void)switchDoneStatus: (ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	if (task_is_done(task)) {
		secretary_undo(secretary, task);
	} else {
		secretary_do(secretary, task);
	}
}

-(void) deleteTask:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_delete_task(secretary, task);
}

-(ChocrotaryProject*) start:(NSString*)name {
	return secretary_start(secretary, [name UTF8String]);
}

-(ChocrotaryProject*) getNthProject:(NSInteger)n {
	return secretary_get_nth_project(secretary, n);
}

-(ChocrotaryProject*) getProjectByName:(NSString*) projectName {
	return secretary_get_project(secretary, [projectName UTF8String]);
}

-(NSInteger) countProjects {
	return secretary_count_project(secretary);
}

-(void) deleteProject:(ChocrotaryProject*) project {
	secretary_delete_project(secretary, project);
}

-(void) move:(ChocrotaryTask*) aTask to:(ChocrotaryProject*) project {
	Task *task = [aTask wrappedTask];
	secretary_move(secretary, task, project);
}

-(void)moveTaskToInbox:(ChocrotaryTask*) aTask {
	Task *task = [aTask wrappedTask];
	secretary_move_to_inbox(secretary, task);
}


-(NSInteger) countInboxTasks {
	return secretary_count_inbox(secretary);
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

-(void)attachObserver:(id<ChocrotarySecretaryObserver>)observer {
	[observers addObject:observer];
}
-(void)detachObserver:(id<ChocrotarySecretaryObserver>)observer {
	[observers removeObject:observer];
}

-(void)notifyProjectsUpdate {
	for (id<ChocrotarySecretaryObserver> observer in observers) {
		[observer projectsWereUpdated:self];
	}
}
-(void)notifyTasksUpdate {
	for (id<ChocrotarySecretaryObserver> observer in observers) {
		[observer tasksWereUpdated:self];
	}
}

@end
