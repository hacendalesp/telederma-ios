//
//  SQLUsuario.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLUsuario: SQLBase {
    
    private var number_document: Expression<String?>;
    private var name: Expression<String?>;
    private var surnames: Expression<String?>;
    private var type_professional: Expression<Int?>;
    private var professional_card: Expression<String?>;
    private var phone: Expression<String?>;
    private var terms_and_conditions: Expression<Int?>;
    private var digital_signature: Expression<String?>;
    private var photo: Expression<String?>;
    private var tutorial: Expression<Int?>;
    private var authentication_token: Expression<String?>;
    private var password: Expression<String?>;
    private var email: Expression<String?>;
    private var status: Expression<Int?>;
    private var image_digital: Expression<String?>;
    private var local_id: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.number_document = Expression<String?>("number_document");
        self.name = Expression<String?>("name");
        self.surnames = Expression<String?>("surnames");
        self.type_professional = Expression<Int?>("type_professional");
        self.professional_card = Expression<String?>("professional_card");
        self.phone = Expression<String?>("phone");
        self.terms_and_conditions = Expression<Int?>("terms_and_conditions");
        self.digital_signature = Expression<String?>("digital_signature");
        self.photo = Expression<String?>("photo");
        self.tutorial = Expression<Int?>("tutorial");
        self.authentication_token = Expression<String?>("authentication_token");
        self.password = Expression<String?>("password");
        self.email = Expression<String?>("email");
        self.status = Expression<Int?>("status");
        self.image_digital = Expression<String?>("image_digital");
        self.local_id = Expression<Int>("local_id");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("usuarios");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(number_document, unique: true)
                t.column(name)
                t.column(surnames)
                t.column(type_professional)
                t.column(professional_card)
                t.column(phone)
                t.column(terms_and_conditions)
                t.column(digital_signature)
                t.column(photo)
                t.column(tutorial)
                t.column(authentication_token)
                t.column(password)
                t.column(email)
                t.column(status)
                t.column(image_digital)
                t.column(id, unique: true)
                t.column(local_id, primaryKey: .autoincrement)
                t.column(sincronizado)
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
    func insertarRegistros (data: [Usuario]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        name <- item.name,
                        number_document <- item.number_document,
                        surnames <- item.surnames,
                        type_professional <- item.type_professional,
                        professional_card <- item.professional_card,
                        phone <- item.phone,
                        terms_and_conditions <- item.terms_and_conditions,
                        digital_signature <- item.digital_signature,
                        photo <- item.photo,
                        tutorial <- item.tutorial,
                        authentication_token <- item.authentication_token,
                        password <- item.password,
                        email <- item.email,
                        status <- item.status,
                        image_digital <- item.image_digital,
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
    func actualizarRegistro (idRegistro: Int, data: Usuario) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                name <- data.name,
                number_document <- data.number_document,
                surnames <- data.surnames,
                type_professional <- data.type_professional,
                professional_card <- data.professional_card,
                phone <- data.phone,
                terms_and_conditions <- data.terms_and_conditions,
                digital_signature <- data.digital_signature,
                photo <- data.photo,
                tutorial <- data.tutorial,
                authentication_token <- data.authentication_token,
                password <- data.password,
                email <- data.email,
                status <- data.status,
                image_digital <- data.image_digital,
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
     - Returns: Retorna una lista de objetos Usuario
     */
    func seleccionarRegistrosTodo () throws -> [Usuario] {
        var datos = [Usuario]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Usuario();
                obj.name = item[name];
                obj.number_document = item[number_document];
                obj.surnames = item[surnames];
                obj.type_professional = item[type_professional];
                obj.professional_card = item[professional_card];
                obj.phone = item[phone];
                obj.terms_and_conditions = item[terms_and_conditions];
                obj.digital_signature = item[digital_signature];
                obj.photo = item[photo];
                obj.tutorial = item[tutorial];
                obj.authentication_token = item[authentication_token];
                obj.password = item[password];
                obj.email = item[email];
                obj.status = item[status];
                obj.image_digital = item[image_digital];
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
     - Returns: Retorna un objeto Usuario
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Usuario? {
        var obj: Usuario? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Usuario();
                obj!.name = item[name];
                obj!.number_document = item[number_document];
                obj!.surnames = item[surnames];
                obj!.type_professional = item[type_professional];
                obj!.professional_card = item[professional_card];
                obj!.phone = item[phone];
                obj!.terms_and_conditions = item[terms_and_conditions];
                obj!.digital_signature = item[digital_signature];
                obj!.photo = item[photo];
                obj!.tutorial = item[tutorial];
                obj!.authentication_token = item[authentication_token];
                obj!.password = item[password];
                obj!.email = item[email];
                obj!.status = item[status];
                obj!.image_digital = item[image_digital];
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
