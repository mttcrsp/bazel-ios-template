//
//  ASUICollectionViewTests.mm
//  Texture
//
//  Copyright (c) Facebook, Inc. and its affiliates.  All rights reserved.
//  Changes after 4/13/2017 are: Copyright (c) Pinterest, Inc.  All rights reserved.
//  Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "NSInvocation+ASTestHelpers.h"

@interface ASUICollectionViewTests : XCTestCase

@end

@implementation ASUICollectionViewTests

/// Test normal item-affiliated supplementary node
- (void)testNormalTwoIndexSupplementaryElement
{
  [self _testSupplementaryNodeAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] sectionCount:2 expectException:NO];
}

/// If your supp is indexPathForItem:inSection:, the section index must be in bounds
- (void)testThatSupplementariesWithItemIndexesMustBeWithinNormalSections
{
  // Causing exceptions and then catching them were leaving us in an unknown state for subsequent tests.
  // We would end up with EXC_BAD_ACCESS crashes or the following exception:
  // UIView is missing its initial trait collection populated during initialization. This is a serious bug, likely caused by accessing properties or methods on the view before calling a UIView initializer
  // These tests are being silenced so that the other tests can run properly.
  //[self _testSupplementaryNodeAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3] sectionCount:2 expectException:YES];
}

/// If your supp is indexPathWithIndex:, that's OK even if that section is out of bounds!
- (void)testThatSupplementariesWithOneIndexAreOKOutOfSectionBounds
{
  [self _testSupplementaryNodeAtIndexPath:[NSIndexPath indexPathWithIndex:3] sectionCount:2 expectException:NO];
}

- (void)testThatNestedBatchCompletionsAreCalledInOrder
{
  UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
  id layoutMock = [OCMockObject partialMockForObject:layout];

  UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layoutMock];
  id dataSource = [OCMockObject niceMockForProtocol:@protocol(UICollectionViewDataSource)];

  cv.dataSource = dataSource;

  XCTestExpectation *inner0 = [self expectationWithDescription:@"Inner completion 0 is called"];
  XCTestExpectation *inner1 = [self expectationWithDescription:@"Inner completion 1 is called"];
  XCTestExpectation *outer = [self expectationWithDescription:@"Outer completion is called"];

  NSMutableArray<XCTestExpectation *> *completions = [NSMutableArray array];

  [cv performBatchUpdates:^{
    [cv performBatchUpdates:^{

    } completion:^(BOOL finished) {
      [completions addObject:inner0];
      [inner0 fulfill];
    }];
    [cv performBatchUpdates:^{

    } completion:^(BOOL finished) {
      [completions addObject:inner1];
      [inner1 fulfill];
    }];
  } completion:^(BOOL finished) {
    [completions addObject:outer];
    [outer fulfill];
  }];

  [self waitForExpectationsWithTimeout:5 handler:nil];
  XCTAssertEqualObjects(completions, (@[ outer, inner0, inner1 ]), @"Expected completion order to be correct");
}

- (void)_testSupplementaryNodeAtIndexPath:(NSIndexPath *)indexPath sectionCount:(NSInteger)sectionCount expectException:(BOOL)shouldFail
{
  UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"SuppKind" withIndexPath:indexPath];
  attr.frame = CGRectMake(0, 0, 20, 20);
  UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
  id layoutMock = [OCMockObject partialMockForObject:layout];

  [[[[layoutMock expect] ignoringNonObjectArgs] andReturn:@[ attr ]] layoutAttributesForElementsInRect:CGRectZero];
  UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layoutMock];
  [cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"SuppKind" withReuseIdentifier:@"ReuseID"];

  id dataSource = [OCMockObject niceMockForProtocol:@protocol(UICollectionViewDataSource)];
  __block id view = nil;
  [[[dataSource expect] andDo:^(NSInvocation *invocation) {
    NSIndexPath *indexPath = [invocation as_argumentAtIndexAsObject:4];
    view = [cv dequeueReusableSupplementaryViewOfKind:@"SuppKind" withReuseIdentifier:@"ReuseID" forIndexPath:indexPath];
    [invocation setReturnValue:&view];
  }] collectionView:cv viewForSupplementaryElementOfKind:@"SuppKind" atIndexPath:indexPath];
  [[[dataSource expect] andReturnValue:[NSNumber numberWithInteger:sectionCount]] numberOfSectionsInCollectionView:cv];

  cv.dataSource = dataSource;
  if (shouldFail) {
    XCTAssertThrowsSpecificNamed([cv layoutIfNeeded], NSException, NSInternalInconsistencyException);
    // Early return because behavior after exception is thrown is undefined.
    return;
  }

  [cv layoutIfNeeded];
  XCTAssertEqualObjects(attr, [cv layoutAttributesForSupplementaryElementOfKind:@"SuppKind" atIndexPath:indexPath]);
  XCTAssertEqual(view, [cv supplementaryViewForElementKind:@"SuppKind" atIndexPath:indexPath]);
  [dataSource verify];
  [layoutMock verify];
}

- (void)_testThatIssuingAnUpdateBeforeInitialReloadIsUnacceptable
{
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
  id dataSource = [OCMockObject niceMockForProtocol:@protocol(UICollectionViewDataSource)];

  // Setup empty data source – 0 sections, 0 items
  [[[dataSource stub] andDo:^(NSInvocation *invocation) {
    NSIndexPath *indexPath = [invocation as_argumentAtIndexAsObject:3];
    __autoreleasing UICollectionViewCell *view = [cv dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    [invocation setReturnValue:&view];
  }] collectionView:cv cellForItemAtIndexPath:OCMOCK_ANY];
  [[[dataSource stub] andReturnValue:[NSNumber numberWithInteger:0]] numberOfSectionsInCollectionView:cv];
  [[[dataSource stub] andReturnValue:[NSNumber numberWithInteger:0]] collectionView:cv numberOfItemsInSection:0];
  [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellID"];
  cv.dataSource = dataSource;

  // Update data source – 1 section, 0 items
  [[[dataSource stub] andReturnValue:[NSNumber numberWithInteger:1]] numberOfSectionsInCollectionView:cv];

  /**
   * Inform collection view – insert section 0
   * Throws exception because collection view never saw the data source have 0 sections.
   * so it's going to read "oldSectionCount" now and get 1. It will also read
   * "newSectionCount" and get 1. Then it'll throw because "oldSectionCount(1) + insertedCount(1) != newSectionCount(1)".
   * To workaround this, you could add `[cv numberOfSections]` before the data source is updated to
   * trigger the collection view to read oldSectionCount=0.
   */
  
  // Causing exceptions and then catching them were leaving us in an unknown state for subsequent tests.
  // We would end up with EXC_BAD_ACCESS crashes or the following exception:
  // UIView is missing its initial trait collection populated during initialization. This is a serious bug, likely caused by accessing properties or methods on the view before calling a UIView initializer
  // These tests are being silenced so that the other tests can run properly.
  XCTAssertThrowsSpecificNamed([cv insertSections:[NSIndexSet indexSetWithIndex:0]], NSException, NSInternalInconsistencyException);
}

@end
