//
//  TestChocrotaryTask.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTask.h"
#import "ChocrotaryTask.h"
#import <secretary/secretary.h>

@implementation TestChocrotaryTask

-(void) testZero {
	Task *oldTask = task_new(1, "New task");
	ChocrotaryTask *task = [ChocrotaryTask newWithWrappedTask:oldTask];
	STAssertEqualObjects([task description], @"New task", @"Should have the given description");
	STAssertEquals([task wrappedTask], oldTask, @"Should be the same task");
	
	STAssertFalse([task done], @"Should not be done");
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");
	STAssertEquals([task project], (ChocrotaryProject*)NULL, @"Should not have project");
}

-(void) testChangeDescription {
	Task *oldTask = task_new(1, "New task");
	ChocrotaryTask *task = [ChocrotaryTask newWithWrappedTask:oldTask];
	STAssertEqualObjects([task description], @"New task", @"Should have the given description");
	
	[task setDescription:@"Same new task"];
	STAssertEquals(strcmp(task_get_description(oldTask), "Same new task"), 0, @"Should transfer the description to oldTask");	
}

-(void) testDo {
	Task *oldTask = task_new(1, "New task");
	ChocrotaryTask *task = [ChocrotaryTask newWithWrappedTask:oldTask];
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
	Task *oldTask = task_new(1, "New task");
	ChocrotaryTask *task = [ChocrotaryTask newWithWrappedTask:oldTask];
	
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");
	struct tm date;
	time_t timedate = time(NULL);
	date = *localtime(&timedate);
	task_schedule(oldTask, date);
	STAssertTrue([task isScheduled], @"Should be scheduled");
	NSDate *scheduledDate = [task scheduledFor];
	STAssertEqualObjects(scheduledDate, [NSDate dateWithTimeIntervalSince1970:timedate],
						 @"Should be today");
	task_unschedule(oldTask);
	STAssertFalse([task isScheduled], @"Should not be scheduled");
	STAssertNil([task scheduledFor], @"Should not return scheduled date");

	STAssertFalse(task_is_scheduled(oldTask), @"Should not be scheduled");
	[task scheduleFor:scheduledDate];
	STAssertTrue(task_is_scheduled(oldTask), @"Should be scheduled");
	date = task_get_scheduled_date(oldTask);
	STAssertEquals(mktime(&date), timedate, @"Should be today");
	[task unschedule];
	STAssertFalse(task_is_scheduled(oldTask), @"Should not be scheduled");
}

-(void) testProject {
	Task *oldTask = task_new(1, "New task");
	ChocrotaryTask *task = [ChocrotaryTask newWithWrappedTask:oldTask];

	STAssertEquals([task project], (ChocrotaryProject*)NULL, @"Should not have project");	
	ChocrotaryProject *project = project_new("My project");
	project_add(project, oldTask);
	STAssertEquals([task project], project, @"Should have project");
	project_remove(project, oldTask);
	STAssertEquals([task project], (ChocrotaryProject*)NULL, @"Should not have project");
}

@end
