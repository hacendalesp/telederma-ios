//
//  HttpParteCuerpo.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 28/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpParteCuerpo: HttpBase {
    /**
     Permite obtener toda la información asociada a ParteCuerpo incluyendo los municipios relacionados a cada uno.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoParteCuerpo () -> Result<Any> {
        let url = "api/v1/static_resources/body_areas.json";
        let request = super.realizarPeticionGetSinParametros(url: url);
        return request;
    }
}
