//
//  ChocrotaryNotebook.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/notebook.h>
#import <ChocrotarySecretary.h>

@interface ChocrotaryNotebook : NSObject {
	Notebook *notebook;
	ChocrotarySecretary *secretary;
}

-(id) init;
-(ChocrotarySecretary*) getSecretary;
-(void)save;

@end
