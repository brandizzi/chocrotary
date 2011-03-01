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
	return self;
	
}

-(Secretary*)getSecretary {
	return secretary;
}

-(void)save {
	notebook_save(notebook);
}

@end
