//
//  DirectMessage.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import Foundation

struct DirectMessage: Codable {
    var to: String
    var from: String
    var message: Message
}
