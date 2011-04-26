//
//  TestChocrotarySecretaryPerspective.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretaryPerspective.h"
#import "ChocrotarySecretary.h"
#import "ChocrotarySecretaryPerspective.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"

@implementation TestChocrotarySecretaryPerspective
-(void) testInboxPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	
	ChocrotarySecretaryPerspective *inboxPerspective = [[ChocrotarySecretaryInboxPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([inboxPerspective countTasks], 1L, @"Should have one task");
	STAssertEquals([inboxPerspective getNthTask:0], task3, @"Should be task 3, which is neither associated to project nor scheduled");
}
-(void) testScheduledPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryPerspective *scheduledPerspective = [[ChocrotarySecretaryScheduledPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([scheduledPerspective countTasks], 2L, @"Should have two task scheduled");
	STAssertEquals([scheduledPerspective getNthTask:0], task2, @"Should be task 2");
	STAssertEquals([scheduledPerspective getNthTask:1], task3, @"Should be task 3");

}
-(void) testTodayPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryPerspective *todayPerspective = [[ChocrotarySecretaryScheduledForTodayPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([todayPerspective countTasks], 1L, @"Should have one task scheduled for today");
	STAssertEquals([todayPerspective getNthTask:0], task2, @"Should be task 2");
	
}

-(void) testProjectPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project1];
	ChocrotaryProject *project2 = [secretary start:@"libsecretary"];
	[secretary move:task2 to:project2];
	
	ChocrotarySecretaryPerspective *projectPerspective = [[ChocrotarySecretaryProjectPerspective alloc] 
											initWithChocrotarySecretary:secretary
											forProject:project1];
	STAssertEquals([projectPerspective countTasks], 1L, @"Should have one task in project 1");
	STAssertEqualObjects([projectPerspective getNthTask:0], task1, @"Should be task 1");	
	projectPerspective = [[ChocrotarySecretaryProjectPerspective alloc] 
				   initWithChocrotarySecretary:secretary
				   forProject:project2];
	STAssertEquals([projectPerspective countTasks], 1L, @"Should have one task in project 2");
	STAssertEqualObjects([projectPerspective getNthTask:0], task2, @"Should be task 2");
}
@end
