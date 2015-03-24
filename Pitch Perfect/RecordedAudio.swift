//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Matthew Murphy on 2/14/15.
//  Copyright (c) 2015 Gonzostew. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl: NSURL) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
