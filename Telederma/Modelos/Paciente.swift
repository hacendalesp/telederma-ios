//
//  Paciente.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

// 11 campos
class Paciente: NSObject, Mappable {
    var type_document: Int?;
    var type_condition: Int?;
    var number_document: String?;
    var last_name: String?;
    var second_surname: String?;
    var name: String?;
    var second_name: String?;
    var birthdate: String?;
    var genre: Int?;
    var number_inpec: String?;
    var status: Int?;
    var id_local: Int!; // SQLite
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    var sincronizado: Bool!;
    
    override init() {
        self.type_document = nil;
        self.type_condition = nil;
        self.number_document = nil;
        self.last_name = nil;
        self.second_surname = nil;
        self.name = nil;
        self.second_name = nil;
        self.birthdate = nil;
        self.genre = nil;
        self.number_inpec = nil;
        self.status = nil;
        self.id_local = Int(); // SQLite
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
        self.sincronizado = false;

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.type_document <- map["type_document"];
        self.type_condition <- map["type_condition"];
        self.number_document <- map["number_document"];
        self.last_name <- map["last_name"];
        self.second_surname <- map["second_surname"];
        self.name <- map["name"];
        self.second_name <- map["second_name"];
        self.birthdate <- map["birthdate"];
        self.genre <- map["genre"];
        self.number_inpec <- map["number_inpec"];
        self.status <- map["status"];
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
