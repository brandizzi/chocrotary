//
//  ChocrotaryProject.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/project.h>
#import "ChocrotarySecretary.h"
#import "ChocrotaryTask.h"

@interface ChocrotaryProject : NSObject {
	ChocrotarySecretary *secretary;
	Project *project;
	CFMutableDictionaryRef cachedTaskObjects;
}

-(id)initWithProjectStruct:(Project*) aProject;
+(id)projectWithProjectStruct:(Project*) aProject;
-(Project*) wrappedProject;

-(NSString*) name;
-(void)setName:(NSString*) aName;

-(NSInteger) countTasks;
-(ChocrotaryTask*) getNthTask:(NSInteger) index;
-(void) addTask:(ChocrotaryTask*) aTask;
-(void) removeTask:(ChocrotaryTask*) aTask;

// Some overwritten
-(BOOL)isEqual:(id)object;
-(NSInteger)hash;
@end
