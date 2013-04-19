//
//  ChippaiAppDelegate.h
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import <Cocoa/Cocoa.h>

@interface ChippaiAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusBar;

- (void)updateTitle:(NSString*)title;

@end
