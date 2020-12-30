//
//  YoloObject.m
//  yolov3Demo (iOS)
//
//  Created by zouhao on 2020/12/30.
//

#import "YoloObject.h"
#import "ncnn.framework/Headers/ncnn/net.h"
#include <stdio.h>
#include <vector>

struct Object
{
    int label;
    float prob;
    float width;
    float height;
    float x;
    float y;
};

@implementation YoloObject

- (NSMutableArray<NSValue *> *)detectImageWith:(UIImage *)image {
    std::vector<Object> objects;
    ncnn::Net yolov3;
    NSString *paramPath = [[NSBundle mainBundle] pathForResource:@"30kdi8" ofType:@"param"];
    NSString *binPath = [[NSBundle mainBundle] pathForResource:@"30kdi8" ofType:@"bin"];
    yolov3.load_param(paramPath.UTF8String);
    yolov3.load_model(binPath.UTF8String);

    const int target_size = 320;

    int img_w = image.size.width;
    int img_h = image.size.height;
    unsigned char* rgba = new unsigned char[img_w * img_h * 4];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGContextRef contextRef = CGBitmapContextCreate(rgba, img_w, img_h, 8, img_w * 4, colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, img_w, img_h), image.CGImage);
    CGContextRelease(contextRef);
    

    ncnn::Mat in = ncnn::Mat::from_pixels_resize(rgba, ncnn::Mat::PIXEL_RGBA, img_w, img_h, target_size, target_size);

    const float mean_vals[3] = {127.5f, 127.5f, 127.5f};
    const float norm_vals[3] = {0.007843f, 0.007843f, 0.007843f};
    in.substract_mean_normalize(mean_vals, norm_vals);

    ncnn::Extractor ex = yolov3.create_extractor();

    ex.input("data", in);

    ncnn::Mat out;
    int state = ex.extract("detection_out", out);

    printf("%d %d %d\n", out.w, out.h, out.c);
    objects.clear();
    for (int i = 0; i < out.h; i++)
    {
        const float* values = out.row(i);

        Object object;
        object.label = values[0];
        object.prob = values[1];
        object.x = values[2] * img_w;
        object.y = values[3] * img_h;
        object.width = values[4] * img_w - object.x;
        object.height = values[5] * img_h - object.y;

        objects.push_back(object);
    }
    printf("%d %d %d\n", out.w, out.h, out.c);
    NSMutableArray<NSValue *> *rectValues = [NSMutableArray array];
    for (int i = 0; i < objects.size(); i++) {
        if (objects[i].label == 1) {
            CGRect rect = CGRectMake(objects[i].x, objects[i].y, objects[i].width, objects[i].height);
            [rectValues addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    return rectValues;
}

@end
