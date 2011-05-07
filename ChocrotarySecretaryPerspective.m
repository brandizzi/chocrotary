//
//  ChocrotarySecretaryView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryPerspective.h"


@implementation ChocrotarySecretaryPerspective

@synthesize secretary, project;

- (id) initWithChocrotarySecretary: (ChocrotarySecretary*) s {
	self->secretary = s;
	return self;
}

+ (id) newWithSecretary: (ChocrotarySecretary*) secretary {
	return [[self alloc] initWithChocrotarySecretary:secretary];
}

- (NSInteger) countTasks {
	[self doesNotRecognizeSelector:_cmd];
	return 0L;
}

- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void) addTask {
	[self doesNotRecognizeSelector:_cmd];
}

@end
