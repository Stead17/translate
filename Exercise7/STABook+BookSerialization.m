//
//  STABook+BookSerialization.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STABook+BookSerialization.h"
#import "STAVisitor+VisitorSerialization.h"
#import "STAVisitor.h"

NSString *const kSTABookName = @"kSTABookName";
NSString *const kSTABookYear = @"kSTABookYear";
NSString *const kSTABookCoverType = @"kSTABookCoverType";
NSString *const kSTABookOwner = @"kSTABookOwner";
NSString *const kSTABookID = @"kSTABookID";
NSString *const kSTABookText = @"kSTABookText";

@implementation STABook (BookSerialization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    self = [self initWithBookName:aDictionary[kSTABookName]
                         bookYear:[aDictionary[kSTABookYear] unsignedIntegerValue]
                         bookType:[aDictionary[kSTABookCoverType] integerValue]];
    if (aDictionary[kSTABookOwner])
    {
        self.owner = [[[STAVisitor alloc] initWithDictionaryRepresentation:aDictionary[kSTABookOwner]] autorelease];
    }
    if (aDictionary[kSTABookText])
    {
        self.text = [aDictionary[kSTABookText] copy];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.bookName)
        dict[kSTABookName] = self.bookName;
    if (self.ID)
        dict[kSTABookID] = self.ID;
    dict[kSTABookYear] = [NSNumber numberWithUnsignedInteger:self.bookYear];
    
    dict[kSTABookCoverType] = [NSNumber numberWithInteger:self.coverType];
    
    if (self.owner)
    {
        dict[kSTABookOwner] = [self.owner dictionaryRepresentation];
    }
    if (self.text)
    {
        dict[kSTABookText] = self.text;
    }
    
    return dict;
}

@end