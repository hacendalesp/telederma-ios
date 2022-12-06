//
//  ImplDaoCie10.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright Â© 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class DaoCie10 {
    
    var sql: SQLCie10;
    var conexion: Conexion;
    
    init(conexion: Conexion) {
        self.conexion = conexion;
        self.sql = SQLCie10(db: self.conexion.obtenerConexion());
    }
    
    /**
     Permite crear la tabla en la base de datos
     */
    func crearTabla() {
        do {
            try self.sql.crearTabla();
        } catch {
            print("Error crear Cie10: \(error)")
        }
    }
    
    /**
     Permite insertar un conjunto de datos.
     - Parameter data: Corresponde a una lista de objetos Cie10.
     - Returns: -1 si el registro fue incompleto, : 0 si no se registrÃ³ ninÃºn dato, : 1 si el registro fue exitoso
     */
    func insertarRegistros(data: [Cie10]) -> Int {
        do {
            let result = try self.sql.insertarRegistros(data: data);
            return result;
        } catch {
            print("Error insertar registros Cie10: \(error)")
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter idRegistro: Corresponde al nÃºmero entero que corresponda al campo id de la tabla. Con este dato se buscarÃ¡ y actualizarÃ¡ el registro.
     - Parameter data: Corresponde al objeto con la informaciÃ³n nueva.
     - Returns: 0 cuando no se realizÃ³ el registro, : 1 cuando se actualizÃ³ exitosamente.
     */
    func actualizarRegistro(idRegistro: Int, data: Cie10) -> Int {
        do {
            let result = try self.sql.actualizarRegistro(idRegistro: idRegistro, data: data);
            return result;
        } catch {
            print("Error actualizar Cie10: \(error)");
            return 0;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos Cie10.
     */
    func seleccionarRegistrosTodo() -> [Cie10] {
        do {
            let result = try self.sql.seleccionarRegistrosTodo();
            return result;
        } catch {
            print("Error seleccionar todo Cie10: \(error)");
            return [Cie10]();
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su id.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la informaciÃ³n.
     - Returns: Devuelve un objeto Cie10 opcional.
     */
    func seleccionarRegistroPorId(idRegistro: Int) -> Cie10? {
        do {
            let result = try self.sql.seleccionarRegistrosPorId(idRegistro: idRegistro);
            return result;
        } catch {
            print("Error seleccionar por id Cie10: \(error)")
            return nil;
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su nombre.
     - Parameter nombre: Corresponde al nombre del registro del cual se desea obtener la informaciÃ³n.
     - Returns: Devuelve un objeto Cie10 opcional.
     */
    func seleccionarUnRegistroPorNombre(nombre: String) -> Cie10? {
        do {
            let result = try self.sql.seleccionarUnRegistroPorNombre(nombre: nombre);
            return result;
        } catch {
            print("Error seleccionar por nombre CIE10: \(error)")
            return nil;
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su código.
     - Parameter codigo: Corresponde al código del registro del cual se desea obtener la informaciÃ³n.
     - Returns: Devuelve un objeto Cie10 opcional.
     */
    func seleccionarUnRegistroPorCodigo(codigo: String) -> Cie10? {
        do {
            let result = try self.sql.seleccionarUnRegistroPorCodigo(codigo: codigo);
            return result;
        } catch {
            print("Error seleccionar por codigo CIE10: \(error)")
            return nil;
        }
    }
    
    /**
     Permite eliminar un registro de la base de datos.
     - Parameter idRegistro: Correponde al id del registro que se desea eliminar.
     - Returns: 0: si no se eliminÃ³ el registro, 1: si se eliminÃ³ el registro.
     */
    func eliminarRegistro(idRegistro: Int) -> Int {
        do {
            let result = try self.sql.eliminarRegistro(idRegistro: idRegistro);
            return result;
        } catch {
            print("Error eliminar Cie10: \(error)");
            return 0;
        }
    }
    
    
}
