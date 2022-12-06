//
//  Creditos.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Creditos: ModeloBase {
    
    var total: Int?;
    var consumidos: Int?;
    
    override init() {
        self.total = nil;
        self.consumidos = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.total <- map["total"];
        self.consumidos <- map["consumidos"];
        super.mapping(map: map);
    }
}
