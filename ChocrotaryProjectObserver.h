//
//  ChocrotaryProjectObserver.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 29/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ChocrotarySecretary;

@protocol ChocrotaryProjectObserver

-(void) projectsWereUpdated:(id) objectWithState;

@end
