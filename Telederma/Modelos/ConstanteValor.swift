//
//  Constantes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 10/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ConstanteValor: ModeloBase {
    
    // Almacenará una lista de constantes-valores en memoria.
    static var constantesValores = [ConstanteValor]();
    
    var title: String?;
    var value: Int?;
    var type: String?;
    
    override init() {
        self.title = nil;
        self.value = nil;
        self.type = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init();
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map);
    }
}
