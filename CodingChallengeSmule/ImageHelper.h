//
//  ImageHelper.h
//  CodingChallengeSmule
//
//  Created by Mary Jenel Myers on 6/29/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject
@property NSString *standardPhotoURL;
@property NSString *filter;
@property NSInteger latitude;
@property NSInteger longitude;
@property NSString *username;
@property (nonatomic, assign) int searchTerm;
- (instancetype)initWithStandardImage:(NSDictionary *)images filter:(NSString *)filter;


@end
