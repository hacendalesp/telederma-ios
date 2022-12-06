//
//  Cie10.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Cie10: ModeloBase {
    
    // Almacenará una lista de cie10 en memoria.
    static var cie10s = [Cie10]();
    
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
