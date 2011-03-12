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
-(id)init {
	secretary = secretary_new();
	return self;
}

-(id)initWithSecretary:(Secretary*) ready {
	secretary = ready;
	return self;
}

-(ChocrotaryTask*) appoint:(NSString*) description {
	return secretary_appoint(secretary, [description UTF8String]);
}

-(NSInteger) countTasks {
	return secretary_count_task(secretary);
}

-(ChocrotaryTask*) getNthTask:(NSInteger)n {
	return secretary_get_nth_task(secretary, n);
}

-(void)schedule:(ChocrotaryTask*)task to:(NSDate*) date {
	time_t time = [date timeIntervalSince1970];
	secretary_schedule(secretary, task, *localtime(&time));
}

-(void)unschedule:(ChocrotaryTask*)task {
	secretary_unschedule(secretary, task);
}

-(void)doTask:(ChocrotaryTask*) task {
	secretary_do(secretary, task);
}

-(void)undo:(ChocrotaryTask*) task {
	secretary_undo(secretary, task);
}

-(void)switchDoneStatus: (ChocrotaryTask*) task; {
	if (task_is_done(task)) {
		secretary_undo(secretary, task);
	} else {
		secretary_do(secretary, task);
	}
}

-(void) deleteTask:(ChocrotaryTask*) task {
	secretary_delete_task(secretary, task);
}

-(ChocrotaryProject*) start:(NSString*)name {
	return secretary_start(secretary, [name UTF8String]);
}

-(ChocrotaryProject*) getNthProject:(NSInteger)n {
	return secretary_get_nth_project(secretary, n);
}

-(NSInteger) countProjects {
	return secretary_count_project(secretary);
}

-(void) deleteProject:(ChocrotaryProject*) project {
	secretary_delete_project(secretary, project);
}

@end
