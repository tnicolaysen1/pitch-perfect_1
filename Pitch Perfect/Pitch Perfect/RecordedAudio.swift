//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Thor Nicolaysen on 4/19/15.
//  Copyright (c) 2015 Thor Nicolaysen. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var filePathUrl: NSURL!//Look
    var title: String!
    
    init(fromFileName: NSURL) {
        filePathUrl = fromFileName
        title = fromFileName.lastPathComponent
        super.init()
    }
    
}
