//
//  HttpDepartamento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpDepartamento: HttpBase {
    
    /**
     Permite obtener toda la información asociada a Departamentos incluyendo los municipios relacionados a cada uno.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoDepartamento () -> Result<Any> {
        let url = "api/v1/static_resources/departments.json";
        let request = super.realizarPeticionGetSinParametros(url: url);
        return request;
    }
}
