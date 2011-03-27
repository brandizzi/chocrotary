//
//  ChocrotaryInboxTableDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 14/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ChocrotaryTableViewDataSource.h"
#import "ChocrotaryController.h"
#import "ChocrotaryBaseTableViewDataSource.h"
#import "ChocrotarySecretaryView.h"

@interface ChocrotaryInboxTableViewDataSource : ChocrotaryBaseTableViewDataSource <ChocrotaryTableViewDataSource> {	
	IBOutlet ChocrotaryController *controller;
}

@property (readonly) ChocrotaryController *controller;

- (id) initWithController:(ChocrotaryController*) c;
- (ChocrotarySecretaryView*) secretaryView;

@end
