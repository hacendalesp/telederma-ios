//
//  ControlMedico.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ControlMedico: NSObject, Mappable {
    var id_patient_local: Int?;
    var subjetive_improvement: String?;
    var did_treatment: Bool?;
    var tolerated_medications: Int?;
    var consultation_control_id: Int?;
    var audio_clinic: String?;
    var clinic_description: String?;
    var audio_anex: String?;
    var annex_description: String?;
    var treatment: String?;
    var type_remission: String?;
    var remission_comments: String?;
    var doctor_id: Int?;
    var nurse_id: Int?;
    var consultation_id: Int?;
    var status: Int?;
    var type_professional: Int?;
    var id_local: Int!;
    var local_consultation_control_id: Int?;
    var local_consultation_id: Int?;
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    var sincronizado: Bool!;
    
    override init() {
        self.id_patient_local = nil;
        self.subjetive_improvement = nil;
        self.did_treatment = nil;
        self.tolerated_medications = nil;
        self.consultation_control_id = nil;
        self.audio_clinic = nil;
        self.clinic_description = nil;
        self.audio_anex = nil;
        self.annex_description = nil;
        self.treatment = nil;
        self.type_remission = nil;
        self.remission_comments = nil;
        self.doctor_id = nil;
        self.nurse_id = nil;
        self.consultation_id = nil;
        self.status = nil;
        self.type_professional = nil;
        self.id_local = Int();
        self.local_consultation_control_id = nil;
        self.local_consultation_id = nil;
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
        self.sincronizado = false;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id_patient_local <- map["id_patient_local"];
        self.subjetive_improvement <- map["subjetive_improvement"];
        self.did_treatment <- map["did_treatment"];
        self.tolerated_medications <- map["tolerated_medications"];
        self.consultation_control_id <- map["consultation_control_id"];
        self.audio_clinic <- map["audio_clinic"];
        self.clinic_description <- map["clinic_description"];
        self.audio_anex <- map["audio_anex"];
        self.annex_description <- map["annex_description"];
        self.treatment <- map["treatment"];
        self.type_remission <- map["type_remission"];
        self.remission_comments <- map["remission_comments"];
        self.doctor_id <- map["doctor_id"];
        self.nurse_id <- map["nurse_id"];
        self.consultation_id <- map["consultation_id"];
        self.status <- map["status"];
        self.type_professional <- map["type_professional"];
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
