//
//  DaoCreditos.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class DaoCreditos: NSObject {
    var sql: SQLCreditos;
    var conexion: Conexion;
    
    init(conexion: Conexion) {
        self.conexion = conexion;
        self.sql = SQLCreditos(db: self.conexion.obtenerConexion());
    }
    
    /**
     Permite crear la tabla en la base de datos
     */
    func crearTabla() {
        do {
            try self.sql.crearTabla();
        } catch {
            print("Error crear Créditos: \(error)")
        }
    }
    
    /**
     Permite insertar un conjunto de datos.
     - Parameter data: Corresponde a una lista de objetos Créditos.
     - Returns: -1 si el registro fue incompleto, : 0 si no se registrÃ³ ninÃºn dato, : 1 si el registro fue exitoso
     */
    func insertarRegistros(data: [Creditos]) -> Int {
        do {
            let result = try self.sql.insertarRegistros(data: data);
            return result;
        } catch {
            print("Error insertar registros Créditos: \(error)")
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter data: Corresponde al objeto con la información nueva.
     - Returns: 0 cuando no se realizó el registro, : 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro(data: Creditos) -> Int {
        do {
            let result = try self.sql.actualizarRegistro(data: data);
            return result;
        } catch {
            print("Error actualizar Créditos: \(error)");
            return 0;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos Créditos.
     */
    func seleccionarRegistrosTodo() -> [Creditos] {
        do {
            let result = try self.sql.seleccionarRegistrosTodo();
            return result;
        } catch {
            print("Error seleccionar todo Créditos: \(error)");
            return [Creditos]();
        }
    }
    
}
