//
//  SQLControlMedico.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 25/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLControlMedico: SQLBase {
    
    private var id_patient_local: Expression<Int?>;
    private var subjetive_improvement: Expression<String?>;
    private var did_treatment: Expression<Bool?>;
    private var tolerated_medications: Expression<Int?>;
    private var consultation_control_id: Expression<Int?>;
    private var audio_clinic: Expression<String?>;
    private var clinic_description: Expression<String?>;
    private var audio_annex: Expression<String?>;
    private var annex_description: Expression<String?>;
    private var treatment: Expression<String?>;
    private var type_remission: Expression<String?>;
    private var remission_comments: Expression<String?>;
    private var doctor_id: Expression<Int?>;
    private var nurse_id: Expression<Int?>;
    private var consultation_id: Expression<Int?>;
    private var status: Expression<Int?>;
    private var type_professional: Expression<Int?>;
    private var local_id: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.id_patient_local = Expression<Int?>("id_patient_local");
        self.subjetive_improvement = Expression<String?>("subjetive_improvement");
        self.did_treatment = Expression<Bool?>("did_treatment");
        self.tolerated_medications = Expression<Int?>("tolerated_medications");
        self.consultation_control_id = Expression<Int?>("consultation_control_id");
        self.audio_clinic = Expression<String?>("audio_clinic");
        self.clinic_description = Expression<String?>("clinic_description");
        self.audio_annex = Expression<String?>("audio_annex");
        self.annex_description = Expression<String?>("annex_description");
        self.treatment = Expression<String?>("treatment");
        self.type_remission = Expression<String?>("type_remission");
        self.remission_comments = Expression<String?>("remission_comments");
        self.doctor_id = Expression<Int?>("doctor_id");
        self.nurse_id = Expression<Int?>("nurse_id");
        self.consultation_id = Expression<Int?>("consultation_id");
        self.status = Expression<Int?>("status");
        self.type_professional = Expression<Int?>("type_professional");
        self.local_id = Expression<Int>("local_id");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("control_medico");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(id_patient_local)
                t.column(subjetive_improvement)
                t.column(did_treatment)
                t.column(tolerated_medications)
                t.column(consultation_control_id)
                t.column(audio_clinic)
                t.column(clinic_description)
                t.column(audio_annex)
                t.column(annex_description)
                t.column(treatment)
                t.column(type_remission)
                t.column(remission_comments)
                t.column(doctor_id)
                t.column(nurse_id)
                t.column(consultation_id)
                t.column(status)
                t.column(type_professional)
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
    func insertarRegistros (data: [ControlMedico]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        id_patient_local <- item.id_patient_local,
                        subjetive_improvement <- item.subjetive_improvement,
                        did_treatment <- item.did_treatment,
                        tolerated_medications <- item.tolerated_medications,
                        consultation_control_id <- item.consultation_control_id,
                        audio_clinic <- item.audio_clinic,
                        clinic_description <- item.clinic_description,
                        audio_annex <- item.audio_anex,
                        annex_description <- item.annex_description,
                        treatment <- item.treatment,
                        type_remission <- item.type_remission,
                        remission_comments <- item.remission_comments,
                        doctor_id <- item.doctor_id,
                        nurse_id <- item.nurse_id,
                        consultation_id <- item.consultation_id,
                        status <- item.status,
                        type_professional <- item.type_professional,
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
     Método que permite registrar un dato en la tabla.
     - Parameter data: Corresponde a un objeto con la información a ingresar.
     - Returns: 0 cuando no se insertó ningún dato, ID si se realiza el registro
     */
    func insertarRegistro (data: ControlMedico) throws -> Int {
        if let db = self.database {
            let insertado = try db.run(self.tabla!.insert(
                id <- data.id,
                id_patient_local <- data.id_patient_local,
                subjetive_improvement <- data.subjetive_improvement,
                did_treatment <- data.did_treatment,
                tolerated_medications <- data.tolerated_medications,
                consultation_control_id <- data.consultation_control_id,
                audio_clinic <- data.audio_clinic,
                clinic_description <- data.clinic_description,
                audio_annex <- data.audio_anex,
                annex_description <- data.annex_description,
                treatment <- data.treatment,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                consultation_id <- data.consultation_id,
                status <- data.status,
                type_professional <- data.type_professional,
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
    func actualizarRegistro (idRegistro: Int, data: ControlMedico) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                id_patient_local <- data.id_patient_local,
                subjetive_improvement <- data.subjetive_improvement,
                did_treatment <- data.did_treatment,
                tolerated_medications <- data.tolerated_medications,
                consultation_control_id <- data.consultation_control_id,
                audio_clinic <- data.audio_clinic,
                clinic_description <- data.clinic_description,
                audio_annex <- data.audio_anex,
                annex_description <- data.annex_description,
                treatment <- data.treatment,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                consultation_id <- data.consultation_id,
                status <- data.status,
                type_professional <- data.type_professional,
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
     Método que permite actualizar la información de un registro offline específico.
     - Parameter idRegistro: Corresponde al número entero que corresponda al campo id local de la tabla. Con este dato se buscará y actualizará el registro.
     - Returns: 0 cuando no se realizó el registro.
     - Returns: 1 cuando se actualizó exitosamente.
     */
    func actualizarRegistroOffline (idRegistro: Int, data: ControlMedico) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(local_id == idRegistro).update(
                id_patient_local <- data.id_patient_local,
                subjetive_improvement <- data.subjetive_improvement,
                did_treatment <- data.did_treatment,
                tolerated_medications <- data.tolerated_medications,
                consultation_control_id <- data.consultation_control_id,
                audio_clinic <- data.audio_clinic,
                clinic_description <- data.clinic_description,
                audio_annex <- data.audio_anex,
                annex_description <- data.annex_description,
                treatment <- data.treatment,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                consultation_id <- data.consultation_id,
                status <- data.status,
                type_professional <- data.type_professional,
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
     - Returns: Retorna una lista de objetos ControlMedico
     */
    func seleccionarRegistrosTodo () throws -> [ControlMedico] {
        var datos = [ControlMedico]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = ControlMedico();
                obj.id_patient_local = item[id_patient_local];
                obj.subjetive_improvement = item[subjetive_improvement];
                obj.did_treatment = item[did_treatment];
                obj.tolerated_medications = item[tolerated_medications];
                obj.consultation_control_id = item[consultation_control_id];
                obj.audio_clinic = item[audio_clinic];
                obj.clinic_description = item[clinic_description];
                obj.audio_anex = item[audio_annex];
                obj.annex_description = item[annex_description];
                obj.treatment = item[treatment];
                obj.type_remission = item[type_remission];
                obj.remission_comments = item[remission_comments];
                obj.doctor_id = item[doctor_id];
                obj.nurse_id = item[nurse_id];
                obj.consultation_id = item[consultation_id];
                obj.status = item[status];
                obj.type_professional = item[type_professional];
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
     - Returns: Retorna un objeto ControlMedico
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> ControlMedico? {
        var obj: ControlMedico? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = ControlMedico();
                obj!.id_patient_local = item[id_patient_local];
                obj!.subjetive_improvement = item[subjetive_improvement];
                obj!.did_treatment = item[did_treatment];
                obj!.tolerated_medications = item[tolerated_medications];
                obj!.consultation_control_id = item[consultation_control_id];
                obj!.audio_clinic = item[audio_clinic];
                obj!.clinic_description = item[clinic_description];
                obj!.audio_anex = item[audio_annex];
                obj!.annex_description = item[annex_description];
                obj!.treatment = item[treatment];
                obj!.type_remission = item[type_remission];
                obj!.remission_comments = item[remission_comments];
                obj!.doctor_id = item[doctor_id];
                obj!.nurse_id = item[nurse_id];
                obj!.consultation_id = item[consultation_id];
                obj!.status = item[status];
                obj!.type_professional = item[type_professional];
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
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos ControlMedico
     */
    func seleccionarRegistrosPorSincronizacion (estaSincronizado: Bool) throws -> [ControlMedico] {
        var datos = [ControlMedico]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!.select(*).filter(sincronizado == estaSincronizado)) {
                let obj = ControlMedico();
                obj.id_patient_local = item[id_patient_local];
                obj.subjetive_improvement = item[subjetive_improvement];
                obj.did_treatment = item[did_treatment];
                obj.tolerated_medications = item[tolerated_medications];
                obj.consultation_control_id = item[consultation_control_id];
                obj.audio_clinic = item[audio_clinic];
                obj.clinic_description = item[clinic_description];
                obj.audio_anex = item[audio_annex];
                obj.annex_description = item[annex_description];
                obj.treatment = item[treatment];
                obj.type_remission = item[type_remission];
                obj.remission_comments = item[remission_comments];
                obj.doctor_id = item[doctor_id];
                obj.nurse_id = item[nurse_id];
                obj.consultation_id = item[consultation_id];
                obj.status = item[status];
                obj.type_professional = item[type_professional];
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
