//
//  SecondViewController.m
//  yolov3Demo (iOS)
//
//  Created by zouhao on 2020/12/29.
//

#import "SecondViewController.h"
#import "YoloObject.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation SecondViewController {
    NSTimeInterval startInterval;
    NSMutableArray<NSValue *> * currentValues;
    UIImage *currentImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentValues = [NSMutableArray array];
    currentImage = [UIImage imageNamed:@"human_4.jpg"];
}

- (void)startDetect {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self->startInterval = [[NSDate date] timeIntervalSinceReferenceDate];
        self->currentValues = [[[YoloObject alloc] init] detectImageWith:self->currentImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = [NSString stringWithFormat:@"用时：%fs",[[NSDate date] timeIntervalSinceReferenceDate] - self->startInterval];
            [self drawRectWith:self->currentValues];
        });
    });
}
- (IBAction)nextButtonClick:(id)sender {
//    for (int i = 0; i < self.imageView.layer.sublayers.count; i++) {
//        [self.imageView.layer.sublayers[i] removeFromSuperlayer];
//    }
    [self.imageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    int number = arc4random() % 4 + 1;
    currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"human_%d.jpg",number]];
    self.imageView.image = currentImage;
}

- (IBAction)startButtonClick:(id)sender {
    [self startDetect];
}

- (void)drawRectWith:(NSMutableArray<NSValue *> *)rectValues {
    CGFloat scale = currentImage.size.width / self.imageView.frame.size.width;
    for (NSValue *value in rectValues) {
        CGRect rect = value.CGRectValue;
        CAShapeLayer *newRectLayer = [[CAShapeLayer alloc]init];
        newRectLayer.borderColor = UIColor.redColor.CGColor;
        newRectLayer.borderWidth = 2;
        newRectLayer.backgroundColor = UIColor.clearColor.CGColor;
        newRectLayer.lineWidth = 2;
        newRectLayer.strokeColor = newRectLayer.borderColor;
        newRectLayer.fillColor = newRectLayer.borderColor;
        [self.imageView.layer addSublayer:newRectLayer];
        newRectLayer.frame =  CGRectMake(rect.origin.x / scale, rect.origin.y / scale, rect.size.width / scale, rect.size.height / scale);
        newRectLayer.zPosition = 1.0;
    }
}
@end
