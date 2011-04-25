//
//  ChocrotaryTodayTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryTodayTableViewDataSource.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"


@implementation ChocrotaryTodayTableViewDataSource

@synthesize controller;

- (id) initWithController:(ChocrotaryController*) c {
	[super init];
	controller = c;
	return self;
}

- (ChocrotarySecretaryPerspective*) secretaryPerspective {
	return [[ChocrotarySecretaryScheduledForTodayPerspective alloc] initWithChocrotarySecretary:[controller secretary]];
}

@end
