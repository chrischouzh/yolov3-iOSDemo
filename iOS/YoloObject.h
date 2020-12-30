//
//  YoloObject.h
//  yolov3Demo (iOS)
//
//  Created by zouhao on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoloObject : NSObject
- (NSMutableArray<NSValue *> *)detectImageWith:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
