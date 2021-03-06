//
//  GETOperation.m
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "GETOperation.h"

@interface GETOperation()

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation GETOperation


- (instancetype) initWithClient: (APIClient *)client
{
    if ((self = [super init]))
    {
        _client = client;
    }
    
    return self;
}

- (void)main
{
    
}

- (void) addOpDependency:(NSOperation *)op
{
    [self addDependency:op];
    _dependentOperations = [self.dependentOperations arrayByAddingObject:op];
}


- (void)didFinishExecuting
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _isFinished = YES;
    _isExecuting = NO;

    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)didBeginExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    
    _isExecuting = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)isReadyToBeginExecuting
{
    [self willChangeValueForKey:@"isReady"];
    
    _isReady = YES;
    
    [self didChangeValueForKey:@"isReady"];
}



@end
