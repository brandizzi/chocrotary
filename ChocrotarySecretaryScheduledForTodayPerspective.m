//
//  ChocrotarySecretaryScheduledForTodayView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryScheduledForTodayPerspective.h"


@implementation ChocrotarySecretaryScheduledForTodayPerspective
- (NSInteger) countTasks {
	return [secretary countTasksScheduledForToday];
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	return [secretary getNthTaskScheduledForToday:n];
}
@end
