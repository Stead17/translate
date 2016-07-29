//
//  STAVisitor+VisitorSerialization.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAVisitor+VisitorSerialization.h"
#import "STABook.h"

NSString *const kSTAReaderName = @"kSTAReaderName";
NSString *const kSTAReaderSurname = @"kSTAReaderSurname";
NSString *const kSTABirthYear = @"kSTABirthYear";
NSString *const kSTAFullName = @"kSTAFullName";
NSString *const kSTAVisitorBooks = @"kSTAVisitorBooks";

@implementation STAVisitor (VisitorSerialization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    self = [self initWithName:aDictionary[kSTAReaderName] visitorSurname:aDictionary[kSTAReaderSurname]
                    birthYear:[aDictionary[kSTABirthYear] unsignedIntegerValue]];
    
    if (aDictionary[kSTAVisitorBooks])
    {
        for (NSDictionary *dict in aDictionary[kSTAVisitorBooks]) {
            STABook *tmp = [STABook bookWithID:[dict objectForKey:@"ID"]
                                      bookName:[dict objectForKey:@"bookName"]
                                      bookYear: [[dict objectForKey:@"bookYear"] unsignedIntegerValue]
                                      bookType: [[dict objectForKey:@"coverType"] integerValue]];
            [self takeBook: tmp];
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    @autoreleasepool
    {
        if (self.name)
        {
            dict[kSTAReaderName] = self.name;
        }
        if (self.surname)
        {
            dict[kSTAReaderSurname] = self.surname;
        }
        if(self.fullName)
        {
            dict[kSTAFullName] = self.fullName;
        }
        
        dict[kSTABirthYear] = [NSNumber numberWithUnsignedInteger:self.birthYear];
        
        if (self.visitorBooks)
        {
            NSUInteger sz = self.visitorBooks.count;
            NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:sz];
            for (STABook *obj in self.visitorBooks)
            {
                [tmpArr addObject:@{@"bookName" : obj.bookName,
                                    @"bookYear" : [NSNumber numberWithUnsignedInteger:obj.bookYear],
                                    @"coverType" : [NSNumber numberWithInteger:obj.coverType],
                                    @"ID" : obj.ID}];
            }
            dict[kSTAVisitorBooks] = tmpArr;
        }
    }
    return dict;
}


@end