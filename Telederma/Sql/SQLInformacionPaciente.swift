//
//  SQLInformacionPaciente.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 24/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLInformacionPaciente: SQLBase {
    
    private var id_patient_local: Expression<Int?>;
    private var terms_conditions: Expression<Bool?>;
    private var insurance_id: Expression<Int?>;
    private var unit_measure_age: Expression<Int?>;
    private var age: Expression<Int?>;
    private var occupation: Expression<String?>;
    private var phone: Expression<String?>;
    private var email: Expression<String?>;
    private var address: Expression<String?>;
    private var municipality_id: Expression<Int?>;
    private var urban_zone: Expression<Int?>;
    private var companion: Expression<Bool?>;
    private var name_companion: Expression<String?>;
    private var phone_companion: Expression<String?>;
    private var responsible: Expression<Bool?>;
    private var name_responsible: Expression<String?>;
    private var phone_responsible: Expression<String?>;
    private var relationship: Expression<String?>;
    private var type_user: Expression<Int?>;
    private var authorization_number: Expression<String?>;
    private var purpose_consultation: Expression<Int?>;
    private var external_cause: Expression<Int?>;
    private var civil_status: Expression<Int?>;
    private var patient_id: Expression<Int?>;
    private var status: Expression<Int?>;
    private var id_local: Expression<Int>;
    private var sincronizado: Expression<Bool>;
    
    override init(db: Connection?) {
        self.id_patient_local = Expression<Int?>("id_patient_local");
        self.terms_conditions = Expression<Bool?>("terms_conditions");
        self.insurance_id = Expression<Int?>("insurance_id");
        self.unit_measure_age = Expression<Int?>("unit_measure_age");
        self.age = Expression<Int?>("age");
        self.occupation = Expression<String?>("occupation");
        self.phone = Expression<String?>("phone");
        self.email = Expression<String?>("email");
        self.address = Expression<String?>("address");
        self.municipality_id = Expression<Int?>("municipality_id");
        self.urban_zone = Expression<Int?>("urban_zone");
        self.companion = Expression<Bool?>("companion");
        self.name_companion = Expression<String?>("name_companion");
        self.phone_companion = Expression<String?>("phone_companion");
        self.responsible = Expression<Bool?>("responsible");
        self.name_responsible = Expression<String?>("name_responsible");
        self.phone_responsible = Expression<String?>("phone_responsible");
        self.relationship = Expression<String?>("relationship");
        self.type_user = Expression<Int?>("type_user");
        self.authorization_number = Expression<String?>("authorization_number");
        self.purpose_consultation = Expression<Int?>("purpose_consultation");
        self.external_cause = Expression<Int?>("external_cause");
        self.civil_status = Expression<Int?>("civil_status");
        self.patient_id = Expression<Int?>("patient_id");
        self.status = Expression<Int?>("status");
        self.id_local = Expression<Int>("id_local");
        self.sincronizado = Expression<Bool>("sincronizado");
        super.init(db: db);
        self.tabla = Table("informacion_paciente");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(id_patient_local)
                t.column(terms_conditions)
                t.column(insurance_id)
                t.column(unit_measure_age)
                t.column(age)
                t.column(occupation)
                t.column(phone)
                t.column(email)
                t.column(address)
                t.column(municipality_id)
                t.column(urban_zone)
                t.column(companion)
                t.column(name_companion)
                t.column(phone_companion)
                t.column(responsible)
                t.column(name_responsible)
                t.column(phone_responsible)
                t.column(relationship)
                t.column(type_user)
                t.column(authorization_number)
                t.column(purpose_consultation)
                t.column(external_cause)
                t.column(civil_status)
                t.column(patient_id)
                t.column(status)
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
    func insertarRegistros (data: [InformacionPaciente]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        id_patient_local <- item.id_patient_local,
                        terms_conditions <- item.terms_conditions,
                        insurance_id <- item.insurance_id,
                        unit_measure_age <- item.unit_measure_age,
                        age <- item.age,
                        occupation <- item.occupation,
                        phone <- item.phone,
                        email <- item.email,
                        address <- item.address,
                        municipality_id <- item.municipality_id,
                        urban_zone <- item.urban_zone,
                        companion <- item.companion,
                        name_companion <- item.name_companion,
                        phone_companion <- item.phone_companion,
                        responsible <- item.responsible,
                        name_responsible <- item.name_responsible,
                        phone_responsible <- item.phone_responsible,
                        relationship <- item.relationship,
                        type_user <- item.type_user,
                        authorization_number <- item.authorization_number,
                        purpose_consultation <- item.purpose_consultation,
                        external_cause <- item.external_cause,
                        civil_status <- item.civil_status,
                        patient_id <- item.patient_id,
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
     Método que permite registrar uno dato en la tabla.
     - Parameter data: Corresponde al objeto con la información a ingresar.
     - Returns: 0 cuando no se insertó ningún dato o el ID del registro insertado
     */
    func insertarRegistro (data: InformacionPaciente) throws -> Int {
        if let db = self.database {
            let insertado = try db.run(self.tabla!.insert(
                id <- data.id,
                id_patient_local <- data.id_patient_local,
                terms_conditions <- data.terms_conditions,
                insurance_id <- data.insurance_id,
                unit_measure_age <- data.unit_measure_age,
                age <- data.age,
                occupation <- data.occupation,
                phone <- data.phone,
                email <- data.email,
                address <- data.address,
                municipality_id <- data.municipality_id,
                urban_zone <- data.urban_zone,
                companion <- data.companion,
                name_companion <- data.name_companion,
                phone_companion <- data.phone_companion,
                responsible <- data.responsible,
                name_responsible <- data.name_responsible,
                phone_responsible <- data.phone_responsible,
                relationship <- data.relationship,
                type_user <- data.type_user,
                authorization_number <- data.authorization_number,
                purpose_consultation <- data.purpose_consultation,
                external_cause <- data.external_cause,
                civil_status <- data.civil_status,
                patient_id <- data.patient_id,
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
    func actualizarRegistro (idRegistro: Int, data: InformacionPaciente) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                id_patient_local <- data.id_patient_local,
                terms_conditions <- data.terms_conditions,
                insurance_id <- data.insurance_id,
                unit_measure_age <- data.unit_measure_age,
                age <- data.age,
                occupation <- data.occupation,
                phone <- data.phone,
                email <- data.email,
                address <- data.address,
                municipality_id <- data.municipality_id,
                urban_zone <- data.urban_zone,
                companion <- data.companion,
                name_companion <- data.name_companion,
                phone_companion <- data.phone_companion,
                responsible <- data.responsible,
                name_responsible <- data.name_responsible,
                phone_responsible <- data.phone_responsible,
                relationship <- data.relationship,
                type_user <- data.type_user,
                authorization_number <- data.authorization_number,
                purpose_consultation <- data.purpose_consultation,
                external_cause <- data.external_cause,
                civil_status <- data.civil_status,
                patient_id <- data.patient_id,
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
    func actualizarRegistroOffline (idRegistro: Int, data: InformacionPaciente) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id_local == idRegistro).update(
                id_patient_local <- data.id_patient_local,
                terms_conditions <- data.terms_conditions,
                insurance_id <- data.insurance_id,
                unit_measure_age <- data.unit_measure_age,
                age <- data.age,
                occupation <- data.occupation,
                phone <- data.phone,
                email <- data.email,
                address <- data.address,
                municipality_id <- data.municipality_id,
                urban_zone <- data.urban_zone,
                companion <- data.companion,
                name_companion <- data.name_companion,
                phone_companion <- data.phone_companion,
                responsible <- data.responsible,
                name_responsible <- data.name_responsible,
                phone_responsible <- data.phone_responsible,
                relationship <- data.relationship,
                type_user <- data.type_user,
                authorization_number <- data.authorization_number,
                purpose_consultation <- data.purpose_consultation,
                external_cause <- data.external_cause,
                civil_status <- data.civil_status,
                patient_id <- data.patient_id,
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
     - Returns: Retorna una lista de objetos InformacionPaciente
     */
    func seleccionarRegistrosTodo () throws -> [InformacionPaciente] {
        var datos = [InformacionPaciente]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = InformacionPaciente();
                obj.id_patient_local = item[id_patient_local];
                obj.terms_conditions = item[terms_conditions];
                obj.insurance_id = item[insurance_id];
                obj.unit_measure_age = item[unit_measure_age];
                obj.age = item[age];
                obj.occupation = item[occupation];
                obj.phone = item[phone];
                obj.email = item[email];
                obj.address = item[address];
                obj.municipality_id = item[municipality_id];
                obj.urban_zone = item[urban_zone];
                obj.companion = item[companion];
                obj.name_companion = item[name_companion];
                obj.phone_companion = item[phone_companion];
                obj.responsible = item[responsible];
                obj.name_responsible = item[name_responsible];
                obj.phone_responsible = item[phone_responsible];
                obj.relationship = item[relationship];
                obj.type_user = item[type_user];
                obj.authorization_number = item[authorization_number];
                obj.purpose_consultation = item[purpose_consultation];
                obj.external_cause = item[external_cause];
                obj.civil_status = item[civil_status];
                obj.patient_id = item[patient_id];
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
     - Returns: Retorna un objeto InformacionPaciente
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> InformacionPaciente? {
        var obj: InformacionPaciente? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = InformacionPaciente();
                obj!.id_patient_local = item[id_patient_local];
                obj!.terms_conditions = item[terms_conditions];
                obj!.insurance_id = item[insurance_id];
                obj!.unit_measure_age = item[unit_measure_age];
                obj!.age = item[age];
                obj!.occupation = item[occupation];
                obj!.phone = item[phone];
                obj!.email = item[email];
                obj!.address = item[address];
                obj!.municipality_id = item[municipality_id];
                obj!.urban_zone = item[urban_zone];
                obj!.companion = item[companion];
                obj!.name_companion = item[name_companion];
                obj!.phone_companion = item[phone_companion];
                obj!.responsible = item[responsible];
                obj!.name_responsible = item[name_responsible];
                obj!.phone_responsible = item[phone_responsible];
                obj!.relationship = item[relationship];
                obj!.type_user = item[type_user];
                obj!.authorization_number = item[authorization_number];
                obj!.purpose_consultation = item[purpose_consultation];
                obj!.external_cause = item[external_cause];
                obj!.civil_status = item[civil_status];
                obj!.patient_id = item[patient_id];
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
