//
//  Especialista.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Especialista: NSObject, Mappable {
    var name: String?;
    var surnames: String?;
    var date: String?;
    var hour: String?;
    var professional_card: String?;
    var local_id: Int!;
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    var sincronizado: Bool!;
    
    override init() {
        self.name = nil;
        self.surnames = nil;
        self.date = nil;
        self.hour = nil;
        self.professional_card = nil;
        self.local_id = Int();
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
        self.sincronizado = false;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.name <- map["name"];
        self.surnames <- map["surnames"];
        self.date <- map["date"];
        self.hour <- map["hour"];
        self.professional_card <- map["professional_card"];
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
