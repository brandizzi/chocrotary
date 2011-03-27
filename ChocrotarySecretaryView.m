//
//  ChocrotarySecretaryView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryView.h"


@implementation ChocrotarySecretaryView

@synthesize secretary;

- (id) initWithChocrotarySecretary: (ChocrotarySecretary*) secretary {
	self->secretary = secretary;
	return self;
}

@end
