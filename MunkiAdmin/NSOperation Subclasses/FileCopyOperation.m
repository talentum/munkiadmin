//
//  FileCopyOperation.m
//  MunkiAdmin
//
//  Created by Juutilainen Hannes on 27.10.2011.
//

#import "FileCopyOperation.h"

@implementation FileCopyOperation
@synthesize currentJobDescription;
@synthesize fileName;
@synthesize sourceURL;
@synthesize targetURL;
@synthesize delegate;

- (NSUserDefaults *)defaults
{
	return [NSUserDefaults standardUserDefaults];
}

+ (id)fileCopySourceURL:(NSURL *)src toTargetURL:(NSURL *)target
{
	return [[[self alloc] initWithSourceURL:src targetURL:target] autorelease];
}

- (id)initWithSourceURL:(NSURL *)src targetURL:(NSURL *)target {
	if ((self = [super init])) {
		if ([self.defaults boolForKey:@"debug"]) NSLog(@"Initializing manifest operation");
		self.sourceURL = src;
        self.targetURL = target;
		self.fileName = [self.sourceURL lastPathComponent];
		self.currentJobDescription = @"Initializing copy operation";
		
	}
	return self;
}

- (void)dealloc {
	[fileName release];
	[currentJobDescription release];
	[sourceURL release];
    [targetURL release];
	[delegate release];
	[super dealloc];
}



-(void)main {
	@try {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSFileManager *fm = [NSFileManager defaultManager];
        //NSFileManager *fm = [[NSFileManager alloc] init];
        [fm setDelegate:self];
        NSError *copyError = nil;
        
        if ([self.defaults boolForKey:@"debug"]) NSLog(@"Copying %@ to %@", self.fileName, [self.targetURL relativePath]);
        
        if ([fm copyItemAtURL:self.sourceURL toURL:self.targetURL error:&copyError]) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Done copying");
        } else {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Copy failed with error: %@",[copyError description]);
        }
		
		[pool release];
	}
	@catch(...) {
		// Do not rethrow exceptions.
	}
}

@end
