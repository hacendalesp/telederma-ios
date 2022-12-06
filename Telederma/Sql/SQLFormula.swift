//
//  SQLFormula.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 25/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class SQLFormula: SQLBase {
    
    private var specialist_response_id: Expression<Int?>;
    private var medication_code: Expression<String?>;
    private var type_medicament: Expression<String?>;
    private var generic_name_medicament: Expression<String?>;
    private var pharmaceutical_form: Expression<String?>;
    private var drug_concentration: Expression<String?>;
    private var unit_measure_medication: Expression<String?>;
    private var number_of_units: Expression<String?>;
    private var unit_value_medicament: Expression<String?>;
    private var total_value_medicament: Expression<String?>;
    private var commentations: Expression<String?>;
    
    override init(db: Connection?) {
        self.specialist_response_id = Expression<Int?>("specialist_response_id");
        self.medication_code = Expression<String?>("medication_code");
        self.type_medicament = Expression<String?>("type_medicament");
        self.generic_name_medicament = Expression<String?>("generic_name_medicament");
        self.pharmaceutical_form = Expression<String?>("pharmaceutical_form");
        self.drug_concentration = Expression<String?>("drug_concentration");
        self.unit_measure_medication = Expression<String?>("unit_measure_medication");
        self.number_of_units = Expression<String?>("number_of_units");
        self.unit_value_medicament = Expression<String?>("unit_value_medicament");
        self.total_value_medicament = Expression<String?>("total_value_medicament");
        self.commentations = Expression<String?>("commentations");
        super.init(db: db);
        self.tabla = Table("formula");
    }
    
    /**
     Método que permite crear la tabla en la base de datos de la conexión.
     - Throws: Se debe manejar posibles errores asociados
     */
    func crearTabla () throws {
        if let db = self.database {
            try db.run(self.tabla!.create(ifNotExists: true) { t in
                t.column(specialist_response_id)
                t.column(medication_code)
                t.column(type_medicament)
                t.column(generic_name_medicament)
                t.column(pharmaceutical_form)
                t.column(drug_concentration)
                t.column(unit_measure_medication)
                t.column(unit_value_medicament)
                t.column(number_of_units)
                t.column(total_value_medicament)
                t.column(commentations)
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
    func insertarRegistros (data: [Formula]) throws -> Int {
        if let db = self.database {
            if (data.count > 0) {
                var contador = 0;
                for item in data {
                    let insertado = try db.run(self.tabla!.insert(
                        id <- item.id,
                        specialist_response_id <- item.specialist_response_id!,
                        medication_code <- item.medication_code!,
                        type_medicament <- item.type_medicament,
                        generic_name_medicament <- item.generic_name_medicament,
                        pharmaceutical_form <- item.pharmaceutical_form,
                        drug_concentration <- item.drug_concentration,
                        unit_measure_medication <- item.unit_measure_medication,
                        unit_value_medicament <- item.unit_value_medicament,
                        number_of_units <- item.number_of_units,
                        total_value_medicament <- item.total_value_medicament,
                        commentations <- item.commentations,
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
    func actualizarRegistro (idRegistro: Int, data: Formula) throws -> Int{
        if let db = self.database {
            let actualizado = try db.run(self.tabla!.filter(id == idRegistro).update(
                specialist_response_id <- data.specialist_response_id!,
                medication_code <- data.medication_code!,
                type_medicament <- data.type_medicament,
                generic_name_medicament <- data.generic_name_medicament,
                pharmaceutical_form <- data.pharmaceutical_form,
                drug_concentration <- data.drug_concentration,
                unit_measure_medication <- data.unit_measure_medication,
                unit_value_medicament <- data.unit_value_medicament,
                number_of_units <- data.number_of_units,
                total_value_medicament <- data.total_value_medicament,
                commentations <- data.commentations,
                created_at <- data.created_at,
                updated_at <- data.updated_at
            ));
            return actualizado;
        }
        return 0;
    }
    
    /**
     Método que permite obtener toda la información de la tabla.
     - Returns: Retorna una lista de objetos Formula
     */
    func seleccionarRegistrosTodo () throws -> [Formula] {
        var datos = [Formula]();
        if let db = self.database {
            for item in try db.prepare(self.tabla!) {
                let obj = Formula();
                obj.specialist_response_id = item[specialist_response_id];
                obj.medication_code = item[medication_code];
                obj.type_medicament = item[type_medicament];
                obj.generic_name_medicament = item[generic_name_medicament];
                obj.pharmaceutical_form = item[pharmaceutical_form];
                obj.drug_concentration = item[drug_concentration];
                obj.unit_measure_medication = item[unit_measure_medication];
                obj.unit_value_medicament = item[unit_value_medicament];
                obj.number_of_units = item[number_of_units];
                obj.total_value_medicament = item[total_value_medicament];
                obj.commentations = item[commentations];
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
     - Returns: Retorna un objeto Formula
     */
    func seleccionarRegistrosPorId (idRegistro: Int) throws -> Formula? {
        var obj: Formula? = nil;
        if let db = self.database {
            let query = self.tabla!.select(*).filter(id == idRegistro).limit(1);
            if let item = try db.pluck(query){
                obj = Formula();
                obj!.specialist_response_id = item[specialist_response_id];
                obj!.medication_code = item[medication_code];
                obj!.type_medicament = item[type_medicament];
                obj!.generic_name_medicament = item[generic_name_medicament];
                obj!.pharmaceutical_form = item[pharmaceutical_form];
                obj!.drug_concentration = item[drug_concentration];
                obj!.unit_measure_medication = item[unit_measure_medication];
                obj!.unit_value_medicament = item[unit_value_medicament];
                obj!.number_of_units = item[number_of_units];
                obj!.total_value_medicament = item[total_value_medicament];
                obj!.commentations = item[commentations];
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
