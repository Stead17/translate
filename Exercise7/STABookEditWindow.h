//
//  STABookEditWindow.h
//  Exercise7
//
//  Created by Иван Ткаченко on 8/10/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STABook, STAModelController;

@interface STABookEditWindow : NSWindowController <NSTextFieldDelegate, NSTextViewDelegate, NSTextDelegate>

- (instancetype)initWithWindowNibName:(NSString *)windowNibName bookToEdit:(STABook *)book model:(STAModelController *)model;

@end
