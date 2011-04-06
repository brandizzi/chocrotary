//
//  ChocrotaryNotebook.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryNotebook.h"


@implementation ChocrotaryNotebook 

@synthesize secretary;

-(id) init {
	NSString *executableName = [[[NSBundle mainBundle] infoDictionary] 
								objectForKey:@"CFBundleExecutable"];
	NSArray* paths = NSSearchPathForDirectoriesInDomains(
														 NSApplicationSupportDirectory,
														 NSUserDomainMask,
														 YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDirectory, exists;
	exists = [manager fileExistsAtPath:path isDirectory:&isDirectory];
	if (!exists || isDirectory) {
		if (!isDirectory) {
			[manager removeItemAtPath:path error:NULL];
		}
		[manager createDirectoryAtPath:path withIntermediateDirectories:YES 
							attributes:nil error:NULL];
	}
	
	notebook = notebook_new([[path stringByAppendingPathComponent:@"secretary.notebook"] UTF8String]);
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}

-(id) initWithFile:(NSString*)filename {
	notebook = notebook_new([filename UTF8String]);
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}
-(ChocrotarySecretary*) getSecretary {
	return secretary;
}
-(void)save {
	notebook_save(notebook);
}

@end
