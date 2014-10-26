//
//  NSTimerBlocksKitTest.m
//  BlocksKit Unit Tests
//
//  Contributed by Kai Wu.
//

#import <XCTest/XCTest.h>
#import <BlocksKit/NSTimer+BlocksKit.h>

static const NSTimeInterval BKTimerTestLeniency = 10;
static const NSTimeInterval BKTimerTestInterval = 0.025;

static inline NSTimeInterval Timeout(NSInteger count) {
    return count * BKTimerTestLeniency * BKTimerTestInterval;
}

@interface NSTimerBlocksKitTest : XCTestCase

@end

@implementation NSTimerBlocksKitTest

- (void)commonTestTimerRepeating:(BOOL)repeats expectation:(NSInteger)count
{
    NSString *description = [NSString stringWithFormat:@"Timer x%ld", (long)count];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    const NSTimeInterval timeout = Timeout(count);
    __block NSInteger total = 0;

    NSTimer *timer = [NSTimer bk_timerWithTimeInterval:BKTimerTestInterval block:^(NSTimer *timer) {
        if (++total >= count) {
            [expectation fulfill];
        }
    } repeats:repeats];

    XCTAssertNotNil(timer);

    timer.tolerance = 0;

    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError *__unused err) {
        [timer invalidate];
        XCTAssertEqual(total, count);
    }];
}

- (void)testTimer {
    [self commonTestTimerRepeating:NO expectation:1];
}

- (void)testRepeatedTimer {
    [self commonTestTimerRepeating:YES expectation:5];
}

@end
