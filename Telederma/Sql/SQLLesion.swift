//
//  SQLLesion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLLesion: SQLBase {
    
    private var name_area: Expression<String?>;
    private var enviado: Expression<Int?>;
    private var id_consult_local: Expression<Int?>;
    private var id_control_local: Expression<Int?>;
    private var id_requerimiento: Expression<Int?>;
    private var consultation_id: Expression<Int?>;
    private var consultation_control_id: Expression<Int?>;
    private var body_area_id: Expression<Int?>;
    private var local_id: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.name_area = Expression<String?>("name_area");
        self.enviado = Expression<Int?>("enaviado");
        self.id_consult_local = Expression<Int?>("id_consult_local");
        self.id_control_local = Expression<Int?>("id_control_local");
        self.id_requerimiento = Expression<Int?>("id_requerimiento");
        self.consultation_id = Expression<Int?>("consultation_id");
        self.consultation_control_id = Expression<Int?>("consultation_control_id");
        self.body_area_id = Expression<Int?>("body_area_id");
        self.local_id = Expression<Int>("local_id");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("lesion");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(name_area)
                t.column(enviado)
                t.column(id_consult_local)
                t.column(id_control_local)
                t.column(id_requerimiento)
                t.column(consultation_id)
                t.column(consultation_control_id)
                t.column(body_area_id)
                t.column(id, unique: true)
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
    func insertarRegistros (data: [Lesion]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        name_area <- item.name_area,
                        enviado <- item.enviado,
                        id_consult_local <- item.id_consult_local,
                        id_control_local <- item.id_control_local,
                        id_requerimiento <- item.id_requerimiento,
                        consultation_id <- item.consultation_id,
                        consultation_control_id <- item.consultation_control_id,
                        body_area_id <- item.body_area_id,
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
    func actualizarRegistro (idRegistro: Int, data: Lesion) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                name_area <- data.name_area,
                enviado <- data.enviado,
                id_consult_local <- data.id_consult_local,
                id_control_local <- data.id_control_local,
                id_requerimiento <- data.id_requerimiento,
                consultation_id <- data.consultation_id,
                consultation_control_id <- data.consultation_control_id,
                body_area_id <- data.body_area_id,
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
     - Returns: Retorna una lista de objetos Lesion
     */
    func seleccionarRegistrosTodo () throws -> [Lesion] {
        var datos = [Lesion]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Lesion();
                obj.name_area = item[name_area];
                obj.enviado = item[enviado];
                obj.id_consult_local = item[id_consult_local];
                obj.id_control_local = item[id_control_local];
                obj.id_requerimiento = item[id_requerimiento];
                obj.consultation_id = item[consultation_id];
                obj.consultation_control_id = item[consultation_control_id];
                obj.body_area_id = item[body_area_id];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                
                obj.id_local = item[local_id];
                obj.sincronizado = item[sincronizado];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter idRegistro: Corresponde al valor del campo id del registro que se desea obtener la información.
     - Returns: Retorna un objeto Lesion
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Lesion? {
        var obj: Lesion? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Lesion();
                obj!.name_area = item[name_area];
                obj!.enviado = item[enviado];
                obj!.id_consult_local = item[id_consult_local];
                obj!.id_control_local = item[id_control_local];
                obj!.id_requerimiento = item[id_requerimiento];
                obj!.consultation_id = item[consultation_id];
                obj!.consultation_control_id = item[consultation_control_id];
                obj!.body_area_id = item[body_area_id];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
                
                obj!.id_local = item[local_id];
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
