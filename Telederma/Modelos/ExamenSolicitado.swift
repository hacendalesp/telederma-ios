//
//  ExamenSolicitado.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ExamenSolicitado: ModeloBase {
    var specialist_response_id: Int?;
    var name_type_exam: String?;
    
    override init() {
        self.specialist_response_id = nil;
        self.name_type_exam = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.specialist_response_id <- map["specialist_response_id"];
        self.name_type_exam <- map["name_type_exam"];
        super.mapping(map: map);
    }
}
