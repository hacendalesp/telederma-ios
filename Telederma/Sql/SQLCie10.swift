//
//  SQLCie10.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLCie10: SQLBase {
    
    private var name: Expression<String?>;
    private var code: Expression<String?>;
    
    override init(db: Connection?) {
        self.name = Expression<String?>("name");
        self.code = Expression<String?>("code");
        super.init(db: db);
        self.tabla = Table("cie10");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(name)
                t.column(code)
                t.column(id, unique: true)
                t.column(created_at)
                t.column(updated_at)
            })};
    }
    
    /**
     Método que permite registrar uno o muchos datos en la tabla.
     - Parameter data: Corresponde a una lista con la información a ingresar.
     - Returns: 0 cuando no se insertó ningún dato, : 1 cuando se insertaron todos los datos, : -1 cuando el ingreso fue incompleto
     */
    func insertarRegistros (data: [Cie10]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        name <- item.name,
                        code <- item.code,
                        created_at <- item.created_at,
                        updated_at <- item.updated_at
                    ))
                    
                    if (insertado > 0) {
                        contador += 1;
                    }
                }
                if (contador == data.count) {
                    return 1;
                } else {
                    return -1;
                }
            }
        }
        return 0;
    }
    
    /**
     Método que permite actualizar la información de un registro específico.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id de la tabla. Con este dato se buscará y actualizará el registro.
     - Parameter data: Corresponde al objeto con la información nueva.
     - Returns: 0 cuando no se realizó el registro, : 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro (idRegistro: Int, data: Cie10) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                name <- data.name,
                code <- data.code,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Cie10
     */
    func seleccionarRegistrosTodo () throws -> [Cie10] {
        var datos = [Cie10]();
        if let db = self.database {
            for item in try db.prepare((self.tabla?.order(name.asc))!) {
                let obj = Cie10();
                obj.name = item[name];
                obj.code = item[code];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter idRegistro: Corresponde al valor del campo id del registro que se desea obtener la información.
     - Returns: Retorna un objeto Cie10
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Cie10? {
        var obj: Cie10? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Cie10();
                obj!.name = item[name];
                obj!.code = item[code];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
            }
        }
        return obj;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter nombre: Corresponde al valor del campo nom del registro que se desea obtener la información.
     - Returns: Retorna un objeto Cie10
     */
    func seleccionarUnRegistroPorNombre (nombre: String) throws -> Cie10? {
        var obj: Cie10? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(name == nombre).limit(1);
            if let item = try db.pluck(query){
                obj = Cie10();
                obj!.name = item[name];
                obj!.code = item[code];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
            }
        }
        return obj;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter codigo: Corresponde al valor del campo code del registro que se desea obtener la información.
     - Returns: Retorna un objeto Cie10
     */
    func seleccionarUnRegistroPorCodigo (codigo: String) throws -> Cie10? {
        var obj: Cie10? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(code == codigo).limit(1);
            if let item = try db.pluck(query){
                obj = Cie10();
                obj!.name = item[name];
                obj!.code = item[code];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
            }
        }
        return obj;
    }
    
    /**
     Método permite eliminar un registro de la tabla.
     - Parameter idRegistro: Corresponde al valor del campo id que se desea eliminar.
     - Returns: 0 si no se eliminó, : 1 si se eliminó exitosamente.
     */
    func eliminarRegistro (idRegistro: Int) throws -> Int {
        if let db = self.database {
            let eliminado = try db.run(self.tabla!.filter(id == idRegistro).delete());
            return eliminado;
        }
        return 0;
    }
}
