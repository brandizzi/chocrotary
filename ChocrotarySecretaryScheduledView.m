//
//  ChocrotarySecretaryScheduledView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryScheduledView.h"


@implementation ChocrotarySecretaryScheduledView
- (NSInteger) countTasks {
	return [secretary countScheduledTasks];
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	return [secretary getNthScheduledTask:n];
}
@end
