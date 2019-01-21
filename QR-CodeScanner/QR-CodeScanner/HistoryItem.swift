//
//  HistoryItem.swift
//  QR-CodeScanner
//
//  Created by Yunlu18 on 2019/1/21.
//  Copyright © 2019 QRteam. All rights reserved.
//

import Foundation


class HistoryItem {
    
    var id: Int
    var content: String?
    var date: String?
    
    init(id: Int, content: String?, date: String?){
        self.id = id
        self.content = content
        self.date = date
    }
}
