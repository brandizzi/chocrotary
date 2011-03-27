//
//  ChocrotaryTodayTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryBaseTableViewDataSource.h"
#import "ChocrotarySecretaryView.h"

@interface ChocrotaryTodayTableViewDataSource : ChocrotaryBaseTableViewDataSource <ChocrotaryTableViewDataSource> {
	IBOutlet ChocrotaryController *controller;
}

@property (readonly) ChocrotaryController *controller;

- (id) initWithController:(ChocrotaryController*) c;
- (ChocrotarySecretaryView*) secretaryView;

@end
