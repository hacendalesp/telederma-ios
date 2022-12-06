//
//  SQLImagenAnexo.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLArchivosEnviar: NSObject {
    
    var tabla: Table?;
    var id: Expression<Int>;
    var created_at: Expression<String?>;
    var updated_at: Expression<String?>;
    
    var database: Connection?;
    
    private var ruta: Expression<String>;
    private var padre: Expression<String?>;
    private var tipo: Expression<String>;
    private var estado: Expression<Bool>;
    private var consultation_id: Expression<Int?>;
    private var consultation_control_id: Expression<Int?>;
    private var local_consultation_id: Expression<Int?>;
    private var local_consultation_control_id: Expression<Int?>;
    
    init(db: Connection?) {
        self.id = Expression<Int>("id");
        self.ruta = Expression<String>("ruta");
        self.padre = Expression<String?>("padre");
        self.tipo = Expression<String>("tipo");
        self.estado = Expression<Bool>("estado");
        self.consultation_id = Expression<Int?>("consultation_id");
        self.consultation_control_id = Expression<Int?>("consultation_control_id");
        self.created_at = Expression<String?>("created_at");
        self.updated_at = Expression<String?>("updated_at");
        self.local_consultation_id = Expression<Int?>("local_consultation_id");
        self.local_consultation_control_id = Expression<Int?>("local_consultation_control_id");
        
        self.tabla = Table("archivos_enviar");
        self.database = db;
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            //try db.run((self.tabla?.drop())!)
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(ruta)
                t.column(padre)
                t.column(tipo)
                t.column(estado)
                t.column(consultation_id)
                t.column(consultation_control_id)
                t.column(id, primaryKey: true)
                t.column(local_consultation_id)
                t.column(local_consultation_control_id)
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
    func insertarRegistros (data: [ArchivosEnviar]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        ruta <- item.ruta,
                        padre <- item.padre,
                        tipo <- item.tipo,
                        estado <- item.estado,
                        consultation_id <- item.consultation_id,
                        consultation_control_id <- item.consultation_control_id,
                        created_at <- item.created_at,
                        updated_at <- item.updated_at,
                        local_consultation_id <- item.local_consultation_id,
                        local_consultation_control_id <- item.local_consultation_control_id
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
    func actualizarRegistro (idRegistro: Int, data: ArchivosEnviar) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                ruta <- data.ruta,
                padre <- data.padre,
                tipo <- data.tipo,
                estado <- data.estado,
                consultation_id <- data.consultation_id,
                consultation_control_id <- data.consultation_control_id,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                local_consultation_id <- data.local_consultation_id,
                local_consultation_control_id <- data.local_consultation_control_id
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos ImagenAnexo
     */
    func seleccionarRegistrosTodo () throws -> [ArchivosEnviar] {
        var datos = [ArchivosEnviar]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = ArchivosEnviar();
                obj.ruta = item[ruta];
                obj.padre = item[padre];
                obj.tipo = item[tipo];
                obj.estado = item[estado];
                obj.consultation_id = item[consultation_id];
                obj.consultation_control_id = item[consultation_control_id];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                obj.local_consultation_id = item[local_consultation_id];
                obj.local_consultation_control_id = item[local_consultation_control_id];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener toda la información de la tabla de registros que pertenezcan a un mismo tipo y consulta o control.
     - Returns: Retorna una lista de objetos ArchivosEnviar (puede estar vacío)
     */
    func seleccionarPorTipoControlConsulta (tipoBusqueda: String, consultaControlId: Int, esConsulta: Bool) throws -> [ArchivosEnviar] {
        var datos = [ArchivosEnviar]();
        if let db = self.database {
            var query: Table!;
            if (esConsulta) {
                query = self.tabla!.filter(tipo == tipoBusqueda).filter(consultation_id == consultaControlId).order(id.asc, padre.asc)
            } else {
                query = self.tabla!.filter(tipo == tipoBusqueda).filter(consultation_control_id == consultaControlId).order(id.asc, padre.asc)
            }
            
            for item in try db.prepare(query) {
                let obj = ArchivosEnviar();
                obj.ruta = item[ruta];
                obj.padre = item[padre];
                obj.tipo = item[tipo];
                obj.estado = item[estado];
                obj.consultation_id = item[consultation_id];
                obj.consultation_control_id = item[consultation_control_id];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                obj.local_consultation_id = item[local_consultation_id];
                obj.local_consultation_control_id = item[local_consultation_control_id];
                
                datos.append(obj);
            }
        }
        return datos;
    }
    
    /**
     Método que permite obtener la información del primer registro.
     - Returns: Retorna una lista de objetos ImagenAnexo
     */
    func seleccionarPrimerRegistro () throws -> ArchivosEnviar? {
        var archivoEnviar: ArchivosEnviar?;
        if let db = self.database {
            if let dato = try db.pluck(self.tabla!) {
                archivoEnviar = ArchivosEnviar();
                archivoEnviar?.ruta = dato[ruta];
                archivoEnviar?.padre = dato[padre];
                archivoEnviar?.tipo = dato[tipo];
                archivoEnviar?.estado = dato[estado];
                archivoEnviar?.consultation_id = dato[consultation_id];
                archivoEnviar?.consultation_control_id = dato[consultation_control_id];
                archivoEnviar?.id = dato[id];
                archivoEnviar?.created_at = dato[created_at];
                archivoEnviar?.updated_at = dato[updated_at];
                archivoEnviar?.local_consultation_id = dato[local_consultation_id];
                archivoEnviar?.local_consultation_control_id = dato[local_consultation_control_id];
            }
        }
        return archivoEnviar;
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
