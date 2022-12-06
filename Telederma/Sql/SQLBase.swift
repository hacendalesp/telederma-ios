//
//  SQLBase.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLBase: NSObject {
    var tabla: Table?;
    var id: Expression<Int?>;
    var created_at: Expression<String?>;
    var updated_at: Expression<String?>;
    
    var database: Connection? = nil;
    
    init(db: Connection?) {
        self.id = Expression<Int?>("id");
        self.created_at = Expression<String?>("created_at");
        self.updated_at = Expression<String?>("updated_at");
        self.database = db;
    }
        
}
