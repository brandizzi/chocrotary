//
//  ChocrotarySecretaryProjectView.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotarySecretaryPerspective.h"
#import "ChocrotarySecretary.h"

@interface ChocrotarySecretaryProjectPerspective : ChocrotarySecretaryPerspective {
}


-(id) initWithChocrotarySecretary:(ChocrotarySecretary*) secretary 
					   forProject: (ChocrotaryProject*) project;
- (NSInteger) countTasks;
- (ChocrotaryTask *) getNthTask:(NSInteger) n;
@end
