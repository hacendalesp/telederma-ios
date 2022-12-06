//
//  SQLHelpDesk.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLHelpDesk: SQLBase {
    
    private var ticket: Expression<String?>;
    private var response_ticket: Expression<String?>;
    private var image_admin: Expression<String?>;
    private var status: Expression<Int?>;
    private var device_id: Expression<String?>;
    private var descriptions: Expression<String?>;
    private var subject: Expression<String?>;
    private var image_user: Expression<String?>;
    private var user_id: Expression<Int?>;
    private var admin_user_id: Expression<Int?>;
    private var id_local: Expression<Int>;
    
    override init(db: Connection?) {
        self.ticket = Expression<String?>("ticket");
        self.response_ticket = Expression<String?>("response_ticket");
        self.image_admin = Expression<String?>("image_admin");
        self.status = Expression<Int?>("status");
        self.device_id = Expression<String?>("device_id");
        self.descriptions = Expression<String?>("description");
        self.subject = Expression<String?>("subject");
        self.image_user = Expression<String?>("image_user");
        self.user_id = Expression<Int?>("user_id");
        self.admin_user_id = Expression<Int?>("admin_user_id");
        self.id_local = Expression<Int>("id_local");
        super.init(db: db);
        self.tabla = Table("helpDesk");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(ticket)
                t.column(response_ticket)
                t.column(image_admin)
                t.column(status)
                t.column(device_id)
                t.column(descriptions)
                t.column(subject)
                t.column(image_user)
                t.column(user_id)
                t.column(admin_user_id)
                t.column(id, unique: true)
                t.column(id_local, primaryKey: .autoincrement)
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
    func insertarRegistros (data: [HelpDesk]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        ticket <- item.ticket,
                        response_ticket <- item.response_ticket,
                        image_admin <- item.image_admin,
                        status <- item.status,
                        device_id <- item.device_id,
                        descriptions <- item.descriptions,
                        subject <- item.subject,
                        image_user <- item.image_user,
                        user_id <- item.user_id,
                        admin_user_id <- item.admin_user_id,
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
    func actualizarRegistro (idRegistro: Int, data: HelpDesk) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                id <- data.id,
                ticket <- data.ticket,
                response_ticket <- data.response_ticket,
                image_admin <- data.image_admin,
                status <- data.status,
                device_id <- data.device_id,
                descriptions <- data.descriptions,
                subject <- data.subject,
                image_user <- data.image_user,
                user_id <- data.user_id,
                admin_user_id <- data.admin_user_id,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos HelpDesk
     */
    func seleccionarRegistrosTodo () throws -> [HelpDesk] {
        var datos = [HelpDesk]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = HelpDesk();
                obj.ticket = item[ticket];
                obj.response_ticket = item[response_ticket];
                obj.image_admin = item[image_admin];
                obj.status = item[status];
                obj.device_id = item[device_id];
                obj.descriptions = item[descriptions];
                obj.subject = item[subject];
                obj.image_user = item[image_user];
                obj.user_id = item[user_id];
                obj.admin_user_id = item[admin_user_id];
                obj.id = item[id];
                obj.id_local = item[id_local];
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
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> HelpDesk? {
        var obj: HelpDesk? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = HelpDesk();
                obj!.ticket = item[ticket];
                obj!.response_ticket = item[response_ticket];
                obj!.image_admin = item[image_admin];
                obj!.status = item[status];
                obj!.device_id = item[device_id];
                obj!.descriptions = item[descriptions];
                obj!.subject = item[subject];
                obj!.image_user = item[image_user];
                obj!.user_id = item[user_id];
                obj!.admin_user_id = item[admin_user_id];
                obj!.id = item[id];
                obj!.id_local = item[id_local];
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
