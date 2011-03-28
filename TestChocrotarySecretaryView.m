//
//  TestChocrotarySecretaryView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretaryView.h"
#import "ChocrotarySecretary.h"
#import "ChocrotarySecretaryView.h"
#import "ChocrotarySecretaryInboxView.h"
#import "ChocrotarySecretaryScheduledView.h"
#import "ChocrotarySecretaryScheduledForTodayView.h"
#import "ChocrotarySecretaryProjectView.h"

@implementation TestChocrotarySecretaryView
-(void) testInboxView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	
	ChocrotarySecretaryView *inboxView = [[ChocrotarySecretaryInboxView alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([inboxView countTasks], 1L, @"Should have one task");
	STAssertEquals([inboxView getNthTask:0], task3, @"Should be task 3, which is neither associated to project nor scheduled");
}
-(void) testScheduledView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryView *scheduledView = [[ChocrotarySecretaryScheduledView alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([scheduledView countTasks], 2L, @"Should have two task scheduled");
	STAssertEquals([scheduledView getNthTask:0], task2, @"Should be task 2");
	STAssertEquals([scheduledView getNthTask:1], task3, @"Should be task 3");

}
-(void) testTodayView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryView *todayView = [[ChocrotarySecretaryScheduledForTodayView alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([todayView countTasks], 1L, @"Should have one task scheduled for today");
	STAssertEquals([todayView getNthTask:0], task2, @"Should be task 2");
	
}

-(void) testProjectView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project1];
	ChocrotaryProject *project2 = [secretary start:@"libsecretary"];
	[secretary move:task2 to:project2];
	
	ChocrotarySecretaryView *projectView = [[ChocrotarySecretaryProjectView alloc] 
											initWithChocrotarySecretary:secretary
											forProject:project1];
	STAssertEquals([projectView countTasks], 1L, @"Should have one task in project 1");
	STAssertEquals([projectView getNthTask:0], task1, @"Should be task 1");	
	projectView = [[ChocrotarySecretaryProjectView alloc] 
				   initWithChocrotarySecretary:secretary
				   forProject:project2];
	STAssertEquals([projectView countTasks], 1L, @"Should have one task in project 2");
	STAssertEquals([projectView getNthTask:0], task2, @"Should be task 2");
}
@end
