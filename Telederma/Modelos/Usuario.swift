//
//  Usuario.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Usuario: ModeloBase {
    var number_document: String?;
    var name: String?;
    var surnames: String?;
    var type_professional: Int?;
    var professional_card: String?;
    var phone: String?;
    var terms_and_conditions: Int?;
    var digital_signature: String?;
    var photo: String?;
    var tutorial: Int?;
    var authentication_token: String?;
    var password: String?;
    var password_confirmation: String?;
    var email: String?;
    var status: Int?;
    var image_digital: String?;
    var id_local: Int!;
    var sincronizado: Bool!;
    
    override init() {
        self.number_document = nil;
        self.name = nil;
        self.surnames = nil;
        self.type_professional = nil;
        self.professional_card = nil;
        self.phone = nil;
        self.terms_and_conditions = nil;
        self.digital_signature = nil;
        self.photo = nil;
        self.tutorial = nil;
        self.authentication_token = nil;
        self.password = nil;
        self.password_confirmation = nil;
        self.email = nil;
        self.status = nil;
        self.image_digital = nil;
        self.id_local = Int();
        self.sincronizado = false;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.number_document <- map["number_document"];
        self.name <- map["name"];
        self.surnames <- map["surnames"];
        self.type_professional <- map["type_professional"];
        self.professional_card <- map["professional_card"];
        self.phone <- map["phone"];
        self.terms_and_conditions <- map["terms_and_conditions"];
        self.digital_signature <- map["digital_signature"];
        self.photo <- map["photo"];
        self.tutorial <- map["tutorial"];
        self.authentication_token <- map["authentication_token"];
        self.email <- map["email"];
        self.status <- map["status"];
        self.image_digital <- map["image_digital"];
        super.mapping(map: map);
    }
}
