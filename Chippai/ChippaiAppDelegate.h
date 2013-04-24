//
//  ChippaiAppDelegate.h
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import <Cocoa/Cocoa.h>
#import "SocketIO.h"

@interface ChippaiAppDelegate : NSObject
<NSApplicationDelegate, SocketIODelegate>

@property (assign) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusBar;
@property (nonatomic, strong) SocketIO *socketIO;

- (void)updateTitle:(NSString*)title;

@end
