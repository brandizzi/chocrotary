//
//  ChocrotarySecretaryScheduledView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryScheduledPerspective.h"


@implementation ChocrotarySecretaryScheduledPerspective
- (NSInteger) countTasks {
	return [secretary countScheduledTasks];
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	return [secretary getNthScheduledTask:n];
}
- (void) addTask {
	ChocrotaryTask *task = [secretary createTask:@""];
	[task scheduleFor:[NSDate date]];
}
@end
