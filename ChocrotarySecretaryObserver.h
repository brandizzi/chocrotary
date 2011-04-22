//
//  ChocrotarySecretaryObserver.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 21/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ChocrotarySecretary;

@protocol ChocrotarySecretaryObserver

-(void) projectsWereUpdated:(ChocrotarySecretary*) secretary;
-(void) tasksWereUpdated:(ChocrotarySecretary*) secretary;


@end
