//
//  SQLEspecialista.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLEspecialista: SQLBase {
    
    private var name: Expression<String?>;
    private var surnames: Expression<String?>;
    private var date: Expression<String?>;
    private var hour: Expression<String?>;
    private var professional_card: Expression<String?>;
    private var local_id: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.name = Expression<String?>("name");
        self.surnames = Expression<String?>("surnames");
        self.date = Expression<String?>("date");
        self.hour = Expression<String?>("hour");
        self.professional_card = Expression<String?>("professional_card");
        self.local_id = Expression<Int>("local_id");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("especialista");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(name)
                t.column(surnames)
                t.column(date)
                t.column(hour)
                t.column(professional_card)
                t.column(id)
                t.column(created_at)
                t.column(updated_at)
                t.column(local_id, primaryKey: .autoincrement)
                t.column(sincronizado)
            })};
    }
    
    /**
     Método que permite registrar uno o muchos datos en la tabla.
     - Parameter data: Corresponde a una lista con la información a ingresar.
     - Returns: 0 cuando no se insertó ningún dato
     - Returns: 1 cuando se insertaron todos los datos
     - Returns: -1 cuando el ingreso fue incompleto
     */
    func insertarRegistros (data: [Especialista]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        name <- item.name,
                        surnames <- item.surnames,
                        date <- item.date,
                        hour <- item.hour,
                        professional_card <- item.professional_card,
                        created_at <- item.created_at,
                        updated_at <- item.updated_at,
                        sincronizado <- item.sincronizado
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
    func actualizarRegistro (idRegistro: Int, data: Especialista) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                name <- data.name,
                surnames <- data.surnames,
                date <- data.date,
                hour <- data.hour,
                professional_card <- data.professional_card,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                sincronizado <- data.sincronizado
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Especialista
     */
    func seleccionarRegistrosTodo () throws -> [Especialista] {
        var datos = [Especialista]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Especialista();
                obj.name = item[name];
                obj.surnames = item[surnames];
                obj.date = item[date];
                obj.hour = item[hour];
                obj.professional_card = item[professional_card];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                obj.local_id = item[local_id];
                obj.sincronizado = item[sincronizado];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter idRegistro: Corresponde al valor del campo id del registro que se desea obtener la información.
     - Returns: Retorna un objeto Especialista
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Especialista? {
        var obj: Especialista? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Especialista();
                obj!.name = item[name];
                obj!.surnames = item[surnames];
                obj!.date = item[date];
                obj!.hour = item[hour];
                obj!.professional_card = item[professional_card];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
                obj!.local_id = item[local_id];
                obj!.sincronizado = item[sincronizado];
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
