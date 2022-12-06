//
//  SQLImagenLesion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLImagenLesion: SQLBase {
    
    private var id_injury_local: Expression<Int?>;
    private var photo: Expression<String?>;
    private var edited_photo: Expression<String?>;
    private var descriptions: Expression<String?>;
    private var injury_id: Expression<Int?>;
    private var medical_control_id: Expression<Int?>;
    private var image_injury_id: Expression<String?>;
    private var local_id: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.id_injury_local = Expression<Int?>("id_injury_local");
        self.photo = Expression<String?>("photo");
        self.edited_photo = Expression<String?>("edited_photo");
        self.descriptions = Expression<String?>("description");
        self.injury_id = Expression<Int?>("injury_id");
        self.medical_control_id = Expression<Int?>("medical_control_id");
        self.image_injury_id = Expression<String?>("image_injury_id");
        self.local_id = Expression<Int>("local_id");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("imagen_lesion");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(id_injury_local)
                t.column(photo)
                t.column(edited_photo)
                t.column(descriptions)
                t.column(injury_id)
                t.column(medical_control_id)
                t.column(image_injury_id)
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
    func insertarRegistros (data: [ImagenLesion]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        id_injury_local <- item.id_injury_local,
                        photo <- item.photo,
                        edited_photo <- item.edited_photo,
                        descriptions <- item.descriptions,
                        injury_id <- item.injury_id,
                        medical_control_id <- item.medical_control_id,
                        image_injury_id <- item.image_injury_id,
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
    func actualizarRegistro (idRegistro: Int, data: ImagenLesion) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                id_injury_local <- data.id_injury_local,
                photo <- data.photo,
                edited_photo <- data.edited_photo,
                descriptions <- data.descriptions,
                injury_id <- data.injury_id,
                medical_control_id <- data.medical_control_id,
                image_injury_id <- data.image_injury_id,
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
     - Returns: Retorna una lista de objetos ImagenLesion
     */
    func seleccionarRegistrosTodo () throws -> [ImagenLesion] {
        var datos = [ImagenLesion]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = ImagenLesion();
                obj.id_injury_local = item[id_injury_local];
                obj.photo = item[photo];
                obj.edited_photo = item[edited_photo];
                obj.descriptions = item[descriptions];
                obj.injury_id = item[injury_id];
                obj.medical_control_id = item[medical_control_id];
                obj.image_injury_id = item[image_injury_id];
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
     - Returns: Retorna un objeto ImagenLesion
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> ImagenLesion? {
        var obj: ImagenLesion? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = ImagenLesion();
                obj!.id_injury_local = item[id_injury_local];
                obj!.photo = item[photo];
                obj!.edited_photo = item[edited_photo];
                obj!.descriptions = item[descriptions];
                obj!.injury_id = item[injury_id];
                obj!.medical_control_id = item[medical_control_id];
                obj!.image_injury_id = item[image_injury_id];
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
