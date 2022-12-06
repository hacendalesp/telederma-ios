//
//  Conexion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SQLite

class Conexion: NSObject {
    private var path: String;
    private var db: Connection?;
    
    override init() {
        /// Se define la ruta en donde se almacenará la base de datos.
        self.path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!;
        
        /// Se inicializa la base de datos en nil
        self.db = nil;
    }
    
    /**
     El método permite conectarse con la base de datos. Si el archivo no existe lo crea.
     */
    func conectarBaseDatos(){
        do{
            self.db = try Connection("\(self.path)/\(Constantes.NOMBRE_BASE_DATOS)");
        } catch {
            self.db = nil;
            print("Error conectar base de datos: \(error)");
        }
    }
    
    /**
     Este método permite borrar el archivo de la bse de datos del dispositivo.
     */
    func borrarBaseDeDatos() {
        let fileManager = FileManager.default;
        
        if fileManager.fileExists(atPath: "\(self.path)/\(Constantes.NOMBRE_BASE_DATOS)") {
            do {
                try fileManager.removeItem(atPath: "\(self.path)/\(Constantes.NOMBRE_BASE_DATOS)");
                print("Base de datos eliminada");
            } catch let error as NSError {
                print("Error on Delete Database: \(error)")
            }
        } else {
            print("Base de datos no existe.");
        }
    }
    
    /**
     Permite acceder a la conexión con la base de datos.
     - Returns: Devuleve el objeto conexion (opcional) o nil.
     */
    func obtenerConexion() -> Connection? {
        return self.db;
    }
}
