//
//  ChocrotarySecretaryView.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotarySecretary.h"

@interface ChocrotarySecretaryView : NSObject {
	ChocrotarySecretary *secretary;
}

@property (readonly) ChocrotarySecretary *secretary;

- (id) initWithChocrotarySecretary: (ChocrotarySecretary*) secretary;
- (NSInteger) countTasks;
- (ChocrotaryTask *) getNthTask:(NSInteger) n;
@end
