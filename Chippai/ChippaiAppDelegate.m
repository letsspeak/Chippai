//
//  ChippaiAppDelegate.m
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import "ChippaiAppDelegate.h"
#import "PreferencesWindowController.h"
#import "iTunes.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoView.h"

@interface ChippaiAppDelegate ()
@property (nonatomic, strong) PreferencesWindowController *preferences;
@property (nonatomic, strong) iTunesApplication *iTunesApp;
@property (nonatomic, strong) InfoView *infoView;
@end

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
  
  self.width = 200;
  self.scrollSpeed = 2;
  self.iTunesApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

  
  [NSTimer scheduledTimerWithTimeInterval:1.0f
                                   target:self
                                 selector:@selector(loadMusicInfo)
                                 userInfo:nil repeats:YES];

  [NSTimer scheduledTimerWithTimeInterval:0.1f
                                   target:self
                                 selector:@selector(drawStatusBar)
                                 userInfo:nil repeats:YES];
}

- (void)loadMusicInfo
{
  self.title = [self.iTunesApp.currentTrack name];
  self.artist = [self.iTunesApp.currentTrack artist];
}

- (void)drawStatusBar
{
  NSString *string = self.title;
  if (self.artist) {
    string = [NSString stringWithFormat:@"%@ - %@", self.title, self.artist];
  }
  
  static int scrollCount = 0;
  scrollCount++;
  if ((self.scrollSpeed == 1 && scrollCount > 5)
      || (self.scrollSpeed == 2 && scrollCount > 3)
      || self.scrollSpeed == 3) {
    
    static NSInteger pos = 0;
    NSInteger length = [string length];
    string = [string stringByAppendingString:string];
    string = [string substringWithRange:NSMakeRange(pos, length)];
    if (++pos >= length) pos = 0;
    
    scrollCount = 0;
  } else if (self.scrollSpeed > 0){
    return;
  }
  
  NSFont *font = [NSFont systemFontOfSize:13.0f];
  NSString *trimmedString = [self trimString:string font:font width:self.width];
  self.statusBar.title = trimmedString;
  self.statusBar.toolTip = string;
}

- (NSString*)trimString:(NSString*)string font:(NSFont*)font width:(CGFloat)width
{
  NSDictionary *attributes = @{NSFontAttributeName:font};
  NSInteger index = [string length];
  while ([[string substringToIndex:index] sizeWithAttributes:attributes].width > width) {
    index--;
    if (index < 0) return @"";
  }
  return [string substringToIndex:index];
}

- (void)updateVLCTitle
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

- (IBAction)preferences:(id)sender
{
  NSLog(@"preferences");
  PreferencesWindowController *controller = [[PreferencesWindowController alloc] initWithWindowNibName:@"preferences"];
  controller.delegate = self;
  self.preferences = controller;
  [controller showWindow:self];
}

- (NSString*)getWindowTitleWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = CFBridgingRelease(windowList);
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
