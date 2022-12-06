//
//  FachadaIndependientes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class FachadaIndependientesSQL: NSObject {
    
    
    
    /*
     MÓDULO DEPARTAMENTO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Departamento
     */
    class func crearTablaDepartamento(conexion: Conexion) {
        let dao = DaoDepartamento(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Departamento
     - Parameter data: Corresponde a una lista de objetos Departamento
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosDepartamento(conexion: Conexion, data: [Departamento]) -> Int{
        let dao = DaoDepartamento(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Departamento]
     */
    class func seleccionarTodoDepartamento(conexion: Conexion) -> [Departamento] {
        let dao = DaoDepartamento(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Departamento (opcional) o nil.
     */
    class func seleccionarPorIdDepartamento(conexion: Conexion, idRegistro: Int) -> Departamento? {
        let dao = DaoDepartamento(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroDepartamento(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoDepartamento(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO MUNICIPIO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Municipio
     */
    class func crearTablaMunicipio(conexion: Conexion) {
        let dao = DaoMunicipio(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Municipio
     - Parameter data: Corresponde a una lista de objetos Municipio
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosMunicipio(conexion: Conexion, data: [Municipio]) -> Int{
        let dao = DaoMunicipio(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Municipio]
     */
    class func seleccionarTodoMunicipio(conexion: Conexion) -> [Municipio] {
        let dao = DaoMunicipio(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Departamento (opcional) o nil.
     */
    class func seleccionarPorIdMunicipio(conexion: Conexion, idRegistro: Int) -> Municipio? {
        let dao = DaoMunicipio(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite seleccionar registros de la tabla a través de su llave foránea de departaento.
     - Parameter idDepartamento: Corresponde al id del departamento del cual se desea obtener la información.
     - Returns: Devuelve una lista de Departamento.
     */
    class func seleccionarPorDepartamento(conexion: Conexion, idDepartamento: Int) -> [Municipio] {
        let dao = DaoMunicipio(conexion: conexion);
        let result = dao.seleccionarRegistroPorDepartamento(idDepartamento: idDepartamento);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroMunicipio(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoMunicipio(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO USUARIO
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Usuario
     */
    class func crearTablaUsuario(conexion: Conexion) {
        let dao = DaoUsuario(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Usuario
     - Parameter data: Corresponde a una lista de objetos Usuario
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosUsuario(conexion: Conexion, data: [Usuario]) -> Int{
        let dao = DaoUsuario(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    /**
     Permite actualizar un registro Usuario
     - Parameter idRegistro: Corresponde al id del registro que se desea modificar.
     - Parameter data: Corresponde a un objeto Usuario que contiene la información actualizada.
     - Returns: 0: cuando no se realizó la actualización, 1: cuando se actualizó exitosamente.
     */
    class func actualizarRegistroUsuario(conexion: Conexion, idRegistro: Int, data: Usuario) -> Int {
        let dao = DaoUsuario(conexion: conexion);
        let result = dao.actualizarRegistro(idRegistro: idRegistro, data: data);
        return result;
    }
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Usuario]
     */
    class func seleccionarTodoUsuario(conexion: Conexion) -> [Usuario] {
        let dao = DaoUsuario(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Usuario (opcional) o nil.
     */
    class func seleccionarPorIdUsuario(conexion: Conexion, idRegistro: Int) -> Usuario? {
        let dao = DaoUsuario(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroUsuario(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoUsuario(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO CONSTANTE
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Constante
     */
    class func crearTablaConstante(conexion: Conexion) {
        let dao = DaoConstante(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Constante
     - Parameter data: Corresponde a una lista de objetos Constante
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosConstante(conexion: Conexion, data: [Constante]) -> Int{
        let dao = DaoConstante(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Constante]
     */
    class func seleccionarTodoConstante(conexion: Conexion) -> [Constante] {
        let dao = DaoConstante(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Constante (opcional) o nil.
     */
    class func seleccionarPorIdConstante(conexion: Conexion, idRegistro: Int) -> Constante? {
        let dao = DaoConstante(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroConstante(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoConstante(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    /*
     MÓDULO CONSTANTE VALOR
     */
    
    /**
     Permite crear la tabla correspondiente al módulo ConstanteValor
     */
    class func crearTablaConstanteValor(conexion: Conexion) {
        let dao = DaoConstanteValor(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para ConstanteValor
     - Parameter data: Corresponde a una lista de objetos ConstanteValor
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosConstanteValor(conexion: Conexion, data: [ConstanteValor]) -> Int{
        let dao = DaoConstanteValor(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ConstanteValor]
     */
    class func seleccionarTodoConstanteValor(conexion: Conexion) -> [ConstanteValor] {
        let dao = DaoConstanteValor(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto ConstanteValor (opcional) o nil.
     */
    class func seleccionarPorIdConstanteValor(conexion: Conexion, idRegistro: Int) -> ConstanteValor? {
        let dao = DaoConstanteValor(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su tipo.
     - Parameter grupo: Corresponde al tipo de constante con el cual se relaciona.
     - Returns: Devuelve una lista ConstanteValor.
     */
    class func seleccionarPorTipoConstanteValor(conexion: Conexion, grupo: String) -> [ConstanteValor] {
        let dao = DaoConstanteValor(conexion: conexion);
        let result = dao.seleccionarRegistroPorTipo(grupo: grupo);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroConstanteValor(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoConstanteValor(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    /*
     MÓDULO ASEGURADORAS
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Aseguradora
     */
    class func crearTablaAseguradora(conexion: Conexion) {
        let dao = DaoAseguradora(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Aseguradora
     - Parameter data: Corresponde a una lista de objetos Aseguradora
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosAseguradora(conexion: Conexion, data: [Aseguradora]) -> Int{
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Aseguradora]
     */
    class func seleccionarTodoAseguradora(conexion: Conexion) -> [Aseguradora] {
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Aseguradora (opcional) o nil.
     */
    class func seleccionarPorIdAseguradora(conexion: Conexion, idRegistro: Int) -> Aseguradora? {
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite seleccionar los registros de la tabla por filtro de nombre.
     - Returns: Retorna una lista de objetos [Aseguradora]
     */
    class func seleccionarAseguradoraPorNombre(conexion: Conexion, cadena: String) -> [Aseguradora] {
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.seleccionarRegistrosPorName(cadena: cadena);
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su nombre.
     - Parameter nombre: Corresponde al nombre del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Aseguradora (opcional) o nil.
     */
    class func seleccionarPorNombreAseguradora(conexion: Conexion, nombre: String) -> Aseguradora? {
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.seleccionarUnRegistroPorNombre(nombre: nombre);
        return result;
    }
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroAseguradora(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoAseguradora(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
        return result;
    }
    
    
    
    /*
     MÓDULO CIE10
     */
    
    /**
     Permite crear la tabla correspondiente al módulo Cie10
     */
    class func crearTablaCie10(conexion: Conexion) {
        let dao = DaoCie10(conexion: conexion);
        dao.crearTabla();
    }
    
    /**
     Permite registrar varios datos para Cie10
     - Parameter data: Corresponde a una lista de objetos Cie10
     - Returns: 0: si no registró información, -1: si el proceso fue incompleto, 1: si el registro fue exitoso.
     */
    class func insertarRegistrosCie10(conexion: Conexion, data: [Cie10]) -> Int{
        let dao = DaoCie10(conexion: conexion);
        let result = dao.insertarRegistros(data: data);
        return result;
    }
    
    
    /**
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [Cie10]
     */
    class func seleccionarTodoCie10(conexion: Conexion) -> [Cie10] {
        let dao = DaoCie10(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Cie10 (opcional) o nil.
     */
    class func seleccionarPorIdCie10(conexion: Conexion, idRegistro: Int) -> Cie10? {
        let dao = DaoCie10(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su nombre.
     - Parameter nombre: Corresponde al nombre del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Cie10 (opcional) o nil.
     */
    class func seleccionarPorNombreCie10(conexion: Conexion, nombre: String) -> Cie10? {
        let dao = DaoCie10(conexion: conexion);
        let result = dao.seleccionarUnRegistroPorNombre(nombre: nombre);
        return result;
    }
    
    
    /**
     Permite seleccionar un registro de la tabla a través de su código.
     - Parameter codigo: Corresponde al código del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto Cie10 (opcional) o nil.
     */
    class func seleccionarPorCodigoCie10(conexion: Conexion, codigo: String) -> Cie10? {
        let dao = DaoCie10(conexion: conexion);
        let result = dao.seleccionarUnRegistroPorCodigo(codigo: codigo);
        return result;
    }
    
    
    /**
     Permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al id del registro que es desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó exitosamente.
     */
    class func eliminarRegistroCie10(conexion: Conexion, idRegistro: Int) -> Int {
        let dao = DaoCie10(conexion: conexion);
        let result = dao.eliminarRegistro(idRegistro: idRegistro);
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
     Permite seleccionar todos los registros de la tabla.
     - Returns: Retorna una lista de objetos [ParteCuerpo]
     */
    class func seleccionarTodoParteCuerpo(conexion: Conexion) -> [ParteCuerpo] {
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.seleccionarRegistrosTodo();
        return result;
    }
    
    /**
     Permite seleccionar un registro de la tabla a través de su llave primaria.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto ParteCuerpo (opcional) o nil.
     */
    class func seleccionarPorIdParteCuerpo(conexion: Conexion, idRegistro: Int) -> ParteCuerpo? {
        let dao = DaoParteCuerpo(conexion: conexion);
        let result = dao.seleccionarRegistroPorId(idRegistro: idRegistro);
        return result;
    }
    
}
