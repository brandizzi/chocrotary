//
//  ChocrotaryController.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/notebook.h>

@interface ChocrotaryController : NSObject {
	Notebook *notebook;
	Secretary *secretary;
}

-(id)init;
-(Secretary*) getSecretary;
-(void)save;

@end
