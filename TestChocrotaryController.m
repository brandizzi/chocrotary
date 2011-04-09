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

-(void) testUpdateProjectsMenu {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	[notebook.secretary start:@"A project"];
	[notebook.secretary start:@"Another project"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSMenu *menu = controller.projectsMenu;
	STAssertNotNil(menu, @"should have menu");
	
	STAssertEquals([menu numberOfItems], 3L, @"Should have three");
	STAssertEqualObjects([[menu itemAtIndex:0] title], @"", @"Should have empty string");
	STAssertEquals([[menu itemAtIndex:0] tag], ChocrotaryControllerNoProject, @"Should point to notthing");
	STAssertEqualObjects([[menu itemAtIndex:1] title], @"A project", @"Should have first project");
	STAssertEquals([[menu itemAtIndex:1] tag], 0L, @"Should be index of project 1");
	STAssertEqualObjects([[menu itemAtIndex:2] title], @"Another project",  @"Should have snd project");
	STAssertEquals([[menu itemAtIndex:2] tag], 1L, @"Should be index of projct 2");
	
	[controller addProject:nil];
	
	STAssertEquals([menu numberOfItems], 4L, @"Should have one more");
	STAssertEqualObjects([[menu itemAtIndex:0] title], @"", @"Should have empty string");
	STAssertEquals([[menu itemAtIndex:0] tag], ChocrotaryControllerNoProject, @"Should point to notthing");
	STAssertEqualObjects([[menu itemAtIndex:1] title], @"A project", @"Should have first project");
	STAssertEquals([[menu itemAtIndex:1] tag], 0L, @"Should be index of project 1");
	STAssertEqualObjects([[menu itemAtIndex:2] title], @"Another project",  @"Should have snd project");
	STAssertEquals([[menu itemAtIndex:2] tag], 1L, @"Should be index of projct 2");
	STAssertEqualObjects([[menu itemAtIndex:3] title], @"",  @"Should have title of new project (still empty)");
	STAssertEquals([[menu itemAtIndex:3] tag], 2L, @"Should be index of new project");
	
	remove("fluflufile");
}

@end
