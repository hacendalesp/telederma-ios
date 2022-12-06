//
//  DaoConsultaMedica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class DaoConsultaMedica {
    
    var sql: SQLConsultaMedica;
    var conexion: Conexion;
    
    init(conexion: Conexion) {
        self.conexion = conexion;
        self.sql = SQLConsultaMedica(db: self.conexion.obtenerConexion());
    }
    
    /**
     Permite crear la tabla en la base de datos
     */
    func crearTabla() {
        do {
            try self.sql.crearTabla();
        } catch {
            print("Error crear ConsultaMedica: \(error)")
        }
    }
    
    /**
     Permite insertar un conjunto de datos.
     - Parameter data: Corresponde a una lista de objetos ConsultaMedica.
     - Returns: -1 si el registro fue incompleto, : 0 si no se registró ninún dato, : 1 si el registro fue exitoso
     */
    func insertarRegistros(data: [ConsultaMedica]) -> Int {
        do {
            let result = try self.sql.insertarRegistros(data: data);
            return result;
        } catch {
            print("Error insertar registros ConsultaMedica: \(error)")
            return 0;
        }
    }
    
    /**
     Permite insertar un dato.
     - Parameter data: Corresponde a un objeto ConsultaMedica.
     - Returns: 0 si no se registró ninún dato, : ID si el registro fue exitoso
     */
    func insertarRegistro(data: ConsultaMedica) -> Int {
        do {
            let result = try self.sql.insertarRegistro(data: data);
            return result;
        } catch {
            print("Error insertar registros individual ConsultaMedica: \(error)")
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id de la tabla. Con este dato se buscará y actualizará el registro.
     - Parameter data: Corresponde al objeto con la información nueva.
     - Returns: 0 cuando no se realizó el registro, : 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro(idRegistro: Int, data: ConsultaMedica) -> Int {
        do {
            let result = try self.sql.actualizarRegistro(idRegistro: idRegistro, data: data);
            return result;
        } catch {
            print("Error actualizar ConsultaMedica: \(error)");
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id local de la tabla. Con este dato se buscará y actualizará el registro.
     - Parameter data: Corresponde al objeto con la información nueva.
     - Returns: 0 cuando no se realizó el registro, : 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistroOffline(idRegistro: Int, data: ConsultaMedica) -> Int {
        do {
            let result = try self.sql.actualizarRegistroOffline(idRegistro: idRegistro, data: data);
            return result;
        } catch {
            print("Error actualizar offline ConsultaMedica: \(error)");
            return 0;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos ConsultaMedica.
     */
    func seleccionarRegistrosTodoConsultaMedica() -> [ConsultaMedica] {
        do {
            let result = try self.sql.seleccionarRegistrosTodoConsultaMedica();
            return result;
        } catch {
            print("Error seleccionar todo ConsultaMedica: \(error)");
            return [ConsultaMedica]();
        }
    }
    
    /**
     Permite seleccionar un registro por medio de su id.
     - Parameter idRegistro: Corresponde al id del registro del cual se desea obtener la información.
     - Returns: Devuelve un objeto ConsultaMedica opcional.
     */
    func seleccionarRegistroPorId(idRegistro: Int) -> ConsultaMedica? {
        do {
            let result = try self.sql.seleccionarRegistrosPorId(idRegistro: idRegistro);
            return result;
        } catch {
            print("Error seleccionar por id ConsultaMedica: \(error)")
            return nil;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos ConsultaMedica.
     */
    func seleccionarRegistrosPorSincronizadoConsultaMedica(estaSincronizado: Bool) -> [ConsultaMedica] {
        do {
            let result = try self.sql.seleccionarRegistrosPorSincronizadoConsultaMedica(estaSincronizado: estaSincronizado);
            return result;
        } catch {
            print("Error seleccionar por sincronizado ConsultaMedica: \(error)");
            return [ConsultaMedica]();
        }
    }
    
    /**
     Permite eliminar un registro de la base de datos.
     - Parameter idRegistro: Correponde al id del registro que se desea eliminar.
     - Returns: 0: si no se eliminó el registro, 1: si se eliminó el registro.
     */
    func eliminarRegistro(idRegistro: Int) -> Int {
        do {
            let result = try self.sql.eliminarRegistro(idRegistro: idRegistro);
            return result;
        } catch {
            print("Error eliminar ConsultaMedica: \(error)");
            return 0;
        }
    }
    
    
}
