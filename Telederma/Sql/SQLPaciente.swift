//
//  SQLPaciente.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLPaciente: SQLBase {
    
    private var type_document: Expression<Int?>;
    private var type_condition: Expression<Int?>;
    private var number_document: Expression<String?>;
    private var last_name: Expression<String?>;
    private var second_surname: Expression<String?>;
    private var name: Expression<String?>;
    private var second_name: Expression<String?>;
    private var birthdate: Expression<String?>;
    private var genre: Expression<Int?>;
    private var number_inpec: Expression<String?>;
    private var status: Expression<Int?>;
    private var id_local: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.type_document = Expression<Int?>("type_document");
        self.type_condition = Expression<Int?>("type_condition");
        self.number_document = Expression<String?>("number_document");
        self.last_name = Expression<String?>("last_name");
        self.second_surname = Expression<String?>("second_surname");
        self.name = Expression<String?>("name");
        self.second_name = Expression<String?>("second_name");
        self.birthdate = Expression<String?>("birthdate");
        self.genre = Expression<Int?>("genre");
        self.number_inpec = Expression<String?>("number_inpec");
        self.status = Expression<Int?>("status");
        self.id_local = Expression<Int>("id_local");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("paciente");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(name)
                t.column(type_document, defaultValue: 0)
                t.column(type_condition)
                t.column(number_document, defaultValue: "0")
                t.column(last_name)
                t.column(second_surname)
                t.column(second_name)
                t.column(birthdate)
                t.column(genre, defaultValue: 0)
                t.column(number_inpec)
                t.column(status, defaultValue: 0)
                t.column(id)
                t.column(id_local, primaryKey: .autoincrement)
                t.column(created_at)
                t.column(updated_at)
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
    func insertarRegistros (data: [Paciente]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        name <- item.name,
                        type_document <- item.type_document,
                        type_condition <- item.type_condition,
                        number_document <- item.number_document,
                        last_name <- item.last_name,
                        second_surname <- item.second_surname,
                        second_name <- item.second_name,
                        birthdate <- item.birthdate,
                        genre <- item.genre,
                        number_inpec <- item.number_inpec,
                        status <- item.status,
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
     Permite insertar un registro a la vez.
     - Parameter data: Representa un objeto paciente.
     - Returns: Devuelve 0 si no se registró el paciente o de lo contrario retorna el id.
     */
    func insertarRegistro (data: Paciente) throws -> Int {
        if let db = self.database {
            let insertado = try db.run(self.tabla!.insert(
                id <- data.id,
                name <- data.name,
                type_document <- data.type_document,
                type_condition <- data.type_condition,
                number_document <- data.number_document,
                last_name <- data.last_name,
                second_surname <- data.second_surname,
                second_name <- data.second_name,
                birthdate <- data.birthdate,
                genre <- data.genre,
                number_inpec <- data.number_inpec,
                status <- data.status,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                sincronizado <- data.sincronizado
            ))
            
            return Int(insertado);
        }
        return 0;
    }
    
    /**
     Método que permite actualizar la información de un registro específico.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id de la tabla. Con este dato se buscará y actualizará el registro.
     - Returns: 0 cuando no se realizó el registro.
     - Returns: 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistro (idRegistro: Int, data: Paciente) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                name <- data.name,
                type_document <- data.type_document,
                type_condition <- data.type_condition,
                number_document <- data.number_document,
                last_name <- data.last_name,
                second_surname <- data.second_surname,
                second_name <- data.second_name,
                birthdate <- data.birthdate,
                genre <- data.genre,
                number_inpec <- data.number_inpec,
                status <- data.status,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                sincronizado <- data.sincronizado,
                id <- data.id
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite actualizar la información de un registro específico.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id local de la tabla. Con este dato se buscará y actualizará el registro.
     - Returns: 0 cuando no se realizó el registro.
     - Returns: 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistroOffline (idRegistro: Int, data: Paciente) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id_local == idRegistro).update(
                name <- data.name,
                type_document <- data.type_document,
                type_condition <- data.type_condition,
                number_document <- data.number_document,
                last_name <- data.last_name,
                second_surname <- data.second_surname,
                second_name <- data.second_name,
                birthdate <- data.birthdate,
                genre <- data.genre,
                number_inpec <- data.number_inpec,
                status <- data.status,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                sincronizado <- data.sincronizado,
                id <- data.id
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Paciente
     */
    func seleccionarRegistrosTodo () throws -> [Paciente] {
        var datos = [Paciente]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Paciente();
                obj.name = item[name];
                obj.type_document = item[type_document];
                obj.type_condition = item[type_condition];
                obj.number_document = item[number_document];
                obj.last_name = item[last_name];
                obj.second_surname = item[second_surname];
                obj.second_name = item[second_name];
                obj.birthdate = item[birthdate];
                obj.genre = item[genre];
                obj.number_inpec = item[number_inpec];
                obj.status = item[status];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                obj.id_local = item[id_local];
                obj.sincronizado = item[sincronizado];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter idRegistro: Corresponde al valor del campo id del registro que se desea obtener la información.
     - Returns: Retorna un objeto Paciente
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Paciente? {
        var obj: Paciente? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Paciente();
                obj!.name = item[name];
                obj!.type_document = item[type_document];
                obj!.type_condition = item[type_condition];
                obj!.number_document = item[number_document];
                obj!.last_name = item[last_name];
                obj!.second_surname = item[second_surname];
                obj!.second_name = item[second_name];
                obj!.birthdate = item[birthdate];
                obj!.genre = item[genre];
                obj!.number_inpec = item[number_inpec];
                obj!.status = item[status];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
                obj!.id_local = item[id_local];
                obj!.sincronizado = item[sincronizado];
            }
        }
        return obj;
    }
    
    /**
     Método que permite obtener toda la información de un registro específico de la tabla.
     - Parameter estaSincronizado: Corresponde a un valor booleano que permite saber qué clase de registros se tienen que devolver.
     - Returns: Retorna una lista de objetos Paciente
     */
    func seleccionarRegistrosPorSincronizado (estaSincronizado: Bool) throws -> [Paciente] {
        var datos = [Paciente]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!.select(*).filter(sincronizado == estaSincronizado)) {
                let obj = Paciente();
                obj.name = item[name];
                obj.type_document = item[type_document];
                obj.type_condition = item[type_condition];
                obj.number_document = item[number_document];
                obj.last_name = item[last_name];
                obj.second_surname = item[second_surname];
                obj.second_name = item[second_name];
                obj.birthdate = item[birthdate];
                obj.genre = item[genre];
                obj.number_inpec = item[number_inpec];
                obj.status = item[status];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                obj.id_local = item[id_local];
                obj.sincronizado = item[sincronizado];
                
                datos.append(obj);
            }
        }
        return datos;
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
