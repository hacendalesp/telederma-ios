//
//  ModeloBase.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ModeloBase: NSObject, Mappable {
    
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    
    override init() {
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
