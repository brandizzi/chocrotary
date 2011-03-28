//
//  ChocrotaryNotebook.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryNotebook.h"


@implementation ChocrotaryNotebook 

@synthesize secretary;

-(id) init {
	notebook = notebook_new("/Users/brandizzi/Documents/software/secretary/Chocrotary/secretary.notebook");
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}

-(id) initWithFile:(NSString*)filename {
	notebook = notebook_new([filename UTF8String]);
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}
-(ChocrotarySecretary*) getSecretary {
	return secretary;
}
-(void)save {
	notebook_save(notebook);
}

@end
