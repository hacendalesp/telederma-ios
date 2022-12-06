//
//  HttpConsultaMedica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 28/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpControlMedico: HttpBase {
    /**
     Permite registrar un control en el servidor sin envío de imágenes.
     - Parameter control: Corresonde a un diccionario con la información del control. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarControlMedicoSinAdjuntos (control: ControlMedico) -> Result<Any> {
        let url = "api/v1/medical_controls.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        let parametros: [String : Any] = [
            "consultation_control[consultation_id]": control.consultation_id!,
            
            "medical_control[subjetive_improvement]": control.subjetive_improvement!,
            "medical_control[did_treatment]": control.did_treatment!,
            "medical_control[tolerated_medications]": control.tolerated_medications!,
            "medical_control[clinic_description]": control.clinic_description!,
            "medical_control[annex_description]": control.annex_description!,
            
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
    
    /**
     Permite registrar un control médico.
     - Parameter control: Corresonde a un diccionario con la información del control. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarControlConAdjuntos (control: Dictionary<String, String>, adicionales: [String: String], adjuntos: [Adjunto]) -> SessionManager.MultipartFormDataEncodingResult {
        let url = "api/v1/medical_controls.json";
        let headers = [
            "imei" : Constantes.UDID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ];
        let request = super.realizarPeticionPostConParametrosConAdjuntos(url: url, parametrosArray: control, nombreParametrosArray: "medical_control", adicionales: adicionales, headers: headers, adjuntos: adjuntos);
        return request;
    }
}
