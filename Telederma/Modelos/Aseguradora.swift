//
//  Aseguradora.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Aseguradora: ModeloBase {
    
    // Almacenará una lista de aseguradoras en memoria.
    static var aseguradoras = [Aseguradora]();
    
    var code: String?;
    var name: String?;
    
    override init() {
        self.code = String();
        self.name = String();
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.code <- map["code"];
        self.name <- map["name"];
        super.mapping(map: map);
    }
}
