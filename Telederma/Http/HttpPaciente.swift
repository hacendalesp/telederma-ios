//
//  HttpDepartamento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

/**
 Esta clase incluye lo relacionado con la data de información paciente.
 */
class HttpPaciente: HttpBase {
    
    /**
     Permite buscar un paciente en el servidor.
     - Parameter documento: Corresonde al número del documento de identidad del paciente. Es de tipo String.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func buscarPaciente (documento: String) -> Result<Any> {
        let url = "api/v1/patients/\(documento).json";
        let parametros = Parameters.init(dictionaryLiteral:
            ("user_email", Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String), ("user_token", Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String)
        );
        let headers = ["imei" : Constantes.UDID];
        
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametros, headers: headers);
        return request;
    }
    
    /**
     Permite registrar un paciente en el servidor.
     - Parameter paciente: Corresonde a un diccionario con la información del paciente. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarPaciente (paciente: Paciente, informacion: InformacionPaciente) -> Result<Any> {
        let url = "api/v1/patients.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        let parametros: [String : Any] = [
            "patient[type_document]": paciente.type_document!,
            "patient[type_condition]": paciente.type_condition ?? "",
            "patient[number_document]": paciente.number_document!,
            "patient[number_inpec]": paciente.number_inpec ?? "",
            "patient[name]": paciente.name!,
            "patient[second_name]": (paciente.second_name == Mensajes.NO_REPORTA) ? "" : paciente.second_name ?? "",
            "patient[last_name]": paciente.last_name!,
            "patient[second_surname]": (paciente.second_surname == Mensajes.NO_REPORTA) ? "" : paciente.second_surname ?? "",
            "patient[birthdate]": paciente.birthdate!,
            "patient[genre]": paciente.genre!,
            
            "patient_information[terms_conditions]": informacion.terms_conditions!,
            "patient_information[civil_status]": informacion.civil_status!,
            "patient_information[occupation]": (informacion.occupation == Mensajes.NO_REPORTA) ? "" : informacion.occupation ?? "",
            "patient_information[phone]": (informacion.phone == Mensajes.NO_REPORTA) ? "" : informacion.phone ?? "",
            "patient_information[email]": (informacion.email == Mensajes.NO_REPORTA) ? "" : informacion.email ?? "",
            "patient_information[address]": (informacion.address == Mensajes.NO_REPORTA) ? "" : informacion.address ?? "",
            "patient_information[municipality_id]": informacion.municipality_id!,
            "patient_information[urban_zone]": informacion.urban_zone!,
            "patient_information[companion]": informacion.companion!,
            "patient_information[name_companion]": (informacion.name_companion == Mensajes.NO_REPORTA) ? "" : informacion.name_companion ?? "",
            "patient_information[phone_companion]": (informacion.phone_companion == Mensajes.NO_REPORTA) ? "" : informacion.phone_companion ?? "",
            "patient_information[responsible]": informacion.responsible!,
            "patient_information[name_responsible]": (informacion.name_responsible == Mensajes.NO_REPORTA) ? "" : informacion.name_responsible ?? "",
            "patient_information[phone_responsible]": (informacion.phone_responsible == Mensajes.NO_REPORTA) ? "" : informacion.phone_responsible ?? "",
            "patient_information[relationship]": (informacion.relationship == Mensajes.NO_REPORTA) ? "" : informacion.relationship ?? "",
            "patient_information[type_user]": informacion.type_user!,
            "patient_information[authorization_number]": (informacion.authorization_number == Mensajes.NO_REPORTA) ? "" : informacion.authorization_number ?? "",
            "patient_information[purpose_consultation]": informacion.purpose_consultation ?? "",
            "patient_information[external_cause]": informacion.external_cause!,
            "patient_information[insurance_id]": informacion.insurance_id!,
            "patient_information[unit_measure_age]": informacion.unit_measure_age!,
            "patient_information[age]": informacion.age!,
            "patient_information[patient_id]": informacion.patient_id ?? "",
            
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
}
