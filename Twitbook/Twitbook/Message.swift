//
//  Message.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import Foundation

struct Message: Codable {
    var user: String
    var text: String
    var date: Date
    var imgURL: URL?
    var id: String?
    var replyTo: String?
    var likedBy: [String]?
}
