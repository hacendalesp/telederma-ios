//
//  Lesion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class Lesion: ModeloBase {
    var name_area: String?;
    var enviado: Int?;
    var id_consult_local: Int?;
    var id_control_local: Int?;
    var id_requerimiento: Int?;
    var consultation_id: Int?;
    var consultation_control_id: Int?;
    var body_area_id: Int?;
    var id_local: Int!;
    var sincronizado: Bool!;
    
    override init() {
        self.name_area = nil;
        self.enviado = nil;
        self.id_consult_local = nil;
        self.id_control_local = nil;
        self.id_requerimiento = nil;
        self.consultation_id = nil;
        self.consultation_control_id = nil;
        self.body_area_id = nil;
        self.id_local = Int();
        self.sincronizado = false;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.name_area <- map["name_area"];
        self.enviado <- map["enviado"];
        self.id_requerimiento <- map["id_requerimiento"];
        self.consultation_id <- map["consultation_id"];
        self.consultation_control_id <- map["consultation_control_id"];
        self.body_area_id <- map["body_area_id"];
        super.mapping(map: map);
    }
}
