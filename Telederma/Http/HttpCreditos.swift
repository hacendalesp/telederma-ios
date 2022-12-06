//
//  HttpCreditos.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpCreditos: HttpBase {
    /**
     Permite obtener toda la información asociada a los créditos del cliente.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerCreditos () -> Result<Any> {
        let url = "api/v1/especialista/consult/client_credits.json";
        let headers = ["imei": Constantes.UDID];
        let parametros = [
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametros, headers: headers);
        return request;
    }
}
