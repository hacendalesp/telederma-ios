//
//  DaoAseguradora.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright Â© 2020 Pedro Erazo Acosta. All rights reserved.
//


import UIKit

class DaoAseguradora {
    
    var sql: SQLAseguradora;
    var conexion: Conexion;
    
    init(conexion: Conexion) {
        self.conexion = conexion;
        self.sql = SQLAseguradora(db: self.conexion.obtenerConexion());
    }
    
    /**
     Permite crear la tabla en la base de datos
     */
    func crearTabla() {
        do {
            try self.sql.crearTabla();
        } catch {
            print("Error crear Aseguradora: \(error)")
        }
    }
    
    /**
     Permite insertar un conjunto de datos.
     - Parameter data: Corresponde a una lista de objetos Aseguradora.
     - Returns: -1 si el registro fue incompleto, : 0 si no se registrÃ³ ninÃºn dato, : 1 si el registro fue exitoso
     */
    func insertarRegistros(data: [Aseguradora]) -> Int {
        do {
            let result = try self.sql.insertarRegistros(data: data);
            return result;
        } catch {
            print("Error insertar registros Aseguradora: \(error)")
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter idRegistro: Corresponde al nÃºmero entero que corresponda al campo id de la tabla. Con este dato se buscarÃ¡ y actualizarÃ¡ el registro.
     - Parameter data: Corresponde al objeto con la informaciÃ³n nueva.
     - Returns: 0 cuando no se realizÃ³ el registro, : 1 cuando se actualizÃ³ exitosamente.
     */
    func actualizarRegistro(idRegistro: Int, data: Aseguradora) -> Int {
        do {
            let result = try self.sql.actualizarRegistro(idRegistro: idRegistro, data: data);
            return result;
        } catch {
            print("Error actualizar Aseguradora: \(error)");
            return 0;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos Aseguradora.
     */
    func seleccionarRegistrosTodo() -> [Aseguradora] {
        do {
            let result = try self.sql.seleccionarRegistrosTodo();
            return result;
        } catch {
            print("Error seleccionar todo Aseguradora: \(error)");
            return [Aseguradora]();
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su id.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la informaciÃ³n.
     - Returns: Devuelve un objeto Aseguradora opcional.
     */
    func seleccionarRegistroPorId(idRegistro: Int) -> Aseguradora? {
        do {
            let result = try self.sql.seleccionarRegistrosPorId(idRegistro: idRegistro);
            return result;
        } catch {
            print("Error seleccionar por id Aseguradora: \(error)")
            return nil;
        }
    }
    
    /**
     Permite seleccionar los registros de la tabla con filtro de nombre.
     - Returns: Devuelve una lista de objetos Aseguradora.
     */
    func seleccionarRegistrosPorName(cadena: String) -> [Aseguradora] {
        do {
            let result = try self.sql.seleccionarRegistrosPorName(cadena: cadena);
            return result;
        } catch {
            print("Error seleccionar todo Aseguradora: \(error)");
            return [Aseguradora]();
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su nombre.
     - Parameter nombre: Corresponde al nombre del registro del cual se desea obtener la informaciÃ³n.
     - Returns: Devuelve un objeto Aseguradora opcional.
     */
    func seleccionarUnRegistroPorNombre(nombre: String) -> Aseguradora? {
        do {
            let result = try self.sql.seleccionarUnRegistroPorNombre(nombre: nombre);
            return result;
        } catch {
            print("Error seleccionar por id Aseguradora: \(error)")
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
            print("Error eliminar Aseguradora: \(error)");
            return 0;
        }
    }
    
    
}

