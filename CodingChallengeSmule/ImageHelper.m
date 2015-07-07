//
//  ImageHelper.m
//  CodingChallengeSmule
//
//  Created by Mary Jenel Myers on 6/29/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//
@import CoreData;
#import "ImageHelper.h"
#import "AFNetworking.h"

@interface ImageHelper ()


@end

@implementation ImageHelper

- (instancetype)initWithStandardImage:(NSDictionary *)images filter:(NSString *)filter
{
    self = [super init]; //initializes self.. self is the instagramPhoto Class
    if (self)
    {

        NSDictionary *standardPhotoInfo = [images objectForKey:@"standard_resolution"];
        // filtering down
        NSString *standardPhotoURL = [standardPhotoInfo objectForKey:@"url"];
        self.standardPhotoURL = standardPhotoURL;
        //     NSInteger *latitude = [images objectForKey:@"id"][@"latitude"];
        //    self.latitude = *(latitude);


        self.filter = filter;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
//turns a custom class information into data that can be saved into a plist. plist can only store primitive objects
{
    [encoder encodeObject:self.standardPhotoURL forKey:@"standardPhotoURL"];
    [encoder encodeObject:self.filter forKey:@"filter"];
  //  [encoder encodeBool:self.favPhoto forKey:@"favPhoto"];     //can do encode bool

}


- (id)initWithCoder:(NSCoder *)decoder //takes a primitive data into a plist and reinterprets it into a custom class object
{
    self = [super init];
    if (self) //makes sure you actually created an instance of the object...
    {
        self.standardPhotoURL = [decoder decodeObjectForKey:@"standardPhotoURL"];
        self.filter = [decoder decodeObjectForKey:@"filter"];
     //   self.favPhoto = [decoder decodeBoolForKey:@"favPhoto"];
    }
    return self;
    
}
@end
