//
//  MemoriaRegistroPaciente.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class MemoriaRegistroPaciente: NSObject {
    static var paciente: Paciente? = nil;
    static var informacionPaciente: InformacionPaciente? = nil;
    // Advierte si el usuario no ingresó texto en la interfaz de paciente antes de pasar a consulta.
    static var busquedaVacia = false;
    
    class func reiniciarVariables () {
        MemoriaRegistroPaciente.paciente = nil;
        MemoriaRegistroPaciente.informacionPaciente = nil;
        MemoriaRegistroPaciente.busquedaVacia = false;
    }
}
