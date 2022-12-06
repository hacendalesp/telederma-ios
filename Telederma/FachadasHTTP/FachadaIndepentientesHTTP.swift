//
//  FachadaIndependientes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FachadaIndependientesHTTP: NSObject {
    
    /*
     MÓDULO DEPARTAMENTO
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con Departamentos y Municipios.
     El método almacena el resultado de la consulta a la API en dos variables de clase, una en el módulo Departamento y otra en el módulo Municipio.
     */
    class func obtenerTodoHttpDepartamento() -> Result<Any> {
        // Se inicializa la lista cada vez que se consulta con el servicio.
        let httpDepartamento = HttpDepartamento();
        // Se realiza la consulta a la API
        let result = httpDepartamento.obtenerTodoDepartamento();
        return result;
    }
    
    
    /*
     MÓDULO CONSTANTES
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con Constantes y ConstantesValores.
     El método almacena el resultado de la consulta a la API en dos variables de clase, una en el módulo Constantes y otra en el módulo ConstantesValor.
     */
    class func obtenerTodoHttpConstante() -> Result<Any> {
        let httpConstante = HttpConstante();
        // Se realiza la consulta a la API
        let result = httpConstante.obtenerTodoConstante();
        return result;
    }
    
    
    /*
     MÓDULO ASEGURADORA
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con Aseguradora.
     El método almacena el resultado de la consulta a la API en una variable de clase, en el módulo Aseguradora.
     */
    class func obtenerTodoHttpAseguradora() -> Result<Any> {
        let httpAseguradora = HttpAseguradora();
        // Se realiza la consulta a la API
        let result = httpAseguradora.obtenerTodoAseguradoras();
        return result;
    }
    
    
    /*
     MÓDULO CIE10
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con Cie10.
     El método almacena el resultado de la consulta a la API en una variable de clase, en el módulo Cie10.
     */
    class func obtenerTodoHttpCie10() -> Result<Any> {
        let httpCie10 = HttpCie10();
        // Se realiza la consulta a la API
        let result = httpCie10.obtenerTodoCie10();
        return result;
    }
    
    /*
     MÓDULO PARTE CUERPO
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con ParteCuerpo.
     El método almacena el resultado de la consulta a la API en una variable de clase.
     */
    class func obtenerTodoHttpParteCuerpo() -> Result<Any> {
        // Se inicializa la lista cada vez que se consulta con el servicio.
        let httpParteCuerpo = HttpParteCuerpo();
        // Se realiza la consulta a la API
        let result = httpParteCuerpo.obtenerTodoParteCuerpo();
        return result;
    }
    
    
}
