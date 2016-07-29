//
//  STALibraryViewController.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/23/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kVisitorsTableViewIdentifier;
extern NSString *const kNameTableColumnIdentifier;
extern NSString *const kSurnameTableColumnIdentifier;
extern NSString *const kYearTableColumnIdentifier;

extern NSString *const kBooksTableViewIdentifier;
extern NSString *const kTitleTableColumnIdentifier;
extern NSString *const kBookYearTableColumnIdentifier;
extern NSString *const kTypeTableColumnIdentifier;
extern NSString *const kOwnerTableColumnIdentifier;

@class STAModelController;

@interface STALibraryViewController : NSViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(STAModelController *)model;

@end