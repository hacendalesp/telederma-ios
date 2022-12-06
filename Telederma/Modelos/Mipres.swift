//
//  Mipres.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Mipres: ModeloBase {
    var specialist_response_id: Int?;
    var mipres: String?;
    
    override init() {
        self.specialist_response_id = nil;
        self.mipres = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.specialist_response_id <- map["specialist_response_id"];
        self.mipres <- map["mipres"];
        super.mapping(map: map);
    }
}
