//
//  SQLRequerimiento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 25/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLRequerimiento: SQLBase {
    
    private var consultation_id: Expression<Int?>;
    private var medical_control_id: Expression<Int?>;
    private var description_request: Expression<String?>;
    private var specialist_id: Expression<Int?>;
    private var audio_request: Expression<String?>;
    private var comment: Expression<String?>;
    private var type_request: Expression<String?>;
    private var doctor_id: Expression<Int?>;
    private var status: Expression<Int?>;
    private var hour: Expression<String?>;
    private var reason: Expression<Int?>;
    private var other_reason: Expression<String?>;
    
    override init(db: Connection?) {
        self.consultation_id = Expression<Int?>("consultation_id");
        self.medical_control_id = Expression<Int?>("medical_control_id");
        self.description_request = Expression<String?>("description_request");
        self.specialist_id = Expression<Int?>("specialist_id");
        self.audio_request = Expression<String?>("audio_request");
        self.comment = Expression<String?>("comment");
        self.type_request = Expression<String?>("type_request");
        self.doctor_id = Expression<Int?>("doctor_id");
        self.status = Expression<Int?>("status");
        self.hour = Expression<String?>("hour");
        self.reason = Expression<Int?>("reason");
        self.other_reason = Expression<String?>("other_reason");
        super.init(db: db);
        self.tabla = Table("requerimiento");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(consultation_id)
                t.column(medical_control_id)
                t.column(description_request)
                t.column(specialist_id)
                t.column(audio_request)
                t.column(comment)
                t.column(type_request)
                t.column(doctor_id)
                t.column(status)
                t.column(hour)
                t.column(reason)
                t.column(other_reason)
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
    func insertarRegistros (data: [Requerimiento]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        consultation_id <- item.consultation_id,
                        medical_control_id <- item.medical_control_id,
                        description_request <- item.description_request,
                        specialist_id <- item.specialist_id,
                        audio_request <- item.audio_request,
                        comment <- item.comment,
                        type_request <- item.type_request,
                        doctor_id <- item.doctor_id,
                        status <- item.status,
                        hour <- item.hour,
                        reason <- item.reason,
                        other_reason <- item.other_reason,
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
    func actualizarRegistro (idRegistro: Int, data: Requerimiento) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                consultation_id <- data.consultation_id,
                medical_control_id <- data.medical_control_id,
                description_request <- data.description_request,
                specialist_id <- data.specialist_id,
                audio_request <- data.audio_request,
                comment <- data.comment,
                type_request <- data.type_request,
                doctor_id <- data.doctor_id,
                status <- data.status,
                hour <- data.hour,
                reason <- data.reason,
                other_reason <- data.other_reason,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Requerimiento
     */
    func seleccionarRegistrosTodo () throws -> [Requerimiento] {
        var datos = [Requerimiento]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Requerimiento();
                obj.consultation_id = item[consultation_id];
                obj.medical_control_id = item[medical_control_id];
                obj.description_request = item[description_request];
                obj.specialist_id = item[specialist_id];
                obj.audio_request = item[audio_request];
                obj.comment = item[comment];
                obj.type_request = item[type_request];
                obj.doctor_id = item[doctor_id];
                obj.status = item[status];
                obj.hour = item[hour];
                obj.reason = item[reason];
                obj.other_reason = item[other_reason];
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
     - Returns: Retorna un objeto Requerimiento
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Requerimiento? {
        var obj: Requerimiento? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Requerimiento();
                obj!.consultation_id = item[consultation_id];
                obj!.medical_control_id = item[medical_control_id];
                obj!.description_request = item[description_request];
                obj!.specialist_id = item[specialist_id];
                obj!.audio_request = item[audio_request];
                obj!.comment = item[comment];
                obj!.type_request = item[type_request];
                obj!.doctor_id = item[doctor_id];
                obj!.status = item[status];
                obj!.hour = item[hour];
                obj!.reason = item[reason];
                obj!.other_reason = item[other_reason];
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
