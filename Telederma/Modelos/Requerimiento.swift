//
//  Requerimiento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Requerimiento: ModeloBase {
    var consultation_id: Int?;
    var medical_control_id: Int?;
    var description_request: String?;
    var specialist_id: Int?;
    var audio_request: String?;
    var comment: String?;
    var type_request: String?;
    var doctor_id: Int?;
    var status: Int?;
    var hour: String?;
    var reason: Int?;
    var other_reason: String?;
    
    override init() {
        self.consultation_id = nil;
        self.medical_control_id = nil;
        self.description_request = nil;
        self.specialist_id = nil;
        self.audio_request = nil;
        self.comment = nil;
        self.type_request = nil;
        self.doctor_id = nil;
        self.status = nil;
        self.hour = nil;
        self.reason = nil;
        self.other_reason = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.consultation_id <- map["consultation_id"];
        self.medical_control_id <- map["medical_control_id"];
        self.description_request <- map["description_request"];
        self.specialist_id <- map["specialist_id"];
        self.audio_request <- map["audio_request"];
        self.comment <- map["comment"];
        self.type_request <- map["type_request"];
        self.doctor_id <- map["doctor_id"];
        self.status <- map["status"];
        self.hour <- map["hour"];
        self.reason <- map["reason"];
        self.other_reason <- map["other_reason"];
        super.mapping(map: map);
    }
}
