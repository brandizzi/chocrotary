//
//  TestChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryController.h"
#import "ChocrotaryController.h"


@implementation TestChocrotaryController

-(void) testUpdateProjectArray {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	[notebook.secretary start:@"A project"];
	[notebook.secretary start:@"Another project"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	STAssertEquals([controller.projectArray count], 2UL, @"Should have two");
	STAssertTrue([controller.projectArray containsObject:@"A project"], @"Should have first project");
	STAssertTrue([controller.projectArray containsObject:@"Another project"],  @"Should have snd project");
	
	[controller addProject:nil];
	
	STAssertEquals([controller.projectArray count], 3UL, @"Should have one more");
	STAssertTrue([controller.projectArray containsObject:@"A project"],  @"Should have first project");
	STAssertTrue([controller.projectArray containsObject:@"Another project"],  @"Should have snd project");
	STAssertTrue([controller.projectArray containsObject:@""],  @"Should have empty project");
	
	remove("fluflufile");
}

@end
