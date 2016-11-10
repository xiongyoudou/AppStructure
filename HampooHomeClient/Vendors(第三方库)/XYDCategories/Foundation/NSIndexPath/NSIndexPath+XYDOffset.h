//
//  NSIndexPath+Offset.h
//
//  Created by Nicolas Goutaland on 04/04/15.
//  Copyright 2015 Nicolas Goutaland. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface NSIndexPath (JKOffset)
/**
 *  @author JKCategories
 *
 *  Compute previous row indexpath
 *
 */
- (NSIndexPath *)xyd_previousRow;
/**
 *  @author JKCategories
 *
 *  Compute next row indexpath
 *
 */
- (NSIndexPath *)xyd_nextRow;
/**
 *  @author JKCategories
 *
 *  Compute previous item indexpath
 *
 */
- (NSIndexPath *)xyd_previousItem;
/**
 *  @author JKCategories
 *
 *  Compute next item indexpath
 *
 */
- (NSIndexPath *)xyd_nextItem;
/**
 *  @author JKCategories
 *
 *  Compute next section indexpath
 *
 */
- (NSIndexPath *)xyd_nextSection;
/**
 *  @author JKCategories
 *
 *  Compute previous section indexpath
 *
 */
- (NSIndexPath *)xyd_previousSection;

@end
