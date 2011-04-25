//
//  ChocrotaryScheduledTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryScheduledTableViewDataSource.h"
#import "ChocrotarySecretaryScheduledPerspective.h"


@implementation ChocrotaryScheduledTableViewDataSource

@synthesize controller;

- (id) initWithController:(ChocrotaryController*) c {
	[super init];
	controller = c;
	return self;
}

- (ChocrotarySecretaryPerspective*) secretaryPerspective {
	return [[ChocrotarySecretaryScheduledPerspective alloc] initWithChocrotarySecretary:[controller secretary]];
}

@end
