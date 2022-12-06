//
//  SQLConsultaMedica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLConsultaMedica: SQLBase {
    
    private var local_patient_information_id: Expression<Int?>;
    private var evolution_time: Expression<Int?>;
    private var unit_measurement: Expression<Int?>;
    private var weight: Expression<String?>;
    private var consultation_id: Expression<Int?>;
    private var number_injuries: Expression<Int?>;
    private var evolution_injuries: Expression<String?>;
    private var blood: Expression<Bool?>;
    private var exude: Expression<Bool?>;
    private var suppurate: Expression<Bool?>;
    private var symptom: Expression<String?>;
    private var change_symptom: Expression<Int?>;
    private var other_factors_symptom: Expression<String?>;
    private var aggravating_factors: Expression<String?>;
    private var family_background: Expression<String?>;
    private var personal_history: Expression<String?>;
    private var treatment_received: Expression<String?>;
    private var applied_substances: Expression<String?>;
    private var treatment_effects: Expression<String?>;
    private var description_physical_examination: Expression<String?>;
    private var physical_audio: Expression<String?>;
    private var type_remission: Expression<String?>;
    private var remission_comments: Expression<String?>;
    private var archived: Expression<Int?>;
    private var count_controls: Expression<Int?>;
    private var treatment: Expression<String?>;
    private var date_archived: Expression<String?>;
    private var type_professional: Expression<Int?>;
    private var readed: Expression<Int?>;
    private var annex_description: Expression<String?>;
    private var audio_annex: Expression<String?>;
    private var patient_id: Expression<Int?>;
    private var patient_information_id: Expression<Int?>;
    private var status: Expression<Int?>;
    private var doctor_id: Expression<Int?>;
    private var nurse_id: Expression<Int?>;
    private var diagnostic_impression: Expression<String?>;
    private var ciediezcode: Expression<String?>;
    private var id_local: Expression<Int>;
    
    private var other_factors_is_on: Expression<Bool?>;
    private var history_is_on: Expression<Bool?>;
    private var treatment_received_is_on: Expression<Bool?>;
    private var other_substances_is_on: Expression<Bool?>;
    private var treatment_effects_is_on: Expression<Bool?>;
    
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.local_patient_information_id = Expression<Int?>("local_patient_information_id");
        self.evolution_time = Expression<Int?>("evolution_time");
        self.unit_measurement = Expression<Int?>("unit_measurement");
        self.weight = Expression<String?>("weight");
        self.consultation_id = Expression<Int?>("consultation_id");
        self.number_injuries = Expression<Int?>("number_injuries");
        self.evolution_injuries = Expression<String?>("evolution_injuries");
        self.blood = Expression<Bool?>("blood");
        self.exude = Expression<Bool?>("exude");
        self.suppurate = Expression<Bool?>("suppurate");
        self.symptom = Expression<String?>("symptom");
        self.change_symptom = Expression<Int?>("change_symptom");
        self.other_factors_symptom = Expression<String?>("other_factors_symptom");
        self.aggravating_factors = Expression<String?>("aggravating_factors");
        self.family_background = Expression<String?>("family_background");
        self.personal_history = Expression<String?>("personal_history");
        self.treatment_received = Expression<String?>("treatment_received");
        self.applied_substances = Expression<String?>("applied_substances");
        self.treatment_effects = Expression<String?>("treatment_effects");
        self.description_physical_examination = Expression<String?>("description_physical_examination");
        self.physical_audio = Expression<String?>("physical_audio");
        self.type_remission = Expression<String?>("type_remission");
        self.remission_comments = Expression<String?>("remission_comments");
        self.archived = Expression<Int?>("archived");
        self.count_controls = Expression<Int?>("count_controls");
        self.treatment = Expression<String?>("treatment");
        self.date_archived = Expression<String?>("date_archived");
        self.type_professional = Expression<Int?>("type_professional");
        self.readed = Expression<Int?>("readed");
        self.annex_description = Expression<String?>("annex_description");
        self.audio_annex = Expression<String?>("audio_annex");
        self.patient_id = Expression<Int?>("patient_id");
        self.patient_information_id = Expression<Int?>("patient_information_id");
        self.status = Expression<Int?>("status");
        self.doctor_id = Expression<Int?>("doctor_id");
        self.nurse_id = Expression<Int?>("nurse_id");
        self.diagnostic_impression = Expression<String?>("diagnostic_impression");
        self.ciediezcode = Expression<String?>("ciediezcode");
        self.id_local = Expression<Int>("id_local");
        self.other_factors_is_on = Expression<Bool?>("other_factors_is_on");
        self.history_is_on = Expression<Bool?>("history_is_on");
        self.treatment_received_is_on = Expression<Bool?>("treatment_received_is_on");
        self.other_substances_is_on = Expression<Bool?>("other_substances_is_on");
        self.treatment_effects_is_on = Expression<Bool?>("treatment_effects_is_on");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("consulta_medica");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(local_patient_information_id)
                t.column(evolution_time)
                t.column(unit_measurement)
                t.column(weight)
                t.column(consultation_id)
                t.column(number_injuries)
                t.column(evolution_injuries)
                t.column(blood)
                t.column(exude)
                t.column(suppurate)
                t.column(symptom)
                t.column(change_symptom)
                t.column(other_factors_symptom)
                t.column(aggravating_factors)
                t.column(family_background)
                t.column(personal_history)
                t.column(treatment_received)
                t.column(applied_substances)
                t.column(treatment_effects)
                t.column(description_physical_examination)
                t.column(physical_audio)
                t.column(type_remission)
                t.column(remission_comments)
                t.column(archived)
                t.column(count_controls)
                t.column(treatment)
                t.column(date_archived)
                t.column(type_professional)
                t.column(readed)
                t.column(annex_description)
                t.column(audio_annex)
                t.column(patient_id)
                t.column(patient_information_id)
                t.column(status)
                t.column(doctor_id)
                t.column(nurse_id)
                t.column(diagnostic_impression)
                t.column(ciediezcode)
                t.column(id)
                t.column(id_local, primaryKey: .autoincrement)
                t.column(created_at)
                t.column(updated_at)
                
                t.column(other_factors_is_on)
                t.column(history_is_on)
                t.column(treatment_received_is_on)
                t.column(other_substances_is_on)
                t.column(treatment_effects_is_on)
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
    func insertarRegistros (data: [ConsultaMedica]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        local_patient_information_id <- item.local_patient_information_id,
                        evolution_time <- item.evolution_time,
                        unit_measurement <- item.unit_measurement,
                        weight <- item.weight,
                        consultation_id <- item.consultation_id,
                        number_injuries <- item.number_injuries,
                        evolution_injuries <- item.evolution_injuries,
                        blood <- item.blood,
                        exude <- item.exude,
                        suppurate <- item.suppurate,
                        symptom <- item.symptom,
                        change_symptom <- item.change_symptom,
                        other_factors_symptom <- item.other_factors_symptom,
                        aggravating_factors <- item.aggravating_factors,
                        family_background <- item.family_background,
                        personal_history <- item.personal_history,
                        treatment_received <- item.treatment_received,
                        applied_substances <- item.applied_substances,
                        treatment_effects <- item.treatment_effects,
                        description_physical_examination <- item.description_physical_examination,
                        physical_audio <- item.physical_audio,
                        type_remission <- item.type_remission,
                        remission_comments <- item.remission_comments,
                        archived <- item.archived,
                        count_controls <- item.count_controls,
                        treatment <- item.treatment,
                        date_archived <- item.date_archived,
                        type_professional <- item.type_professional,
                        readed <- item.readed,
                        annex_description <- item.annex_description,
                        audio_annex <- item.audio_annex,
                        patient_id <- item.patient_id,
                        patient_information_id <- item.patient_information_id,
                        status <- item.status,
                        doctor_id <- item.doctor_id,
                        nurse_id <- item.nurse_id,
                        diagnostic_impression <- item.diagnostic_impression,
                        ciediezcode <- item.ciediezcode,
                        created_at <- item.created_at,
                        updated_at <- item.updated_at,
                        
                        other_factors_is_on <- item.other_factors_is_on,
                        history_is_on <- item.history_is_on,
                        treatment_received_is_on <- item.treatment_received_is_on,
                        other_substances_is_on <- item.other_substances_is_on,
                        treatment_effects_is_on <- item.treatment_effects_is_on,
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
     - Returns: 0 cuando no se insertó ningún dato, ID cuando se realiza el registro.
     */
    func insertarRegistro (data: ConsultaMedica) throws -> Int {
        if let db = self.database {
            let insertado = try db.run(self.tabla!.insert(
                id <- data.id,
                local_patient_information_id <- data.local_patient_information_id,
                evolution_time <- data.evolution_time,
                unit_measurement <- data.unit_measurement,
                weight <- data.weight,
                consultation_id <- data.consultation_id,
                number_injuries <- data.number_injuries,
                evolution_injuries <- data.evolution_injuries,
                blood <- data.blood,
                exude <- data.exude,
                suppurate <- data.suppurate,
                symptom <- data.symptom,
                change_symptom <- data.change_symptom,
                other_factors_symptom <- data.other_factors_symptom,
                aggravating_factors <- data.aggravating_factors,
                family_background <- data.family_background,
                personal_history <- data.personal_history,
                treatment_received <- data.treatment_received,
                applied_substances <- data.applied_substances,
                treatment_effects <- data.treatment_effects,
                description_physical_examination <- data.description_physical_examination,
                physical_audio <- data.physical_audio,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                archived <- data.archived,
                count_controls <- data.count_controls,
                treatment <- data.treatment,
                date_archived <- data.date_archived,
                type_professional <- data.type_professional,
                readed <- data.readed,
                annex_description <- data.annex_description,
                audio_annex <- data.audio_annex,
                patient_id <- data.patient_id,
                patient_information_id <- data.patient_information_id,
                status <- data.status,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                diagnostic_impression <- data.diagnostic_impression,
                ciediezcode <- data.ciediezcode,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                
                other_factors_is_on <- data.other_factors_is_on,
                history_is_on <- data.history_is_on,
                treatment_received_is_on <- data.treatment_received_is_on,
                other_substances_is_on <- data.other_substances_is_on,
                treatment_effects_is_on <- data.treatment_effects_is_on,
                sincronizado <- data.sincronizado
            ))
            
            print(insertado);
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
    func actualizarRegistro (idRegistro: Int, data: ConsultaMedica) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                id <- data.id,
                local_patient_information_id <- data.local_patient_information_id,
                evolution_time <- data.evolution_time,
                unit_measurement <- data.unit_measurement,
                weight <- data.weight,
                consultation_id <- data.consultation_id,
                number_injuries <- data.number_injuries,
                evolution_injuries <- data.evolution_injuries,
                blood <- data.blood,
                exude <- data.exude,
                suppurate <- data.suppurate,
                symptom <- data.symptom,
                change_symptom <- data.change_symptom,
                other_factors_symptom <- data.other_factors_symptom,
                aggravating_factors <- data.aggravating_factors,
                family_background <- data.family_background,
                personal_history <- data.personal_history,
                treatment_received <- data.treatment_received,
                applied_substances <- data.applied_substances,
                treatment_effects <- data.treatment_effects,
                description_physical_examination <- data.description_physical_examination,
                physical_audio <- data.physical_audio,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                archived <- data.archived,
                count_controls <- data.count_controls,
                treatment <- data.treatment,
                date_archived <- data.date_archived,
                type_professional <- data.type_professional,
                readed <- data.readed,
                annex_description <- data.annex_description,
                audio_annex <- data.audio_annex,
                patient_id <- data.patient_id,
                patient_information_id <- data.patient_information_id,
                status <- data.status,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                diagnostic_impression <- data.diagnostic_impression,
                ciediezcode <- data.ciediezcode,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                
                other_factors_is_on <- data.other_factors_is_on,
                history_is_on <- data.history_is_on,
                treatment_received_is_on <- data.treatment_received_is_on,
                other_substances_is_on <- data.other_substances_is_on,
                treatment_effects_is_on <- data.treatment_effects_is_on,
                sincronizado <- data.sincronizado
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
    func actualizarRegistroOffline (idRegistro: Int, data: ConsultaMedica) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id_local == idRegistro).update(
                id <- data.id,
                local_patient_information_id <- data.local_patient_information_id,
                evolution_time <- data.evolution_time,
                unit_measurement <- data.unit_measurement,
                weight <- data.weight,
                consultation_id <- data.consultation_id,
                number_injuries <- data.number_injuries,
                evolution_injuries <- data.evolution_injuries,
                blood <- data.blood,
                exude <- data.exude,
                suppurate <- data.suppurate,
                symptom <- data.symptom,
                change_symptom <- data.change_symptom,
                other_factors_symptom <- data.other_factors_symptom,
                aggravating_factors <- data.aggravating_factors,
                family_background <- data.family_background,
                personal_history <- data.personal_history,
                treatment_received <- data.treatment_received,
                applied_substances <- data.applied_substances,
                treatment_effects <- data.treatment_effects,
                description_physical_examination <- data.description_physical_examination,
                physical_audio <- data.physical_audio,
                type_remission <- data.type_remission,
                remission_comments <- data.remission_comments,
                archived <- data.archived,
                count_controls <- data.count_controls,
                treatment <- data.treatment,
                date_archived <- data.date_archived,
                type_professional <- data.type_professional,
                readed <- data.readed,
                annex_description <- data.annex_description,
                audio_annex <- data.audio_annex,
                patient_id <- data.patient_id,
                patient_information_id <- data.patient_information_id,
                status <- data.status,
                doctor_id <- data.doctor_id,
                nurse_id <- data.nurse_id,
                diagnostic_impression <- data.diagnostic_impression,
                ciediezcode <- data.ciediezcode,
                created_at <- data.created_at,
                updated_at <- data.updated_at,
                
                other_factors_is_on <- data.other_factors_is_on,
                history_is_on <- data.history_is_on,
                treatment_received_is_on <- data.treatment_received_is_on,
                other_substances_is_on <- data.other_substances_is_on,
                treatment_effects_is_on <- data.treatment_effects_is_on,
                sincronizado <- data.sincronizado
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos ConsultaMedica
     */
    func seleccionarRegistrosTodoConsultaMedica () throws -> [ConsultaMedica] {
        var datos = [ConsultaMedica]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = ConsultaMedica();
                obj.local_patient_information_id = item[local_patient_information_id];
                obj.evolution_time = item[evolution_time];
                obj.unit_measurement = item[unit_measurement];
                obj.weight = item[weight];
                obj.consultation_id = item[consultation_id];
                obj.number_injuries = item[number_injuries];
                obj.evolution_injuries = item[evolution_injuries];
                obj.blood = item[blood];
                obj.exude = item[exude];
                obj.suppurate = item[suppurate];
                obj.symptom = item[symptom];
                obj.change_symptom = item[change_symptom];
                obj.other_factors_symptom = item[other_factors_symptom];
                obj.aggravating_factors = item[aggravating_factors];
                obj.family_background = item[family_background];
                obj.personal_history = item[personal_history];
                obj.treatment_received = item[treatment_received];
                obj.applied_substances = item[applied_substances];
                obj.treatment_effects = item[treatment_effects];
                obj.description_physical_examination = item[description_physical_examination];
                obj.physical_audio = item[physical_audio];
                obj.type_remission = item[type_remission];
                obj.remission_comments = item[remission_comments];
                obj.archived = item[archived];
                obj.count_controls = item[count_controls];
                obj.treatment = item[treatment];
                obj.date_archived = item[date_archived];
                obj.type_professional = item[type_professional];
                obj.readed = item[readed];
                obj.annex_description = item[annex_description];
                obj.audio_annex = item[audio_annex];
                obj.patient_id = item[patient_id];
                obj.patient_information_id = item[patient_information_id];
                obj.status = item[status];
                obj.doctor_id = item[doctor_id];
                obj.nurse_id = item[nurse_id];
                obj.diagnostic_impression = item[diagnostic_impression];
                obj.ciediezcode = item[ciediezcode];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                
                obj.other_factors_is_on = item[other_factors_is_on];
                obj.history_is_on = item[history_is_on];
                obj.treatment_received_is_on = item[treatment_received_is_on];
                obj.other_substances_is_on = item[other_substances_is_on];
                obj.treatment_effects_is_on = item[treatment_effects_is_on]
                
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
     - Returns: Retorna un objeto ConsultaMedica
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> ConsultaMedica? {
        var obj: ConsultaMedica? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = ConsultaMedica();
                obj!.local_patient_information_id = item[local_patient_information_id];
                obj!.evolution_time = item[evolution_time];
                obj!.unit_measurement = item[unit_measurement];
                obj!.weight = item[weight];
                obj!.consultation_id = item[consultation_id];
                obj!.number_injuries = item[number_injuries];
                obj!.evolution_injuries = item[evolution_injuries];
                obj!.blood = item[blood];
                obj!.exude = item[exude];
                obj!.suppurate = item[suppurate];
                obj!.symptom = item[symptom];
                obj!.change_symptom = item[change_symptom];
                obj!.other_factors_symptom = item[other_factors_symptom];
                obj!.aggravating_factors = item[aggravating_factors];
                obj!.family_background = item[family_background];
                obj!.personal_history = item[personal_history];
                obj!.treatment_received = item[treatment_received];
                obj!.applied_substances = item[applied_substances];
                obj!.treatment_effects = item[treatment_effects];
                obj!.description_physical_examination = item[description_physical_examination];
                obj!.physical_audio = item[physical_audio];
                obj!.type_remission = item[type_remission];
                obj!.remission_comments = item[remission_comments];
                obj!.archived = item[archived];
                obj!.count_controls = item[count_controls];
                obj!.treatment = item[treatment];
                obj!.date_archived = item[date_archived];
                obj!.type_professional = item[type_professional];
                obj!.readed = item[readed];
                obj!.annex_description = item[annex_description];
                obj!.audio_annex = item[audio_annex];
                obj!.patient_id = item[patient_id];
                obj!.patient_information_id = item[patient_information_id];
                obj!.status = item[status];
                obj!.doctor_id = item[doctor_id];
                obj!.nurse_id = item[nurse_id];
                obj!.diagnostic_impression = item[diagnostic_impression];
                obj!.ciediezcode = item[ciediezcode];
                obj!.id = item[id];
                obj!.created_at = item[created_at];
                obj!.updated_at = item[updated_at];
                
                obj!.other_factors_is_on = item[other_factors_is_on];
                obj!.history_is_on = item[history_is_on];
                obj!.treatment_received_is_on = item[treatment_received_is_on];
                obj!.other_substances_is_on = item[other_substances_is_on];
                obj!.treatment_effects_is_on = item[treatment_effects_is_on];
                
                obj!.id_local = item[id_local];
                obj!.sincronizado = item[sincronizado];
            }
        }
        return obj;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos ConsultaMedica
     */
    func seleccionarRegistrosPorSincronizadoConsultaMedica (estaSincronizado: Bool) throws -> [ConsultaMedica] {
        var datos = [ConsultaMedica]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!.select(*).filter(sincronizado == estaSincronizado)) {
                let obj = ConsultaMedica();
                obj.local_patient_information_id = item[local_patient_information_id];
                obj.evolution_time = item[evolution_time];
                obj.unit_measurement = item[unit_measurement];
                obj.weight = item[weight];
                obj.consultation_id = item[consultation_id];
                obj.number_injuries = item[number_injuries];
                obj.evolution_injuries = item[evolution_injuries];
                obj.blood = item[blood];
                obj.exude = item[exude];
                obj.suppurate = item[suppurate];
                obj.symptom = item[symptom];
                obj.change_symptom = item[change_symptom];
                obj.other_factors_symptom = item[other_factors_symptom];
                obj.aggravating_factors = item[aggravating_factors];
                obj.family_background = item[family_background];
                obj.personal_history = item[personal_history];
                obj.treatment_received = item[treatment_received];
                obj.applied_substances = item[applied_substances];
                obj.treatment_effects = item[treatment_effects];
                obj.description_physical_examination = item[description_physical_examination];
                obj.physical_audio = item[physical_audio];
                obj.type_remission = item[type_remission];
                obj.remission_comments = item[remission_comments];
                obj.archived = item[archived];
                obj.count_controls = item[count_controls];
                obj.treatment = item[treatment];
                obj.date_archived = item[date_archived];
                obj.type_professional = item[type_professional];
                obj.readed = item[readed];
                obj.annex_description = item[annex_description];
                obj.audio_annex = item[audio_annex];
                obj.patient_id = item[patient_id];
                obj.patient_information_id = item[patient_information_id];
                obj.status = item[status];
                obj.doctor_id = item[doctor_id];
                obj.nurse_id = item[nurse_id];
                obj.diagnostic_impression = item[diagnostic_impression];
                obj.ciediezcode = item[ciediezcode];
                obj.id = item[id];
                obj.created_at = item[created_at];
                obj.updated_at = item[updated_at];
                
                obj.other_factors_is_on = item[other_factors_is_on];
                obj.history_is_on = item[history_is_on];
                obj.treatment_received_is_on = item[treatment_received_is_on];
                obj.other_substances_is_on = item[other_substances_is_on];
                obj.treatment_effects_is_on = item[treatment_effects_is_on]
                
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

