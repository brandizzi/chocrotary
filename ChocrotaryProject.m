//
//  ChocrotaryProject.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
	return project_count_tasks(project);
}

-(ChocrotaryTask*) getNthTask:(NSInteger) index {
	if (index < project_count_tasks(project)) {
		Task *task = project_get_nth_task(project, index);
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
