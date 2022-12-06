//
//  ParteCuerpo.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ParteCuerpo: ModeloBase {
    // Almacenará una lista de parte cuerpo en memoria.
    static var partesCuerpo = [ParteCuerpo]();
    
    var name: String?;
    
    override init() {
        self.name = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.name <- map["name"];
        super.mapping(map: map);
    }
}
