//
//  ChippaiAppDelegate.m
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import "ChippaiAppDelegate.h"

#import "HTTPServer.h"
#import "ChippaiResponse.h"

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
  
  [self updateTitle];
//  [NSTimer scheduledTimerWithTimeInterval:0.05f
//                                   target:self
//                                 selector:@selector(updateTitle)
//                                 userInfo:nil repeats:YES];
  
  NSNumber *ownerPid = [self getOwnerPIDWithOwnerName:@"VLC"];
  
  NSRunningApplication *application = [NSRunningApplication runningApplicationWithProcessIdentifier:[ownerPid intValue]];
  NSLog(@"application = %@", application);
  
//  NSLog(@"activeApplication = %@", [[NSWorkspace sharedWorkspace] activeApplication]);
//
//  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
//  NSLog(@"runningApplications = %@", runningApplications);
//  
//  for (NSRunningApplication *application in runningApplications) {
//    
//    NSNumber *pid = [appInfo objectForKey:@"NSApplicationProcessIdentifier"];
//    if ([ownerPid intValue] == [pid intValue]){
//      
//      NSLog(@"appInfo = %@", appInfo);
//      
//      break;
//    }
//    
//  }
  
  [[HTTPServer sharedHTTPServer] start];
  [ChippaiResponse load];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
  [[HTTPServer sharedHTTPServer] stop];
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

- (IBAction)copyToPastaborad:(id)sender
{
  [[NSPasteboard generalPasteboard] clearContents];
  [[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:self.statusBar.title]];
}

- (IBAction)google:(id)sender
{
  NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/search?q=%@",
                         [self.statusBar.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURL *url = [NSURL URLWithString:urlString];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (NSNumber*)getOwnerPIDWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = CFBridgingRelease(windowList);
//  NSLog(@"array = %@", array);
  for (NSDictionary *dic in array) {
    NSString *windowOwnerName = [dic objectForKey:@"kCGWindowOwnerName"];
    BOOL isOnScreen = [[dic objectForKey:@"kCGWindowIsOnscreen"] boolValue];
    if ([windowOwnerName isEqualToString:ownerName]
        && isOnScreen == YES){
      return [dic objectForKey:@"kCGWindowOwnerPID"];
    }
  }
  return nil;
}

- (NSString*)getWindowTitleWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = CFBridgingRelease(windowList);
  NSLog(@"array = %@", array);
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

- (void)updateTitle:(NSString*)title
{
  self.statusBar.title = title;
}




@end
