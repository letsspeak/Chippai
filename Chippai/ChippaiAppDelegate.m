//
//  ChippaiAppDelegate.m
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import "ChippaiAppDelegate.h"

@implementation ChippaiAppDelegate

@synthesize statusMenu;
@synthesize statusBar = _statusBar;

- (void)awakeFromNib
{
  self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  self.statusBar.title = @"Loading...";
  
  self.statusBar.menu = self.statusMenu;
  self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
  
  [NSTimer scheduledTimerWithTimeInterval:1.0f
                                   target:self
                                 selector:@selector(updateTitle)
                                 userInfo:nil repeats:YES];
}

- (void)updateTitle
{
  NSString *vlcTitle = [self getWindowTitleWithOwnerName:@"VLC"];
  
  if (vlcTitle) {
    self.statusBar.title = vlcTitle;
  } else {
    self.statusBar.title = @"(。ﾟωﾟ) ｡";
  }
}

- (NSString*)getWindowTitleWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = [(__bridge NSArray*)windowList mutableCopy];
  for (NSDictionary *dic in array) {
    NSString *windowOwnerName = [dic objectForKey:@"kCGWindowOwnerName"];
    BOOL isOnScreen = [[dic objectForKey:@"kCGWindowIsOnscreen"] boolValue];
    if ([windowOwnerName isEqualToString:ownerName]
        && isOnScreen == YES){
      return [dic objectForKey:@"kCGWindowName"];
    }
  }
  return nil;
}

@end
