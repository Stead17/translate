//
//  STAIntegerToString.m
//  Exercise7
//
//  Created by Иван Ткаченко on 8/11/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAIntegerToString.h"

@implementation STAIntegerToString

+ (Class)transformedValueClass
{
    return [STAIntegerToString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    NSLog(@"%@", value);
    
    return [NSString stringWithFormat:@"%@", value];
}

- (id)reverseTransformedValue:(id)value
{
    NSLog(@"%@", value);
    NSLog(@"%ld", [value integerValue]);
    return value;
}

@end
