//
//  HttpConsultaMedica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 28/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpConsultaMedica: HttpBase {
    /**
     Permite obtener toda la información asociada a ConsultaMedica de un cliente.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoConsultaMedica (parametros: [String: Any]) -> Result<Any> {
        let url = "api/v1/consultations/all_information.json";
        var parametrosFInal = parametros;
        parametrosFInal["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as? String;
        parametrosFInal["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as? String;
        
        let headers = [
            "imei": Constantes.UDID
        ];
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametrosFInal, headers: headers);
        return request;
    }
    
    /**
     Permite obtener toda la información asociada a una consulta.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoConsultaMedicaPorId (parametros: [String: String]) -> Result<Any> {
        let url = "api/v1/consultations/show_information.json";
        var parametrosFInal = parametros;
        parametrosFInal["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as? String;
        parametrosFInal["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as? String;
        
        let headers = [
            "imei": Constantes.UDID
        ];
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametrosFInal, headers: headers);
        return request;
    }
    
    /**
     Permite registrar una consulta en el servidor sin envío de imágenes.
     - Parameter consulta: Corresonde a un diccionario con la información de la consulta. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarConsultaSinAdjuntos (consulta: ConsultaMedica) -> Result<Any> {
        let url = "api/v1/consultations.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        let parametros: [String : Any] = [
            "consultation[patient_information_id]": consulta.patient_information_id!,
            "consultation[annex_description]": consulta.annex_description!,
            "consultation[diagnostic_impression]": consulta.diagnostic_impression!,
            
            "medical_consultation[evolution_time]": consulta.evolution_time!,
            "medical_consultation[unit_measurement]": consulta.unit_measurement!,
            "medical_consultation[weight]": consulta.weight!,
            "medical_consultation[consultation_id]": consulta.consultation_id ?? "",
            "medical_consultation[number_injuries]": consulta.number_injuries ?? "",
            "medical_consultation[evolution_injuries]": consulta.evolution_injuries ?? "",
            "medical_consultation[blood]": consulta.blood!,
            "medical_consultation[exude]": consulta.exude!,
            "medical_consultation[suppurate]": consulta.suppurate!,
            "medical_consultation[symptom]": consulta.symptom!,
            "medical_consultation[change_symptom]": consulta.change_symptom!,
            "medical_consultation[other_factors_symptom]": consulta.other_factors_symptom ?? "",
            "medical_consultation[aggravating_factors]": consulta.aggravating_factors ?? "",
            "medical_consultation[personal_history]": consulta.personal_history ?? "",
            "medical_consultation[family_background]": consulta.family_background ?? "",
            "medical_consultation[treatment_received]": consulta.treatment_received ?? "",
            "medical_consultation[applied_substances]": consulta.applied_substances ?? "",
            "medical_consultation[treatment_effects]": consulta.treatment_effects ?? "",
            "medical_consultation[description_physical_examination]": consulta.description_physical_examination!,
            
            "medical_consultation[type_remission]": consulta.type_remission ?? "",
            "medical_consultation[remission_comments]": consulta.remission_comments ?? "",
            "medical_consultation[count_controls]": consulta.count_controls ?? "",
            "medical_consultation[treatment]": consulta.treatment ?? "",
            "medical_consultation[type_professional]": consulta.type_professional ?? "",
            "medical_consultation[patient_id]": consulta.patient_id ?? "",
            "medical_consultation[doctor_id]": consulta.doctor_id ?? "",
            "medical_consultation[ciediezcode]": consulta.ciediezcode ?? "",
            
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
    
    /**
     Permite archivar o desarchivar una consulta.
     - Parameter consultaId: Corresonde a un diccionario con la información de la consulta. Es de tipo [String, Any].
     - Parameter esArchivar: Corresponde a un valor booleano para saber si lo que se desea es archivar o desarchivar.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func archivarDesarchivarConsulta (consultaId: Int, esArchivar: Bool) -> Result<Any> {
        let url = "api/v1/consultations/archived_consultation.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        let parametros: [String : Any] = [
            "id": consultaId,
            "tipo": esArchivar ? 1 : 2,
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
    
    /**
     Permite compartir una consulta.
     - Parameter consultaIds: Corresonde a un arreglo de enteros con los IDs de las consultas de un paciente.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func compartirConsulta (consultaIds: [String]) -> Result<Any> {
        let url = "api/v1/consultations/shared_consultations.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        
        let parametros: [String : Any] = [
            "consult_ids": consultaIds,
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
}
