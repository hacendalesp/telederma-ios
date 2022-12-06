//
//  ConsultaMedica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ConsultaMedica: NSObject, Mappable {
    var local_patient_information_id: Int?; // SQLite
    var evolution_time: Int?;
    var unit_measurement: Int?;
    var weight: String?;
    var consultation_id: Int?; // Servidor
    var number_injuries: Int?;
    var evolution_injuries: String?;
    var blood: Bool?;
    var exude: Bool?;
    var suppurate: Bool?;
    var symptom: String?;
    var change_symptom: Int?;
    var other_factors_symptom: String?;
    var aggravating_factors: String?;
    var family_background: String?;
    var personal_history: String?;
    var treatment_received: String?;
    var applied_substances: String?;
    var treatment_effects: String?;
    var description_physical_examination: String?;
    var physical_audio: String?;
    var type_remission: String?;
    var remission_comments: String?;
    var archived: Int?;
    var count_controls: Int?;
    var treatment: String?;
    var date_archived: String?;
    var type_professional: Int?;
    var readed: Int?;
    var annex_description: String?;
    var audio_annex: String?;
    var patient_id: Int?; // Servidor
    var patient_information_id: Int?; // Servidor
    var status: Int?;
    var doctor_id: Int?; // Servidor
    var nurse_id: Int?; // Servidor
    var diagnostic_impression: String?;
    var ciediezcode: String?;
    var id_local: Int!;
    var other_factors_is_on: Bool?;
    var history_is_on: Bool?;
    var treatment_received_is_on: Bool?;
    var other_substances_is_on: Bool?;
    var treatment_effects_is_on: Bool?;
    var local_consultation_id: Int?;
    var local_patient_id: Int?;
    var id: Int?;
    var created_at: String?;
    var updated_at: String?;
    var sincronizado: Bool!;
    
    override init() {
        self.local_patient_information_id = nil;
        self.evolution_time = nil;
        self.unit_measurement = nil;
        self.number_injuries = nil;
        self.evolution_injuries = nil;
        self.blood = nil;
        self.exude = nil;
        self.suppurate = nil;
        self.symptom = nil;
        self.change_symptom = nil;
        self.other_factors_symptom = nil;
        self.aggravating_factors = nil;
        self.family_background = nil;
        self.personal_history = nil;
        
        self.weight = nil;
        self.consultation_id = nil;
        
        self.treatment_received = nil;
        self.applied_substances = nil;
        self.treatment_effects = nil;
        self.description_physical_examination = nil;
        self.physical_audio = nil;
        self.type_remission = nil;
        self.remission_comments = nil;
        self.archived = nil;
        self.count_controls = nil;
        self.treatment = nil;
        self.date_archived = nil;
        self.type_professional = nil;
        self.readed = nil;
        self.annex_description = nil;
        self.audio_annex = nil;
        self.patient_id = nil;
        self.patient_information_id = nil;
        self.status = nil;
        self.doctor_id = nil;
        self.nurse_id = nil;
        self.diagnostic_impression = nil;
        self.ciediezcode = nil;
        self.id_local = Int();
        
        self.other_factors_is_on = false;
        self.history_is_on = false;
        self.treatment_received_is_on = false;
        self.other_substances_is_on = false;
        self.treatment_effects_is_on = false;
        self.local_consultation_id = nil;
        self.local_patient_id = nil;
        self.id = nil; // Servidor
        self.created_at = nil;
        self.updated_at = nil;
        self.sincronizado = false;
    }
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        self.local_patient_information_id <- map["local_patient_information_id"];
        self.evolution_time <- map["evolution_time"];
        self.unit_measurement <- map["unit_measurement"];
        self.weight <- map["weight"];
        self.consultation_id <- map["consultation_id"];
        self.number_injuries <- map["number_injuries"];
        self.evolution_injuries <- map["evolution_injuries"];
        self.blood <- map["blood"];
        self.exude <- map["exude"];
        self.suppurate <- map["suppurate"];
        self.symptom <- map["symptom"];
        self.change_symptom <- map["change_symptom"];
        self.other_factors_symptom <- map["other_factors_symptom"];
        self.aggravating_factors <- map["aggravating_factors"];
        self.family_background <- map["family_background"];
        self.personal_history <- map["personal_history"];
        self.treatment_received <- map["treatment_received"];
        self.applied_substances <- map["applied_substances"];
        self.treatment_effects <- map["treatment_effects"];
        self.description_physical_examination <- map["description_physical_examination"];
        self.physical_audio <- map["physical_audio"];
        self.type_remission <- map["type_remission"];
        self.remission_comments <- map["remission_comments"];
        self.archived <- map["archived"];
        self.count_controls <- map["count_controls"];
        self.treatment <- map["treatment"];
        self.date_archived <- map["date_archived"];
        self.type_professional <- map["type_professional"];
        self.readed <- map["readed"];
        self.annex_description <- map["annex_description"];
        self.audio_annex <- map["audio_annex"];
        self.patient_id <- map["patient_id"];
        self.patient_information_id <- map["patient_information_id"];
        self.status <- map["status"];
        self.doctor_id <- map["doctor_id"];
        self.nurse_id <- map["nurse_id"];
        self.diagnostic_impression <- map["diagnostic_impression"];
        self.ciediezcode <- map["ciediezcode"];
        self.id <- map["id"];
        self.created_at <- map["created_at"];
        self.updated_at <- map["updated_at"];
    }
}
