//
//  SQLCreditos.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLCreditos: SQLBase {
    private var total: Expression<Int?>;
    private var consumidos: Expression<Int?>;
    
    override init(db: Connection?) {
        self.total = Expression<Int?>("total");
        self.consumidos = Expression<Int?>("consumidos");
        super.init(db: db);
        self.tabla = Table("creditos");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(total)
                t.column(consumidos)
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
    func insertarRegistros (data: [Creditos]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        total <- item.total,
                        consumidos <- item.consumidos,
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
     Únicamente existirá un registro de los créditos del cliente al cual pertenece el dispositivo.
     - Parameter data: Corresponde al objeto que contiene la nueva información.
     - Returns: 0 cuando no se realizó el registro.
     - Returns: 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro (data: Creditos) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == 1).update(
                total <- data.total,
                consumidos <- data.consumidos,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Creditos
     */
    func seleccionarRegistrosTodo () throws -> [Creditos] {
        var datos = [Creditos]();
        if let db = self.database {
            for item in try db.prepare((self.tabla?.order(id.asc))!) {
                let obj = Creditos();
                obj.total = item[total];
                obj.consumidos = item[consumidos];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
}
