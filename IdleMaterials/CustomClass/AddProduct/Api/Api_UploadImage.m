//
//  Api_UploadImage.m
//  Solar
//
//  Created by tangqiao on 8/7/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

#import "Api_UploadImage.h"
#import "AFNetworking.h"

@implementation Api_UploadImage {
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"upload";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.5);
        NSString *name = @"uploadPic";
        NSString *fileName = @"uploadPic.jpg";
        NSString *type = @"image/jpg";
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
    };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"data"][@"src"];
}



//- (id)requestArgument{
//    return @{
//             @"uploadPic" : @"uploadPic.jpg",
//             };
//}


@end
