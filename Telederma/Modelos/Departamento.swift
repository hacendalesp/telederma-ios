//
//  Departamento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Departamento: ModeloBase {
    
    // Almacenará una lista de departamentos en memoria.
    static var departamentos = [Departamento]();
    
    var name: String?;
    var municipalities: [Municipio]?;
    
    override init() {
        self.name = nil;
        self.municipalities = nil;
        super.init();
    }    
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.name <- map["name"];
        self.municipalities <- map["municipalities"];
        super.mapping(map: map);
    }
}
