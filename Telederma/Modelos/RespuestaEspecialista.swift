//
//  RespuestaEspecialista.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class RespuestaEspecialista: ModeloBase {
    var specialist_id: Int?;
    var consultation_id : Int?;
    var consultation_control_id: Int?;
    var control_recommended: String?;
    var case_analysis: String?;
    var analysis_description: String?;
    var hour: String?;
    
    override init() {
        self.specialist_id = nil;
        self.consultation_id = nil;
        self.consultation_control_id = nil;
        self.control_recommended = nil;
        self.case_analysis = nil;
        self.analysis_description = nil;
        self.hour = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.specialist_id <- map["specialist_id"];
        self.consultation_id <- map["consultation_id"];
        self.consultation_control_id <- map["consultation_control_id"];
        self.control_recommended <- map["control_recommended"];
        self.case_analysis <- map["case_analysis"];
        self.analysis_description <- map["analysis_description"];
        self.hour <- map["hour"];
        super.mapping(map: map);
    }
}
