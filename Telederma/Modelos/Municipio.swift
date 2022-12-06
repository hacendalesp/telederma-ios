//
//  Municipio.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Municipio: ModeloBase {
    
    static var municipios = [Municipio]();
    
    var department_id: Int?;
    var name: String?;
    var code: String?;
    var code_department: String?;
    
    override init() {
        self.department_id = nil;
        self.name = nil;
        self.code = nil;
        self.code_department = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.department_id <- map["department_id"];
        self.name <- map["name"];
        self.code <- map["code"];
        self.code_department <- map["code_department"];
        super.mapping(map: map);
    }
}
