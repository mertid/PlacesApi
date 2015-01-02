//
//  Places.h
//  PlacesApi
//
//  Created by Merritt Tidwell on 12/28/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Places : NSObject
{
    NSString *name;
}

@property (nonatomic, copy) NSString *name;

+ (id)nameOfPlace:(NSString*)name;



@end
