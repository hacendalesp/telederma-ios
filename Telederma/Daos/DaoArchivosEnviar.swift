//
//  DaoArchivoEnviar.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class DaoArchivosEnviar {
    
    var sql: SQLArchivosEnviar;
    var conexion: Conexion;
    
    init(conexion: Conexion) {
        self.conexion = conexion;
        self.sql = SQLArchivosEnviar(db: self.conexion.obtenerConexion());
    }
    
    /**
     Permite crear la tabla en la base de datos
     */
    func crearTabla() {
        do {
            try self.sql.crearTabla();
        } catch {
            print("Error crear ArchivoEnviar: \(error)")
        }
    }
    
    /**
     Permite insertar un conjunto de datos.
     - Parameter data: Corresponde a una lista de objetos ArchivoEnviar.
     - Returns: -1 si el registro fue incompleto, : 0 si no se registró ninún dato, : 1 si el registro fue exitoso
     */
    func insertarRegistros(data: [ArchivosEnviar]) -> Int {
        do {
            let result = try self.sql.insertarRegistros(data: data);
            return result;
        } catch {
            print("Error insertar registros ArchivoEnviar: \(error)")
            return 0;
        }
    }
    
    /**
     Permite actualizar un registro de la base de datos.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id de la tabla. Con este dato se buscará y actualizará el registro.
     - Parameter data: Corresponde al objeto con la información nueva.
     - Returns: 0 cuando no se realizó el registro, : 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro(idRegistro: Int, data: ArchivosEnviar) -> Int {
        do {
            let result = try self.sql.actualizarRegistro(idRegistro: idRegistro, data: data);
            return result;
        } catch {
            print("Error actualizar ArchivoEnviar: \(error)");
            return 0;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos ArchivoEnviar.
     */
    func seleccionarRegistrosTodo() -> [ArchivosEnviar] {
        do {
            let result = try self.sql.seleccionarRegistrosTodo();
            return result;
        } catch {
            print("Error seleccionar todo ArchivoEnviar: \(error)");
            return [ArchivosEnviar]();
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla (sin filtros).
     - Returns: Devuelve una lista de objetos ArchivoEnviar.
     */
    func seleccionarPrimerRegistro() -> ArchivosEnviar? {
        do {
            let result = try self.sql.seleccionarPrimerRegistro();
            return result;
        } catch {
            print("Error seleccionar todo ArchivoEnviar: \(error)");
            return nil;
        }
    }
    
    /**
     Permite seleccionar todos los registros de la tabla que pertenezcan a un tipo y a una consulta o control.
     - Returns: Devuelve una lista de objetos ArchivoEnviar.
     */
    func seleccionarPorTipoConsultaControl(tipo: String, consultaControlId: Int, esConsulta: Bool) -> [ArchivosEnviar] {
        do {
            let result = try self.sql.seleccionarPorTipoControlConsulta(tipoBusqueda: tipo, consultaControlId: consultaControlId, esConsulta: esConsulta);
            return result;
        } catch {
            print("Error seleccionar todo ArchivoEnviar: \(error)");
            return [ArchivosEnviar]();
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
            print("Error eliminar ArchivoEnviar: \(error)");
            return 0;
        }
    }
    
    
}
