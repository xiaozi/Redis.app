//
//  RedisServer.swift
//  Redis
//
//  Created by xiaozi on 3/21/15.
//  Copyright (c) 2015 xiaozi. All rights reserved.
//
import Foundation

class RedisServer {
	var delegate: RedisServerDelegate?
	
	var workDir: String
	var serverBin: String
	var cliBin: String
	var configFile: String
	var args: [String]
	
	init(workDir: String, serverBin: String, cliBin: String, configFile: String, args: [String] = []) {
		self.workDir = workDir
		self.serverBin = serverBin
		self.cliBin = cliBin
		self.configFile = configFile
		self.args = args
	}
	
	func start() {
		self.delegate?.redisStarting()
		// start redis server
		let task = NSTask()
		task.currentDirectoryPath = self.workDir
		task.launchPath = self.serverBin
		task.arguments = [self.configFile]
		task.launch()
		task.waitUntilExit()
		self.delegate?.redisStarted()
	}
	
	func stop() {
		self.delegate?.redisStoping()
		// stop redis server
		let task = NSTask()
		task.currentDirectoryPath = self.workDir
		task.launchPath = self.cliBin
		task.arguments = ["shutdown"]
		task.launch()
		task.waitUntilExit()
		self.delegate?.redisStoped()
	}
	
	func restart() {
		self.stop()
		self.start()
	}
	
	func status() {
		// status redis server
	}
	
}
