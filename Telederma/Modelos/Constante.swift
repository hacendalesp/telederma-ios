//
//  Constantes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 10/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Constante: ModeloBase {
    
    // Almacenará una lista de constantes en memoria.
    static var constantes = [Constante]();
    
    var type: String?;
    
    override init() {
        self.type = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init();
    }
    
    override func mapping(map: Map) {
        self.type <- map["type"];
        super.mapping(map: map);
    }
    
}
