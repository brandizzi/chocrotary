//
//  TestChocrotaryProject.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryProject.h"
#import <secretary/project.h>
#import "ChocrotaryProject.h"
#import "ChocrotaryTask.h"

@implementation TestChocrotaryProject

-(void) testZero {
	Project *wrapped = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrapped];
	STAssertEquals([project wrappedProject], wrapped, @"Should be the same");
	STAssertEqualObjects([project name], @"Project", @"Should be given name");
	STAssertEquals([project countTasks], 0L, @"Should have no task");
}
-(void) testChangeName {
	Project *wrapped = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrapped];
	STAssertEqualObjects([project name], @"Project", @"Should be given name");
	
	[project setName:@"Chocrotary"];
	STAssertEqualObjects([project name], @"Chocrotary", @"Should be given name");
	STAssertEquals(strcmp(project_get_name(wrapped), "Chocrotary"), 0, @"Should change the name");
	
	project_set_name(wrapped, "libsecretary");
	STAssertEqualObjects([project name], @"libsecretary", @"Should be given name");
				   
}
-(void) testAddRemoveTask {
	Task *wrappedTask1 = task_new(0, "Create ChocrotaryProject wrapper class"),
		 *wrappedTask2 = task_new(1, "Use ChocrotaryProject elsewhere");
	ChocrotaryTask *task1 = [ChocrotaryTask taskWithTaskStruct:wrappedTask1],
				   *task2 = [ChocrotaryTask taskWithTaskStruct:wrappedTask2];
	
	Project *wrappedProject = project_new("Project");
	ChocrotaryProject *project = [ChocrotaryProject projectWithProjectStruct:wrappedProject];
	STAssertEquals([project countTasks], 0L, @"Should have no task");
	STAssertNil([project getNthTask:0], @"Should return nil");
	
	[project addTask:task1];
	STAssertEquals([project countTasks], 1L, @"Should have a task");
	STAssertEqualObjects([project getNthTask:0], task1, @"Should return the task");
	STAssertEquals(project_count_task(wrappedProject), 1, @"Should have a task");
	STAssertEquals(project_get_nth_task(wrappedProject, 0), wrappedTask1, @"Should have this task");
	
	project_add(wrappedProject, wrappedTask2);
	STAssertEquals([project countTasks], 2L, @"Should have two tasks");
	STAssertEqualObjects([project getNthTask:1], task2, @"Should return the snd task");
	
	[project removeTask:task1];
	STAssertEquals([project countTasks], 1L, @"Should have a task");
	STAssertEqualObjects([project getNthTask:0], task2, @"Should return the task");
	STAssertEquals(project_count_task(wrappedProject), 1, @"Should have a task");
	STAssertEquals(project_get_nth_task(wrappedProject, 0), wrappedTask2, @"Should have this task");
	
	project_remove(wrappedProject, wrappedTask2);
	STAssertEquals([project countTasks], 0L, @"Should have no task");
	STAssertNil([project getNthTask:0], @"Should return nil");
}

@end
