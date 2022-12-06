//
//  LaunchViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/02/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var lblCargando: UILabel!
    var conexion = Conexion();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.conexion.conectarBaseDatos();
        //self.conexion.borrarBaseDeDatos();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID)!)
        /*print(Constantes.UDID);
        print(Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL)!);
        print(Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN)!);*/
        self.inits();
    }
    
    private func inits() {
        Funcionales.estaConectado();
        self.crearTablas();
        self.obtenerDepartamentos();
    }
    
    
    /**
     Si no existen las tablas en el almacenamiento local, las crea.
     */
    private func crearTablas () {
        // Crear todas las tablas.
        
        // Crear independientes.
        FachadaIndependientesSQL.crearTablaDepartamento(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaMunicipio(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaUsuario(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaConstante(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaConstanteValor(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaAseguradora(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaCie10(conexion: self.conexion);
        FachadaIndependientesSQL.crearTablaParteCuerpo(conexion: self.conexion);
        
        // Dependientes
        FachadaDependientesSQL.crearTablaPaciente(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaInformacionPaciente(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaHelpDesk(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaCreditos(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaParteCuerpo(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaLesion(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaImagenLesiones(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaControlMedico(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaDiagnostico(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaRespuestaEspecialista(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaEspecialista(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaExamenSolicitado(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaFormula(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaMipres(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaRequerimiento(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaArchivosEnviar(conexion: self.conexion);
        FachadaDependientesSQL.crearTablaConsultaMedica(conexion: self.conexion);
    }
    
    /**
     Permite consumir el servicio de Departamentos y Municipios. Procesa el resultado y almacena dos datos en memoria.
     */
    private func obtenerDepartamentos () {
        // Se consulta si ya está disponible información en la base de datos interna, para evitar hacer la consulta al servidor.
        let departamentos = FachadaIndependientesSQL.seleccionarTodoDepartamento(conexion: self.conexion);
        if(departamentos.count == 0) {
            DispatchQueue.global(qos: .utility).async {
                // Se realiza la consulta a la API
                let result = FachadaIndependientesHTTP.obtenerTodoHttpDepartamento();
                DispatchQueue.main.async {
                    // Se evalúa el resultado de la consulta.
                    switch result {
                    case let .success(data):
                        // Se realiza la JSON de la respuesta de Alamofire-SwiftyJson
                        let json = JSON(arrayLiteral: data);
                        // Se valida que exista información en la consulta.
                        if (json.count > 0) {
                            // Se inicializa la estructura que almacenará los resultados en memoria.
                            Departamento.departamentos = [];
                            Municipio.municipios = [];
                            // Se recorre el resultado para obtener los objetos y almacenarlos en memoria.
                            for item in json[0].arrayValue {
                                // Se realiza la conversión de JSON a objeto Swift y se almacena en un objeto.
                                let departamento = Departamento(JSONString: item.description);
                                // Se añade el nuevo objeto a la lista estática.
                                Departamento.departamentos.append(departamento!);
                                Municipio.municipios.append(contentsOf: departamento?.municipalities ?? []);
                            }
                            self.guardarDepartamentos();
                        }
                    case let .failure(error):
                        print(error);
                    }
                }
            }
        } else {
            self.guardarDepartamentos();
        }
    }
    
    /**
     Permite tomar los datos en memoria y almacenarlos en la base de datos interna.
     */
    private func guardarDepartamentos () {
        let rDepartamento = FachadaIndependientesSQL.insertarRegistrosDepartamento(conexion: self.conexion, data: Departamento.departamentos);
        
        // Se valida si la respuesta al guardar departamentos es positiva, se sigue con los municipios.
        if(rDepartamento > 0){
            let _ = FachadaIndependientesSQL.insertarRegistrosMunicipio(conexion: self.conexion, data: Municipio.municipios);
            
            
            // PENDIENTE OFFLINE
        }
        
        // Siguen los demás módulos
        self.obtenerConstantes();
    }
    
    /**
     Permite consumir el servicio de Constantes y ConstantesValores. Procesa el resultado y almacena dos datos en memoria.
     */
    private func obtenerConstantes () {
        // Se consulta si ya está disponible información en la base de datos interna, para evitar hacer la consulta al servidor.
        let constantes = FachadaIndependientesSQL.seleccionarTodoConstante(conexion: self.conexion);
        if(constantes.count == 0) {
            DispatchQueue.global(qos: .utility).async {
                // Se realiza la consulta a la API
                let result = FachadaIndependientesHTTP.obtenerTodoHttpConstante();
                DispatchQueue.main.async {
                    // Se evalúa el resultado de la consulta.
                    switch result {
                    case let .success(data):
                        // Se realiza la JSON de la respuesta de Alamofire-SwiftyJson - json[0]["constants"]
                        let json = JSON(arrayLiteral: data);
                        // Se valida que exista información en la consulta.
                        if (json[0]["constants"].count > 0) {
                            // Se inicializa la estructura que almacenará los resultados en memoria.
                            Constante.constantes = [];
                            ConstanteValor.constantesValores = [];
                            // Se recorre el resultado para obtener los objetos y almacenarlos en memoria.
                            for item in json[0]["constants"].arrayValue {
                                // Se realiza la conversión de JSON a objeto Swift y se almacena en un objeto.
                                let constante = Constante(JSONString: item.description);
                                Constante.constantes.append(constante!);
                                
                                // Se valida la cantidad de valores que tiene cada tipo.
                                if (item["values"].count > 0) {
                                    for (llave, valor) in item["values"].dictionaryValue {
                                        let constanteValor = ConstanteValor();
                                        constanteValor.type = constante?.type;
                                        constanteValor.title = llave;
                                        constanteValor.value = Int(valor.description);
                                        
                                        // Se añade a la lista de constantes valores, con el type como FK.
                                        ConstanteValor.constantesValores.append(constanteValor);
                                    }
                                }
                            }
                            self.guardarConstantes();
                        }
                    case let .failure(error):
                        print(error);
                    }
                }
            }
        } else {
            self.guardarConstantes();
        }
    }
    
    /**
     Permite tomar los datos en memoria y almacenarlos en la base de datos interna.
     */
    private func guardarConstantes () {
        let rConstante = FachadaIndependientesSQL.insertarRegistrosConstante(conexion: self.conexion, data: Constante.constantes);
        
        // Se valida si la respuesta al guardar constantes es positiva, se sigue con las constantes valores.
        if(rConstante > 0){
            let _ = FachadaIndependientesSQL.insertarRegistrosConstanteValor(conexion: self.conexion, data: ConstanteValor.constantesValores);
            
            // PENDIENTE OFFLINE
        }
        
        // Siguen los demás módulos.
        self.obtenerAseguradoras();
    }
    
    
    /**
     Permite consumir el servicio de Aseguradoras. Procesa el resultado y almacena dos datos en memoria.
     */
    private func obtenerAseguradoras () {
        // Se consulta si ya está disponible información en la base de datos interna, para evitar hacer la consulta al servidor.
        let aseguradoras = FachadaIndependientesSQL.seleccionarTodoAseguradora(conexion: self.conexion);
        if(aseguradoras.count == 0) {
            DispatchQueue.global(qos: .utility).async {
                // Se realiza la consulta a la API
                let result = FachadaIndependientesHTTP.obtenerTodoHttpAseguradora();
                DispatchQueue.main.async {
                    // Se evalúa el resultado de la consulta.
                    switch result {
                    case let .success(data):
                        // Se realiza la JSON de la respuesta de Alamofire-SwiftyJson
                        let json = JSON(arrayLiteral: data);
                        // Se valida que exista información en la consulta.
                        if (json.count > 0) {
                            // Se inicializa la estructura que almacenará los resultados en memoria.
                            Aseguradora.aseguradoras = [];
                            // Se recorre el resultado para obtener los objetos y almacenarlos en memoria.
                            for item in json[0].arrayValue {
                                // Se realiza la conversión de JSON a objeto Swift y se almacena en un objeto.
                                let aseguradora = Aseguradora(JSONString: item.description);
                                // Se añade el nuevo objeto a la lista estática.
                                Aseguradora.aseguradoras.append(aseguradora!);
                            }
                            self.guardarAseguradoras();
                        }
                    case let .failure(error):
                        print(error);
                    }
                }
            }
        } else {
            self.guardarAseguradoras();
        }
    }
    
    /**
     Permite tomar los datos en memoria y almacenarlos en la base de datos interna.
     */
    private func guardarAseguradoras () {
        let _ = FachadaIndependientesSQL.insertarRegistrosAseguradora(conexion: self.conexion, data: Aseguradora.aseguradoras);
        
        // Siguen los demás módulos.
        self.obtenerCie10();
        
        // Pendiente offline
    }
    
    /**
     Permite consumir el servicio de Cie10. Procesa el resultado y almacena dos datos en memoria.
     */
    private func obtenerCie10 () {
        // Se consulta si ya está disponible información en la base de datos interna, para evitar hacer la consulta al servidor.
        let diagnosticos = FachadaIndependientesSQL.seleccionarTodoCie10(conexion: self.conexion);
        if(diagnosticos.count == 0) {
            DispatchQueue.global(qos: .utility).async {
                // Se realiza la consulta a la API
                let result = FachadaIndependientesHTTP.obtenerTodoHttpCie10();
                DispatchQueue.main.async {
                    // Se evalúa el resultado de la consulta.
                    switch result {
                    case let .success(data):
                        // Se realiza la JSON de la respuesta de Alamofire-SwiftyJson
                        let json = JSON(arrayLiteral: data);
                        // Se valida que exista información en la consulta.
                        if (json.count > 0) {
                            // Se inicializa la estructura que almacenará los resultados en memoria.
                            Cie10.cie10s = [];
                            // Se recorre el resultado para obtener los objetos y almacenarlos en memoria.
                            for item in json[0].arrayValue {
                                // Se realiza la conversión de JSON a objeto Swift y se almacena en un objeto.
                                let cie10 = Cie10(JSONString: item.description);
                                // Se añade el nuevo objeto a la lista estática.
                                Cie10.cie10s.append(cie10!);
                            }
                            self.guardarCie10();
                        }
                    case let .failure(error):
                        print(error);
                    }
                }
            }
        } else {
            self.guardarCie10();
        }
    }
    
    /**
     Permite tomar los datos en memoria y almacenarlos en la base de datos interna.
     */
    private func guardarCie10 () {
        let _ = FachadaIndependientesSQL.insertarRegistrosCie10(conexion: self.conexion, data: Cie10.cie10s);
        
        // Siguen los demás módulos.
        self.obtenerParteCuerpo();
        
        // Pendiente offline
                
    }
    
    /**
     Permite consumir el servicio de ParteCuerpo. Procesa el resultado y almacena dos datos en memoria.
     */
    private func obtenerParteCuerpo () {
        // Se consulta si ya está disponible información en la base de datos interna, para evitar hacer la consulta al servidor.
        let parteCuerpo = FachadaIndependientesSQL.seleccionarTodoParteCuerpo(conexion: self.conexion);
        if(parteCuerpo.count == 0) {
            DispatchQueue.global(qos: .utility).async {
                // Se realiza la consulta a la API
                let result = FachadaIndependientesHTTP.obtenerTodoHttpParteCuerpo();
                DispatchQueue.main.async {
                    // Se evalúa el resultado de la consulta.
                    switch result {
                    case let .success(data):
                        // Se realiza la JSON de la respuesta de Alamofire-SwiftyJson
                        let json = JSON(arrayLiteral: data);
                        // Se valida que exista información en la consulta.
                        if (json.count > 0) {
                            // Se inicializa la estructura que almacenará los resultados en memoria.
                            ParteCuerpo.partesCuerpo = [];
                            // Se recorre el resultado para obtener los objetos y almacenarlos en memoria.
                            for item in json[0].arrayValue {
                                // Se realiza la conversión de JSON a objeto Swift y se almacena en un objeto.
                                let parteCuerpo = ParteCuerpo(JSONString: item.description);
                                // Se añade el nuevo objeto a la lista estática.
                                ParteCuerpo.partesCuerpo.append(parteCuerpo!);
                            }
                            self.guardarParteCuerpo();
                        }
                    case let .failure(error):
                        print(error);
                    }
                }
            }
        } else {
            self.guardarParteCuerpo();
        }
    }
    
    /**
     Permite tomar los datos en memoria y almacenarlos en la base de datos interna.
     */
    private func guardarParteCuerpo () {
        let _ = FachadaIndependientesSQL.insertarRegistrosParteCuerpo(conexion: self.conexion, data: ParteCuerpo.partesCuerpo);
        
        // Pendiente offline
        
        self.siguienteView();
    }
    
    /**
     Permite continuar a la siguiente interfaz. Login si no tiene una sesión activa y Consultas en caso contrario.
     */
    private func siguienteView(){
        var vc: UIViewController;
        // Si tiene activa la sesión, se inicia la vista de consultas.
        if let logueado = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_LOGIN) as? Bool {
            if (logueado) {
                vc = self.storyboard!.instantiateViewController(identifier: "view_consulta") as! ConsultaViewController;
            } else {
                // Si no tiene la sesión activa, entonces se inicia la vista del login.
                vc = self.storyboard!.instantiateViewController(identifier: "view_login") as! LoginViewController;
            }
        } else {
            // Si no tiene la sesión activa, entonces se inicia la vista del login.
            vc = self.storyboard!.instantiateViewController(identifier: "view_login") as! LoginViewController;
        }
        
        
        /*// Eliminar cuando se corrija el login
         vc = self.storyboard!.instantiateViewController(identifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;*/
        
        self.present(vc, animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
