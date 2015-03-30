//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Steven on 25/03/2015.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
}
