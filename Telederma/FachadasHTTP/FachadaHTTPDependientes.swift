//
//  FachadaHTTPDependientes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FachadaHTTPDependientes: NSObject {
    
    /*
     MÓDULO USUARIO
     */
    
    /**
     Permite realizar el registro de usuario.
     - Parameter usuario: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarUsuario (usuario: Dictionary<String, Any>) -> Result<Any> {
        let httpUsuario = HttpUsuario();
        return httpUsuario.registrarUsuario(usuario: usuario);
    }
    
    /**
     Permite registrar un usuario, con envío de imágenes en simultáneo.
     - Parameter usuario: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarUsuarioConImagenes (usuario: Dictionary<String, String>, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let httpUsuario = HttpUsuario();
        return httpUsuario.registrarUsuarioConImagenes(usuario: usuario, imagenes: imagenes);
    }
    
    /**
     Permite comprobar si un usuario existe para poder iniciar sesión.
     - Parameter documento: Corresponde al número del documento del usuario (String).
     - Parameter password: Corresponde a la contraseña del usuario (String).
     - Returns: Devuelve un objeto Result<Any> Alamofire.
     */
    class func iniciarSesion (documento: String, password: String) -> Result<Any> {
        let httpUsuario = HttpUsuario();
        return httpUsuario.iniciarSesion(documento: documento, password: password);
    }
    
    /**
     Permite enviar una solicitud para el restablecimiento de la contraseña.
     - Parameter documento: Corresponde al documento del usuario quien realiza la solicitud.
     - Returns: Devuelve un objeto Result <Any> Alamofire.
     */
    class func restablecerPassword (documento: String) -> Result<Any> {
        let httpUsuario = HttpUsuario();
        let request = httpUsuario.restablecerPassword(documento: documento);
        return request;
    }
    
    /**
     Permite realizar actualización del perfil del usuario.
     - Parameter usuario: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func actualizarPerfilUsuario (usuario: Dictionary<String, Any>, adicionales: [String: String]?) -> Result<Any> {
        let httpUsuario = HttpUsuario();
        return httpUsuario.actualizarPerfilUsuario(usuario: usuario, adicionales: adicionales);
    }
    
    /**
     Permite realizar actualización del perfil del usuario.
     - Parameter usuario: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func actualizarPerfilUsuarioConImagenes (usuario: Dictionary<String, String>, adicionales: [String: String]?, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let httpUsuario = HttpUsuario();
        return httpUsuario.actualizarPerfilUsuarioConImagenes(usuario: usuario, adicionales: adicionales, imagenes: imagenes);
    }
    
    /**
     Permite certificar un usuario médico.
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func certificarUsuario () -> Result<Any> {
        let httpUsuario = HttpUsuario();
        return httpUsuario.certificarUsuario();
    }
    
    /*
     MÓDULO PACIENTE
     */
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con un paciente.
     - Parameter documento: Corresponde al documento del paciente que se desea consultar.
     - Returns: Devuelve un objeto respuesta de tipo Result Any.
     */
    class func obtenerHttpPacientePorDocumento(documento: String) -> Result<Any> {
        let httpPaciente = HttpPaciente();
        // Se realiza la consulta a la API
        let result = httpPaciente.buscarPaciente(documento: documento);
        return result;
    }
    
    /**
     Permite realizar el registro de paciente.
     - Parameter paciente: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarHttpPaciente (paciente: Paciente, informacion: InformacionPaciente) -> Result<Any> {
        let httpPaciente = HttpPaciente();
        return httpPaciente.registrarPaciente(paciente: paciente, informacion: informacion);
    }
    
    
    /*
     MÓDULO HELPDESK
     */
    
    /**
     Permite realizar el registro de HelpDesk.
     - Parameter helpDesk: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarHttpHelpDeskSinImagenes (helpDesk: Dictionary<String, Any>) -> Result<Any> {
        let httpHelpDesk = HttpHelpDesk();
        return httpHelpDesk.registrarHelpDeskSinImagenes(helpDesk: helpDesk);
    }
    
    /**
     Permite registrar helpDesk, con envío de imágenes en simultáneo.
     - Parameter helpDesk: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarHttpHelpDeskConImagenes (helpDesk: Dictionary<String, String>, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let httpHelpDesk = HttpHelpDesk();
        return httpHelpDesk.registrarHelpDeskConImagenes(helpDesk: helpDesk, imagenes: imagenes);
    }
    
    /**
     Permite conectarse con la API para obtener toda la información relacionada con Tickets de un cliente.
     */
    class func obtenerTodoHttpTickets() -> Result<Any> {
        // Se inicializa la lista cada vez que se consulta con el servicio.
        let httpHelpDesk = HttpHelpDesk();
        // Se realiza la consulta a la API
        let result = httpHelpDesk.obtenerTodoTickets();
        return result;
    }
    
    
    /*
     MÓDULO CRÉDITOS
     */
    
    /**
     Permite realizar el registro de Creditos.
     - Parameter creditos: corresponde a un objeto de tipo [String, Any].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func obtenerHttpCreditosCliente () -> Result<Any> {
        let httpCreditos = HttpCreditos();
        return httpCreditos.obtenerCreditos();
    }
    
    /*
     MÓDULO CONSULTA MEDICA
     */
    
    /**
     Permite obtener los registros de ConsultaMedica asociados a un médico.
     - Parameter parametros: corresponde a un objeto de tipo [String, Any] con la información del medico y estados.
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func obtenerHttpTodoConsultaMedica (parametros: [String: Any]) -> Result<Any> {
        let httpConsultaMedica = HttpConsultaMedica();
        return httpConsultaMedica.obtenerTodoConsultaMedica(parametros: parametros);
    }
    
    /**
    Permite obtener una ConsultaMedica por su ID.
    - Parameter parametros: corresponde a un objeto de tipo [String, Any] con el ID de la consulta médica.
    - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
    */
    class func obtenerHttpConsultaMedicaPorId (parametros: [String: String]) -> Result<Any> {
        let httpConsultaMedica = HttpConsultaMedica();
        return httpConsultaMedica.obtenerTodoConsultaMedicaPorId(parametros: parametros);
    }
    
    /**
     Permite realizar registro de una consulta.
     - Parameter consulta: corresponde a un objeto de tipo [String, String].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarConsultaSinAdjuntos (consulta: ConsultaMedica) -> Result<Any> {
        let httpConsulta = HttpConsultaMedica();
        return httpConsulta.registrarConsultaSinAdjuntos(consulta: consulta);
    }
    
    /**
     Permite archivar o desarchivar una consulta
     - Parameter consultaId: Corresponde al ID de la consulta.
     - Parameter esArchivar: Corresponde a un valor booleano para saber si se desea archivar o desarchivar.
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func archivarDesarchivarConsulta (consultaId: Int, esArchivar: Bool) -> Result<Any> {
        let httpConsulta = HttpConsultaMedica();
        return httpConsulta.archivarDesarchivarConsulta(consultaId: consultaId, esArchivar: esArchivar);
    }
    
    /**
     Permite compartir una consulta
     - Parameter consultaIds: Corresponde al arreglo de IDs de las consultas de un paciente.
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func compartirConsulta (consultaIds: [String]) -> Result<Any> {
        let httpConsulta = HttpConsultaMedica();
        return httpConsulta.compartirConsulta(consultaIds: consultaIds);
    }
    
    /**
     MÓDULO CONTROL MÉDICO
     */
    
    /**
     Permite realizar registro de un control médico.
     - Parameter control: corresponde a un objeto de tipo [String, String].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarControlMedicoSinAdjuntos (control: ControlMedico) -> Result<Any> {
        let httpControlMedico = HttpControlMedico();
        return httpControlMedico.registrarControlMedicoSinAdjuntos(control: control);
    }
    
    /**
     Permite realizar registro de un control médico.
     - Parameter control: corresponde a un objeto de tipo [String, String].
     - Returns: Devuelve un objeto SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func registrarControlMedicoConAdjuntos (control: Dictionary<String, String>, adicionales: [String: String], adjuntos: [Adjunto]) -> SessionManager.MultipartFormDataEncodingResult {
        let httpControlMedico = HttpControlMedico();
        return httpControlMedico.registrarControlConAdjuntos(control: control, adicionales: adicionales, adjuntos: adjuntos);
    }
    
    /**
     MÓDULO ARCHIVOS ENVIAR
     */
    
    /**
     Permite realizar registro de un archivos enviar para la posterior actualización de la consulta o control.
     Se envía un objeto a la vez de manera síncrona.
     - Parameter imagen: Corresponde a un objeto ArchivosEnviar que se sincronizarán con el servidor.
     */
    class func guardarImagenIndividual (imagen: ArchivosEnviar, grupo: String) -> SessionManager.MultipartFormDataEncodingResult {
        let httpArchivosEnviar = HttpArchivosEnviar();
        return httpArchivosEnviar.registroImagenIndividual(imagen: imagen, grupo: grupo);
    }
    
    /**
     Permite actualizar el registro de una consulta asociando los anexos.
     - Parameter idControlConsulta: Corresponde a la llave del control o consulta que se desea asociar con los anexos.
     - Parameter anexos: Corresponde a una lista de urls con la ruta de las imágenes en servidor.
     - Parameter esConsulta: Corresponde a un valor de tipo booleano para saber si es una consulta o es un control.
     */
    class func guardarAnexos (idControlConsulta: Int, anexos: [String: String], esConsulta: Bool) -> Result<Any> {
        let httpArchivosEnviar = HttpArchivosEnviar();
        return httpArchivosEnviar.actualizarAnexoControlConsulta(idControlConsulta: idControlConsulta, anexos: anexos, esConsulta:  esConsulta);
    }
    
    /**
     Permite guardar el registro de una consulta asociando las imágenes de la lesión.
     - Parameter idControlConsulta: Corresponde a la llave del control o consulta que se desea asociar con los anexos.
     - Parameter lesiones: Corresponde a una lista de urls con la ruta de las imágenes en servidor.
     - Parameter esConsulta: Corresponde a un valor de tipo booleano para saber si es una consulta o es un control.
     */
    class func guardarLesiones (idControlConsulta: Int, lesiones: [String: String], adicionales: [String: [String]], esConsulta: Bool) -> Result<Any> {
        let httpArchivosEnviar = HttpArchivosEnviar();
        return httpArchivosEnviar.crearLesionControlConsulta(idControlConsulta: idControlConsulta, lesiones: lesiones, adicionales: adicionales, esConsulta:  esConsulta);
    }
    
    
    /**
     Módulo Requerimientos
     */
    
    /**
     Permite realizar un requerimiento para descartarlo.
     - Parameter adicionales: corresponde a un diccionario de tipo [String: String].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func descartarRequerimiento (adicionales: [String: Any]?) -> Result<Any> {
        let httpRequerimiento = HttpRequerimiento();
        return httpRequerimiento.descartarRequerimiento(adicionales: adicionales);
    }
    
    /**
     Permite realizar un requerimiento para resolverlo.
     - Parameter adicionales: corresponde a un diccionario de tipo [String: String].
     - Returns: Devuelve un objeto Result<Any> de Alamofire. Quien hace el llamado debe evaluar el resultado.
     */
    class func resolverRequerimiento (adicionales: [String: Any]?) -> Result<Any> {
        let httpRequerimiento = HttpRequerimiento();
        return httpRequerimiento.resolverRequerimiento(adicionales: adicionales);
    }
    
}
