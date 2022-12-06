//
//  InformacionPaciente.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

// 25 campos
class InformacionPaciente: NSObject, Mappable {
    var id_patient_local: Int?; // SQLite
    var terms_conditions: Bool?;
    var insurance_id: Int?;
    var unit_measure_age: Int?;
    var age: Int?;
    var occupation: String?;
    var phone: String?;
    var email: String?;
    var address: String?;
    var municipality_id: Int?;
    var urban_zone: Int?;
    var companion: Bool?;
    var name_companion: String?;
    var phone_companion: String?;
    var responsible: Bool?;
    var name_responsible: String?;
    var phone_responsible: String?;
    var relationship: String?;
    var type_user: Int?;
    var authorization_number: String?;
    var purpose_consultation: Int?;
    var external_cause: Int?;
    var civil_status: Int?;
    var patient_id: Int?; // Servidor
    var status: Int?;
    var id_local: Int!;
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    var sincronizado: Bool!;
    
    override init() {
        self.id_patient_local = nil; // SQLite
        self.terms_conditions = false;
        self.insurance_id = nil;
        self.unit_measure_age = nil;
        self.age = nil;
        self.occupation = nil;
        self.phone = nil;
        self.email = nil;
        self.address = nil;
        self.municipality_id = nil;
        self.urban_zone = nil;
        self.companion = false;
        self.name_companion = nil;
        self.phone_companion = nil;
        self.responsible = false;
        self.name_responsible = nil;
        self.phone_responsible = nil;
        self.relationship = nil;
        self.type_user = nil;
        self.authorization_number = nil;
        self.purpose_consultation = nil;
        self.external_cause = nil;
        self.civil_status = nil;
        self.patient_id = nil; // Servidor
        self.status = nil;
        self.id_local = Int();
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
        self.sincronizado = false;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id_patient_local <- map["id_patient_local"];
        self.terms_conditions <- map["terms_conditions"];
        self.insurance_id <- map["insurance_id"];
        self.unit_measure_age <- map["unit_measure_age"];
        self.age <- map["age"];
        self.occupation <- map["occupation"];
        self.phone <- map["phone"];
        self.email <- map["email"];
        self.address <- map["address"];
        self.municipality_id <- map["municipality_id"];
        self.urban_zone <- map["urban_zone"];
        self.companion <- map["companion"];
        self.name_companion <- map["name_companion"];
        self.phone_companion <- map["phone_companion"];
        self.responsible <- map["responsible"];
        self.name_responsible <- map["name_responsible"];
        self.phone_responsible <- map["phone_responsible"];
        self.relationship <- map["relationship"];
        self.type_user <- map["type_user"];
        self.authorization_number <- map["authorization_number"];
        self.purpose_consultation <- map["purpose_consultation"];
        self.external_cause <- map["external_cause"];
        self.civil_status <- map["civil_status"];
        self.patient_id <- map["patient_id"];
        self.status <- map["status"];
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
