//
//  ChocrotarySecretaryScheduledForTodayView.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotarySecretaryPerspective.h"

@interface ChocrotarySecretaryScheduledForTodayPerspective : ChocrotarySecretaryPerspective {

}

- (NSInteger) countTasks;
- (ChocrotaryTask *) getNthTask:(NSInteger) n;
- (void) addTask;
- (void) archiveAllDoneTasks;
@end
