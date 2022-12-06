//
//  FachadaDependientesSQL.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class FachadaDependientesSQL: NSObject {
    
    /*
     MÓDULO PACIENTE
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Paciente
     */
    class func crearTablaPaciente(conexion: Conexion) {
        let dao = DaoPaciente(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Paciente
     - Parameter data: Corresponde a una lista de objetos Paciente
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosPaciente(conexion: Conexion, data: [Paciente]) -> Int{
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite registrar un Paciente
     - Parameter data: Corresponde al objeto Paciente
     - Returns: 0: si no registró información,  ID: si el registro fue exitoso.
     */
    class func insertarRegistroPaciente(conexion: Conexion, data: Paciente) -> Int{
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.insertarRegistro(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Paciente
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Paciente que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroPaciente(conexion: Conexion, idRegistro: Int, data: Paciente) -> Int {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro offline Paciente
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Paciente que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroPacienteOffline(conexion: Conexion, idRegistro: Int, data: Paciente) -> Int {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.actualizarRegistroOffline(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Paciente]
     */
    class func seleccionarTodoPaciente(conexion: Conexion) -> [Paciente] {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Paciente (opcional) o nil.
     */
    class func seleccionarPorIdPaciente(conexion: Conexion, idRegistro: Int) -> Paciente? {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite seleccionar registros según estado sincronizado.
     - Parameter estaSincronizado: Corresponde al estado sincronizado de los registros que se desea consultar
     - Returns: Devuelve un conjunto de objetos Paciente.
     */
    class func seleccionarPorSincronizadoPaciente(conexion: Conexion, estaSincronizado: Bool) -> [Paciente] {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.seleccionarRegistroPorSincronizado(estaSincronizado: estaSincronizado);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroPaciente(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoPaciente(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO INFORMACIÓN PACIENTE
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Información Paciente
     */
    class func crearTablaInformacionPaciente(conexion: Conexion) {
        let dao = DaoInformacionPaciente(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para InformacionPaciente
     - Parameter data: Corresponde a una lista de objetos InformacionPaciente
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosInformacionPaciente(conexion: Conexion, data: [InformacionPaciente]) -> Int{
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite registrar un objeto InformacionPaciente
     - Parameter data: Corresponde a un objeto InformacionPaciente
     - Returns: 0: si no registró información, ID: si el registro fue exitoso.
     */
    class func insertarRegistroInformacionPaciente(conexion: Conexion, data: InformacionPaciente) -> Int{
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.insertarRegistro(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro InformacionPaciente
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto InformacionPaciente que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroInformacionPaciente(conexion: Conexion, idRegistro: Int, data: InformacionPaciente) -> Int {
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro offline InformacionPaciente
     - Parameter idRegistro: Corresponde al id local del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto InformacionPaciente que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroInformacionPacienteOffline(conexion: Conexion, idRegistro: Int, data: InformacionPaciente) -> Int {
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.actualizarRegistroOffline(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [InformacionPaciente]
     */
    class func seleccionarTodoInformacionPaciente(conexion: Conexion) -> [InformacionPaciente] {
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto InformacionPaciente (opcional) o nil.
     */
    class func seleccionarPorIdInformacionPaciente(conexion: Conexion, idRegistro: Int) -> InformacionPaciente? {
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroInformacionPaciente(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoInformacionPaciente(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO HELPDESK
     */
    
    /**
     Permite crear la tabla correspondiente al módulo HelpDesk
     */
    class func crearTablaHelpDesk(conexion: Conexion) {
        let dao = DaoHelpDesk(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para HelpDesk
     - Parameter data: Corresponde a una lista de objetos HelpDesk
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosHelpDesk(conexion: Conexion, data: [HelpDesk]) -> Int{
        let dao = DaoHelpDesk(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro HelpDesk
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto HelpDesk que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroHelpDesk(conexion: Conexion, idRegistro: Int, data: HelpDesk) -> Int {
        let dao = DaoHelpDesk(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [HelpDesk]
     */
    class func seleccionarTodoHelpDesk(conexion: Conexion) -> [HelpDesk] {
        let dao = DaoHelpDesk(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto HelpDesk (opcional) o nil.
     */
    class func seleccionarPorIdHelpDesk(conexion: Conexion, idRegistro: Int) -> HelpDesk? {
        let dao = DaoHelpDesk(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroHelpDesk(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoHelpDesk(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO CRÉTIDOS
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Creditos
     */
    class func crearTablaCreditos(conexion: Conexion) {
        let dao = DaoCreditos(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Creditos
     - Parameter data: Corresponde a una lista de objetos Creditos
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosCreditos(conexion: Conexion, data: [Creditos]) -> Int{
        let dao = DaoCreditos(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Creditos
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Creditos que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroCreditos(conexion: Conexion, idRegistro: Int, data: Creditos) -> Int {
        let dao = DaoCreditos(conexion: conexion);
        let result = dao.actualizarRegistro(data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Creditos]
     */
    class func seleccionarTodoCreditos(conexion: Conexion) -> [Creditos] {
        let dao = DaoCreditos(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /*
     MÓDULO PARTE CUERPO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ParteCuerpo
     */
    class func crearTablaParteCuerpo(conexion: Conexion) {
        let dao = DaoParteCuerpo(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ParteCuerpo
     - Parameter data: Corresponde a una lista de objetos ParteCuerpo
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosParteCuerpo(conexion: Conexion, data: [ParteCuerpo]) -> Int{
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ParteCuerpo
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ParteCuerpo que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroParteCuerpo(conexion: Conexion, idRegistro: Int, data: ParteCuerpo) -> Int {
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ParteCuerpo]
     */
    class func seleccionarTodoParteCuerpo(conexion: Conexion) -> [ParteCuerpo] {
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroParteCuerpo(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO LESIÓN
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Lesiones
     */
    class func crearTablaLesion(conexion: Conexion) {
        let dao = DaoLesion(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Lesion
     - Parameter data: Corresponde a una lista de objetos Lesion
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosLesiones(conexion: Conexion, data: [Lesion]) -> Int{
        let dao = DaoLesion(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Lesion
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Lesion que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroLesiones(conexion: Conexion, idRegistro: Int, data: Lesion) -> Int {
        let dao = DaoLesion(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Lesion]
     */
    class func seleccionarTodoLesiones(conexion: Conexion) -> [Lesion] {
        let dao = DaoLesion(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroLesiones(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoLesion(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO IMAGEN LESIÓN
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ImagenLesiones
     */
    class func crearTablaImagenLesiones(conexion: Conexion) {
        let dao = DaoImagenLesion(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ImagenLesiones
     - Parameter data: Corresponde a una lista de objetos Lesion
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosImagenLesiones(conexion: Conexion, data: [ImagenLesion]) -> Int{
        let dao = DaoImagenLesion(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ImagenLesiones
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ImagenLesiones que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroImagenLesiones(conexion: Conexion, idRegistro: Int, data: ImagenLesion) -> Int {
        let dao = DaoImagenLesion(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ImagenLesion]
     */
    class func seleccionarTodoImagenLesiones(conexion: Conexion) -> [ImagenLesion] {
        let dao = DaoImagenLesion(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroImagenLesiones(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoImagenLesion(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    
    /*
     MÓDULO CONTROL MÉDICO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ControlMedico
     */
    class func crearTablaControlMedico(conexion: Conexion) {
        let dao = DaoControlMedico(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ControlMedico
     - Parameter data: Corresponde a una lista de objetos ControlMedico
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosControlMedico(conexion: Conexion, data: [ControlMedico]) -> Int{
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite registrar un dato para ControlMedico
     - Parameter data: Corresponde a un objeto ControlMedico
     - Returns: 0: si no registró información,  ID: si el registro fue exitoso.
     */
    class func insertarRegistroControlMedico(conexion: Conexion, data: ControlMedico) -> Int{
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.insertarRegistro(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ControlMedico
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ControlMedico que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroControlMedico(conexion: Conexion, idRegistro: Int, data: ControlMedico) -> Int {
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro offline ControlMedico
     - Parameter idRegistro: Corresponde al id local del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ControlMedico que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroControlMedicoOffline(conexion: Conexion, idRegistro: Int, data: ControlMedico) -> Int {
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.actualizarRegistroOffline(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ControlMedico]
     */
    class func seleccionarTodoControlMedico(conexion: Conexion) -> [ControlMedico] {
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar todos los registros según estado sincronizado de la tabla.
     - Returns: Retorna una lista de objetos [ControlMedico]
     */
    class func seleccionarPorSincronizadoControlMedico(conexion: Conexion, estaSincronizado: Bool) -> [ControlMedico] {
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.seleccionarRegistroPorSincronizado(estaSincronizado: estaSincronizado);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroControlMedico(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoControlMedico(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO CONSULTA MEDICA
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ConsultaMedica
     */
    class func crearTablaConsultaMedica(conexion: Conexion) {
        let dao = DaoConsultaMedica(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ConsultaMedica
     - Parameter data: Corresponde a una lista de objetos ConsultaMedica
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosConsultaMedica(conexion: Conexion, data: [ConsultaMedica]) -> Int{
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite registrar un objeto ConsultaMedica
     - Parameter data: Corresponde a un objeto ConsultaMedica
     - Returns: 0: si no registró información, ID: si el registro fue exitoso.
     */
    class func insertarRegistroConsultaMedica(conexion: Conexion, data: ConsultaMedica) -> Int{
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.insertarRegistro(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ConsultaMedica
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ConsultaMedica que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroConsultaMedica(conexion: Conexion, idRegistro: Int, data: ConsultaMedica) -> Int {
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro offline ConsultaMedica
     - Parameter idRegistro: Corresponde al id local del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ConsultaMedica que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroConsultaMedicaOffline(conexion: Conexion, idRegistro: Int, data: ConsultaMedica) -> Int {
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.actualizarRegistroOffline(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ConsultaMedica]
     */
    class func seleccionarTodoConsultaMedica(conexion: Conexion) -> [ConsultaMedica] {
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.seleccionarRegistrosTodoConsultaMedica();
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ConsultaMedica]
     */
    class func seleccionarPorSincronizadoConsultaMedica(conexion: Conexion, estaSincronizado: Bool) -> [ConsultaMedica] {
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.seleccionarRegistrosPorSincronizadoConsultaMedica(estaSincronizado: estaSincronizado);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroConsultaMedica(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoConsultaMedica(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO DIAGNÓSTICO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Diagnostico
     */
    class func crearTablaDiagnostico(conexion: Conexion) {
        let dao = DaoDiagnostico(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Diagnostico
     - Parameter data: Corresponde a una lista de objetos Diagnostico
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosDiagnostico(conexion: Conexion, data: [Diagnostico]) -> Int{
        let dao = DaoDiagnostico(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Diagnostico
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Diagnostico que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroDiagnostico(conexion: Conexion, idRegistro: Int, data: Diagnostico) -> Int {
        let dao = DaoDiagnostico(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Diagnostico]
     */
    class func seleccionarTodoDiagnostico(conexion: Conexion) -> [Diagnostico] {
        let dao = DaoDiagnostico(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroDiagnostico(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoDiagnostico(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO RESPUESTA ESPECIALISTA
     */
    
    /**
     Permite crear la tabla correspondiente al módulo RespuestaEspecialista
     */
    class func crearTablaRespuestaEspecialista(conexion: Conexion) {
        let dao = DaoRespuestaEspecialista(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para RespuestaEspecialista
     - Parameter data: Corresponde a una lista de objetos RespuestaEspecialista
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosRespuestaEspecialista(conexion: Conexion, data: [RespuestaEspecialista]) -> Int{
        let dao = DaoRespuestaEspecialista(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro RespuestaEspecialista
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto RespuestaEspecialista que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroRespuestaEspecialista(conexion: Conexion, idRegistro: Int, data: RespuestaEspecialista) -> Int {
        let dao = DaoRespuestaEspecialista(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [RespuestaEspecialista]
     */
    class func seleccionarTodoRespuestaEspecialista(conexion: Conexion) -> [RespuestaEspecialista] {
        let dao = DaoRespuestaEspecialista(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroRespuestaEspecialista(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoRespuestaEspecialista(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO ESPECIALISTA
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Especialista
     */
    class func crearTablaEspecialista(conexion: Conexion) {
        let dao = DaoEspecialista(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Especialista
     - Parameter data: Corresponde a una lista de objetos Especialista
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosEspecialista(conexion: Conexion, data: [Especialista]) -> Int{
        let dao = DaoEspecialista(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Especialista
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Especialista que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroEspecialista(conexion: Conexion, idRegistro: Int, data: Especialista) -> Int {
        let dao = DaoEspecialista(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Especialista]
     */
    class func seleccionarTodoEspecialista(conexion: Conexion) -> [Especialista] {
        let dao = DaoEspecialista(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroEspecialista(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoEspecialista(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO EXAMEN SOLICITADO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ExamenSolicitado
     */
    class func crearTablaExamenSolicitado(conexion: Conexion) {
        let dao = DaoExamenSolicitado(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ExamenSolicitado
     - Parameter data: Corresponde a una lista de objetos ExamenSolicitado
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosExamenSolicitado(conexion: Conexion, data: [ExamenSolicitado]) -> Int{
        let dao = DaoExamenSolicitado(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ExamenSolicitado
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ExamenSolicitado que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroExamenSolicitado(conexion: Conexion, idRegistro: Int, data: ExamenSolicitado) -> Int {
        let dao = DaoExamenSolicitado(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ExamenSolicitado]
     */
    class func seleccionarTodoExamenSolicitado(conexion: Conexion) -> [ExamenSolicitado] {
        let dao = DaoExamenSolicitado(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroExamenSolicitado(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoExamenSolicitado(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO FÓRMULA
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Formula
     */
    class func crearTablaFormula(conexion: Conexion) {
        let dao = DaoFormula(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Formula
     - Parameter data: Corresponde a una lista de objetos Formula
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosFormula(conexion: Conexion, data: [Formula]) -> Int{
        let dao = DaoFormula(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Formula
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Formula que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroFormula(conexion: Conexion, idRegistro: Int, data: Formula) -> Int {
        let dao = DaoFormula(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Formula]
     */
    class func seleccionarTodoFormula(conexion: Conexion) -> [Formula] {
        let dao = DaoFormula(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroFormula(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoFormula(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO MIPRES
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Mipres
     */
    class func crearTablaMipres(conexion: Conexion) {
        let dao = DaoMipres(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Mipres
     - Parameter data: Corresponde a una lista de objetos Mipres
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosMipres(conexion: Conexion, data: [Mipres]) -> Int{
        let dao = DaoMipres(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Mipres
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Mipres que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroMipres(conexion: Conexion, idRegistro: Int, data: Mipres) -> Int {
        let dao = DaoMipres(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Mipres]
     */
    class func seleccionarTodoMipres(conexion: Conexion) -> [Mipres] {
        let dao = DaoMipres(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroMipres(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoMipres(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO REQUERIMIENTO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Requerimiento
     */
    class func crearTablaRequerimiento(conexion: Conexion) {
        let dao = DaoRequerimiento(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Requerimiento
     - Parameter data: Corresponde a una lista de objetos Requerimiento
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosRequerimiento(conexion: Conexion, data: [Requerimiento]) -> Int{
        let dao = DaoRequerimiento(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Requerimiento
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Requerimiento que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroRequerimiento(conexion: Conexion, idRegistro: Int, data: Requerimiento) -> Int {
        let dao = DaoRequerimiento(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Requerimiento]
     */
    class func seleccionarTodoRequerimiento(conexion: Conexion) -> [Requerimiento] {
        let dao = DaoRequerimiento(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroRequerimiento(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoRequerimiento(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO ARCHIVOS PARA ENVIAR
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ArchivosEnviar
     */
    class func crearTablaArchivosEnviar(conexion: Conexion) {
        let dao = DaoArchivosEnviar(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ArchivosEnviar
     - Parameter data: Corresponde a una lista de objetos ArchivosEnviar
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosArchivosEnviar(conexion: Conexion, data: [ArchivosEnviar]) -> Int{
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro ArchivosEnviar
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto ArchivosEnviar que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroArchivosEnviar(conexion: Conexion, idRegistro: Int, data: ArchivosEnviar) -> Int {
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ArchivosEnviar]
     */
    class func seleccionarTodoArchivosEnviar(conexion: Conexion) -> [ArchivosEnviar] {
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar el primer registro de la tabla
     - Returns: Retorna un objeto ArchivosEnviar (opcional)
     */
    class func seleccionarPrimerRegistroArchivosEnviar(conexion: Conexion) -> ArchivosEnviar? {
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.seleccionarPrimerRegistro();
        return result;
    }
    
    /**
     Permite seleccionar los registros que pertenezca a un mismo tipo y consulta o control faltantes por enviar.
     - Returns: Retorna un objeto ArchivosEnviar (puede estar vacío)
     */
    class func seleccionarPorTipoConsultaControlArchivosEnviar(conexion: Conexion, tipo: String, consultaControlId: Int, esConsulta: Bool) -> [ArchivosEnviar] {
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.seleccionarPorTipoConsultaControl(tipo: tipo, consultaControlId: consultaControlId, esConsulta: esConsulta);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroArchivosEnviar(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoArchivosEnviar(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
}
