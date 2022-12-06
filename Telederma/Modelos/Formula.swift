//
//  Formula.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Formula: ModeloBase {
    var specialist_response_id: Int?;
    var medication_code: String?;
    var type_medicament: String?;
    var generic_name_medicament: String?;
    var pharmaceutical_form: String?;
    var drug_concentration: String?;
    var unit_measure_medication: String?;
    var number_of_units: String?;
    var unit_value_medicament: String?;
    var total_value_medicament: String?;
    var commentations: String?;
    
    override init() {
        self.specialist_response_id = nil;
        self.medication_code = nil;
        self.type_medicament = nil;
        self.generic_name_medicament = nil;
        self.pharmaceutical_form = nil;
        self.drug_concentration = nil;
        self.unit_measure_medication = nil;
        self.number_of_units = nil;
        self.unit_value_medicament = nil;
        self.total_value_medicament = nil;
        self.commentations = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.specialist_response_id <- map["specialist_response_id"];
        self.medication_code <- map["medication_code"];
        self.type_medicament <- map["type_medicament"];
        self.generic_name_medicament <- map["generic_name_medicament"];
        self.pharmaceutical_form <- map["pharmaceutical_form"];
        self.drug_concentration <- map["drug_concentration"];
        self.unit_measure_medication <- map["unit_measure_medication"];
        self.number_of_units <- map["number_of_units"];
        self.unit_value_medicament <- map["unit_value_medicament"];
        self.total_value_medicament <- map["total_value_medicament"];
        self.commentations <- map["commentations"];
        super.mapping(map: map);
    }
}
