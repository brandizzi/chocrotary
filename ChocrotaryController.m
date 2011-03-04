//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"

@implementation ChocrotaryController

@synthesize tableView;

-(id)init {
	notebook = notebook_new("/Users/brandizzi/Documents/software/secretary/Chocrotary/secretary.notebook");
	secretary = notebook_get_secretary(notebook);
	NSLog(@"Controller done");
	return self;
	
}

-(Secretary*)getSecretary {
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
	[tableView reloadData];
	NSInteger lastRow = [tableView numberOfRows]-1;
	[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:lastRow] byExtendingSelection:NO];
	[tableView editColumn:1 row:lastRow withEvent:nil select:YES];
}

-(IBAction) removeTask:(id)sender {
	NSIndexSet* indexes = [tableView selectedRowIndexes];
	NSInteger index = [indexes firstIndex];
	while (index != NSNotFound) {
		Task *task = secretary_get_nth_task(secretary, index);
		secretary_delete_task(secretary, task);
		index = [indexes indexGreaterThanIndex:index];
	}
	[tableView reloadData];
}

@end
