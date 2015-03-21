//
//  RedisServerDelegate.swift
//  Redis
//
//  Created by xiaozi on 3/21/15.
//  Copyright (c) 2015 xiaozi. All rights reserved.
//

protocol RedisServerDelegate {
	func redisStarting();
	func redisStarted();
	func redisStoping();
	func redisStoped();
}
