//
//  AppDelegate.swift
//  Redis
//
//  Created by xiaozi on 3/21/15.
//  Copyright (c) 2015 xiaozi. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, RedisServerDelegate {
	var statusBarItem: NSStatusItem!
	@IBOutlet weak var statusMenu: NSMenu!

	@IBOutlet weak var startBtn: NSMenuItem!
	@IBOutlet weak var stopBtn: NSMenuItem!
	@IBOutlet weak var restartBtn: NSMenuItem!
	@IBOutlet weak var cliBtn: NSMenuItem!
	
	var redisServer: RedisServer
	var workDir: String
	var cliBin: String

	override init() {
		let workDir = AppDelegate.getWorkDir()!
		let serverBin = NSBundle.mainBundle().pathForResource("redis-server", ofType: nil, inDirectory: "redis/bin")
		let cliBin = NSBundle.mainBundle().pathForResource("redis-cli", ofType: nil, inDirectory: "redis/bin")
		let configFile = AppDelegate.getConfigFile(workDir)
		
		self.redisServer = RedisServer(workDir: workDir, serverBin: serverBin!, cliBin: cliBin!, configFile: configFile)
		self.cliBin = cliBin!
		self.workDir = workDir
		super.init()
		self.redisServer.delegate = self
	}
	
	class func getWorkDir() -> String? {
		let ide = NSBundle.mainBundle().bundleIdentifier
		var fm = NSFileManager.defaultManager()
		let urls = fm.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
		if urls.count > 0 {
			var url: NSURL = urls[0] as NSURL
			var path = url.path! + "/" + ide!
			var theError: NSError?
			var exists: Bool = fm.fileExistsAtPath(path)
			var success: Bool = true
			if !exists {
				success = fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &theError)
			}

			return path
		}
		return nil
	}
	
	class func getConfigFile(workDir: String) -> String {
		let configFile = workDir + "/redis.conf"
		var fm = NSFileManager.defaultManager()
		if fm.fileExistsAtPath(configFile) {
			return configFile
		}
		var error: NSError? = nil
		let defaultConfigFile = NSBundle.mainBundle().pathForResource("redis", ofType: "conf", inDirectory: "redis/etc")
		fm.copyItemAtPath(defaultConfigFile!, toPath: configFile, error: &error)
		return configFile
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			self.redisServer.start()
		}
	}
	
	override func awakeFromNib() {
		// menubar
		var statusBar = NSStatusBar.systemStatusBar()
		var statusBarItem: NSStatusItem = statusBar.statusItemWithLength(-1)
		statusBarItem.menu = self.statusMenu
		// statusBarItem.title = "redis"
		statusBarItem.image = NSImage(named: "StatusIcon")
		statusBarItem.alternateImage = NSImage(named: "StatusIcon-alt")
		statusBarItem.highlightMode = true
		self.statusBarItem = statusBarItem
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		self.redisServer.stop()
	}

	@IBAction func onStartBtnClick(sender: AnyObject) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			self.redisServer.start()
		}
	}
	
	@IBAction func onStopBtnClick(sender: AnyObject) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			self.redisServer.stop()
		}
	}
	
	@IBAction func onRestartBtnClick(sender: AnyObject) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			self.redisServer.restart()
		}
	}
	
	@IBAction func onCliBtnClick(sender: AnyObject) {
		NSWorkspace.sharedWorkspace().openFile(self.cliBin)
	}
	
	@IBAction func onWorkDirBtnClick(sender: AnyObject) {
		NSWorkspace.sharedWorkspace().openFile(self.workDir)
	}
	
	@IBAction func onAboutBtnClick(sender: AnyObject) {
		NSApp.orderFrontStandardAboutPanel(self)
	}
	
	@IBAction func onQuitBtnClick(sender: AnyObject) {
		NSApplication.sharedApplication().terminate(self)
	}
	
	func redisStarting() {
		// self.statusBarItem.title = "starting"
		self.statusBarItem.image = NSImage(named: "StatusIcon-una")
	}
	
	func redisStarted() {
		// self.statusBarItem.title = "started"
		self.statusBarItem.image = NSImage(named: "StatusIcon")
		self.cliBtn.state = 1
	}
	
	func redisStoping() {
		// self.statusBarItem.title = "stoping"
		self.statusBarItem.image = NSImage(named: "StatusIcon")
	}
	
	func redisStoped() {
		// self.statusBarItem.title = "stoped"
		self.statusBarItem.image = NSImage(named: "StatusIcon-una")
		self.cliBtn.state = 0
	}

}

