//
//  Places.m
//  PlacesApi
//
//  Created by Merritt Tidwell on 12/28/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "Places.h"


@implementation Places

@synthesize name;

+ (id)nameOfPlace:(NSString *)name
{
    Places * newPlace = [[self alloc] init];
    newPlace.name = name;
    return newPlace;
}




@end
