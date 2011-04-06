//
//  ChocrotaryInboxTableDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 14/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryInboxTableViewDataSource.h"
#import "ChocrotaryController.h"
#import "ChocrotarySecretaryInboxView.h"

@implementation ChocrotaryInboxTableViewDataSource

@synthesize controller;

- (id) initWithController:(ChocrotaryController*) c {
	[super init];
	controller = c;
	return self;
}

-(ChocrotarySecretaryView*) secretaryView {
	return [[ChocrotarySecretaryInboxView alloc] initWithChocrotarySecretary:[controller secretary]];
}

@end
