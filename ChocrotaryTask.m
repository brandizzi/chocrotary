//
//  ChocrotaryTask.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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


-(BOOL) isScheduled {
	return task_is_scheduled(task);
}

-(NSDate*) scheduledFor {
	if (task_is_scheduled(task)) {
		struct tm structdate = task_get_scheduled_date(task);
		time_t secondsSinceEpoch = mktime(&structdate);
		return [NSDate dateWithTimeIntervalSince1970:secondsSinceEpoch];
	} else {
		return nil;
	}
}

-(void) scheduleFor:(NSDate*) aDate {
	time_t secondsSinceEpoch = [aDate timeIntervalSince1970];
	struct tm structdate = *localtime(&secondsSinceEpoch);
	task_schedule(task, structdate);
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
