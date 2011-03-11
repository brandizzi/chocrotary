//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"

@implementation ChocrotaryController

@synthesize taskTableView;

-(id)init {
	notebook = notebook_new("/Users/brandizzi/Documents/software/secretary/Chocrotary/secretary.notebook");
	secretary = notebook_get_secretary(notebook);
	NSLog(@"Controller done");
	return self;
	
}

-(ChocrotarySecretary*)getSecretary {
	return secretary;
}

-(NSInteger) countTasks {
	return secretary_count_task(secretary);
}

-(ChocrotaryTask*) getNthTask:(NSInteger)n {
	return secretary_get_nth_task(secretary, n);
}

-(void) changeDescription:(ChocrotaryTask*) task to:(NSString*) description {
	task_set_description(task, [description UTF8String]);
}

-(void) doIt:(ChocrotaryTask*) task {
	secretary_do(secretary, task);
}
-(void) undo:(ChocrotaryTask*) task {
	secretary_undo(secretary, task);
}

-(void) switchDone:(ChocrotaryTask*) task {
	if (task_is_done(task)) {
		secretary_undo(secretary, task);
	} else {
		secretary_do(secretary, task);
	}
}

-(void)save {
	notebook_save(notebook);
}

-(IBAction) addTask:(id)sender {
	// TODO That is ugly as HELL!
	secretary_appoint(secretary, "");
	[taskTableView reloadData];
	NSInteger lastRow = [taskTableView numberOfRows]-1;
	[taskTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[taskTableView editColumn:1 row:lastRow withEvent:nil select:YES];
}

-(IBAction) removeTask:(id)sender {
	NSIndexSet* indexes = [taskTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound) {
		Task *task = secretary_get_nth_task(secretary, index);
		secretary_delete_task(secretary, task);
		index = [indexes indexGreaterThanIndex:index];
	}
	[taskTableView reloadData];
}

-(IBAction) addProject:(id)sender {
	secretary_start(secretary, "");
	[projectTableView reloadData];
	NSInteger lastRow = [projectTableView numberOfRows]-1;
	[projectTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[projectTableView editColumn:0 row:lastRow withEvent:nil select:YES];
	
}

-(IBAction) removeProject:(id)sender {
	NSIndexSet* indexes = [projectTableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound && index >= 2) {
		ChocrotaryProject *project = secretary_get_nth_project(secretary, index-2);
		secretary_delete_project(secretary, project);
		index = [indexes indexGreaterThanIndex:index];
	}
	[projectTableView reloadData];
}


@end
