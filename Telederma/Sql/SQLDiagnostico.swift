//
//  SQLDiagnostico.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLDiagnostico: SQLBase {
    
    private var specialist_response_id: Expression<Int?>;
    private var disease: Expression<String?>;
    private var type_diagnostic: Expression<String?>;
    private var status: Expression<String?>;
    
    override init(db: Connection?) {
        self.specialist_response_id = Expression<Int?>("specialist_response_id");
        self.disease = Expression<String?>("disease");
        self.type_diagnostic = Expression<String?>("type_diagnostic");
        self.status = Expression<String?>("status");
        super.init(db: db);
        self.tabla = Table("diagnostico");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(specialist_response_id)
                t.column(disease)
                t.column(type_diagnostic)
                t.column(status)
                t.column(id, unique: true)
                t.column(created_at)
                t.column(updated_at)
            })};
    }
    
    /**
     Método que permite registrar uno o muchos datos en la tabla.
     - Parameter data: Corresponde a una lista con la información a ingresar.
     - Returns: 0 cuando no se insertó ningún dato
     - Returns: 1 cuando se insertaron todos los datos
     - Returns: -1 cuando el ingreso fue incompleto
     */
    func insertarRegistros (data: [Diagnostico]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        specialist_response_id <- item.specialist_response_id,
                        disease <- item.disease,
                        type_diagnostic <- item.type_diagnostic,
                        status <- item.status,
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
     - Returns: 0 cuando no se realizó el registro.
     - Returns: 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro (idRegistro: Int, data: Diagnostico) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                specialist_response_id <- data.specialist_response_id,
                disease <- data.disease,
                type_diagnostic <- data.type_diagnostic,
                status <- data.status,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Diagnostico
     */
    func seleccionarRegistrosTodo () throws -> [Diagnostico] {
        var datos = [Diagnostico]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Diagnostico();
                obj.specialist_response_id = item[specialist_response_id];
                obj.disease = item[disease];
                obj.type_diagnostic = item[type_diagnostic];
                obj.status = item[status];
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
     - Returns: Retorna un objeto Diagnostico
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Diagnostico? {
        var obj: Diagnostico? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Diagnostico();
                obj!.specialist_response_id = item[specialist_response_id];
                obj!.disease = item[disease];
                obj!.type_diagnostic = item[type_diagnostic];
                obj!.status = item[status];
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
     - Returns: 0 si no se eliminó.
     - Returns: 1 si se eliminó exitosamente.
     */
    func eliminarRegistro (idRegistro: Int) throws -> Int {
        if let db = self.database {
            let eliminado = try db.run(self.tabla!.filter(id == idRegistro).delete());
            return eliminado;
        }
        return 0;
    }
}
