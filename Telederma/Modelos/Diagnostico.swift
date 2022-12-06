//
//  Diagnostico.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Diagnostico: ModeloBase {
    var specialist_response_id: Int?;
    var disease: String?;
    var type_diagnostic: String?;
    var status: String?;
    
    override init() {
        self.specialist_response_id = nil;
        self.disease = nil;
        self.type_diagnostic = nil;
        self.status = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.specialist_response_id <- map["specialist_response_id"];
        self.disease <- map["disease"];
        self.type_diagnostic <- map["type_diagnostic"];
        self.status <- map["status"];
        super.mapping(map: map);
    }
}
