//
//  ChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryController.h"

@implementation ChocrotaryController

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

@end
