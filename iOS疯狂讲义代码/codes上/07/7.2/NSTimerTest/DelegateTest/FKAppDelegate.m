//  Created by yeeku on 2013-4-21.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.

#import "FKAppDelegate.h"

@implementation FKAppDelegate
@synthesize window;
@synthesize count;
// 当应用程序将要加载完成时激发该方法
- (void) applicationWillFinishLaunching: (NSNotification *) aNotification
{
	// 创建NSWindow对象，并赋值给window
	self.window = [[NSWindow alloc] initWithContentRect:
		NSMakeRect(300, 300, 320, 200)
		styleMask: (NSTitledWindowMask |NSMiniaturizableWindowMask
		| NSClosableWindowMask)
		backing: NSBackingStoreBuffered defer: NO];
	// 设置窗口标题
	self.window.title = @"Delegate测试";
	// 创建NSTextField对象，并赋值给label变量
	NSTextField * label = [[NSTextField alloc] initWithFrame: NSMakeRect(60, 120, 200, 60)];
	// 为label设置属性
	[label setSelectable: YES];
	[label setBezeled: YES];
	[label setDrawsBackground: YES];
	[label setStringValue: @"疯狂iOS讲义是一本系统的iOS开发图书" ];
	// 创建NSButton对象，并赋值给button变量
	NSButton * button = [[NSButton alloc] initWithFrame:
		NSMakeRect(120, 40, 80, 30)];
	// 为button设置属性	
	button.title = @"确定";
	[button setBezelStyle:NSRoundedBezelStyle];
	[button setBounds:NSMakeRect(120, 40, 80, 30)];
	// 将label、button添加到窗口中
	[self.window.contentView addSubview: label];
	[self.window.contentView addSubview: button];
	// 启动一个定时器
	[NSTimer scheduledTimerWithTimeInterval:0.5
		  target:self // 指定以当前对象的info:方法作为执行任务
		  selector:@selector(info:)
		  userInfo:nil
		  repeats: YES]; // 指定重复执行
}
// 当应用程序加载完成时激发该方法
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// 把该窗口显示到该应用程序的前台
	[self.window makeKeyAndOrderFront: self];
}
- (void) info:(NSTimer*) timer
{
	NSLog(@"正在执行第%d次任务", self.count++);
	// 如果count的值大于10，取消定时器
	if(self.count > 10)
	{
		NSLog(@"取消执行定时器");
		[timer invalidate];
	}
}
@end
