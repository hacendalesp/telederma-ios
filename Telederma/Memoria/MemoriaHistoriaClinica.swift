//
//  MemoriaHistoriaClinica.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 7/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class MemoriaHistoriaClinica: NSObject {
    
    static var paciente: Paciente?;
    static var consultasMedicas = [ConsultaMedica]();
    static var requerimientos = [Requerimiento]();
    static var lesiones = [Lesion]();
    static var imagenesLesiones = [ImagenLesion]();
    static var controlesMedicos = [ControlMedico]();
    static var respuestasEspecialistas = [RespuestaEspecialista]();
    static var diagnosticos = [Diagnostico]();
    static var examenesSolicitados = [ExamenSolicitado]();
    static var formulas = [Formula]();
    static var mipres = [Mipres]();
    // Variable para el saber si un control está activo y se replique en todas las pestañas.
    static var posicionControlActivo = 0;
    // fila lista de controles, ID de la imagen lesión padre, y la imagen
    static var imagenesPadre = [Int: [Int: UIImage]]();
    // ID imagen lesión padre, id de la imagen y lista de imágenes
    static var imagenesHijas = [Int: [Int: UIImage]]();
    // Listas con el orden de las imagenes para la vista en detalle.
    // fila de lista de controles, y lista de elementos en orden.
    static var ordenPadre = [Int: [Int]]();
    // id del padre, y lista de elementos en orden.
    static var ordenHija = [Int: [Int]]();
    
    // El índice corresponde al ID de la consulta
    static var informacionPaciente = [Int: [InformacionPaciente]]();
    static var medico = [Usuario]();
    static var especialista = [Especialista]();
    
    class func reiniciarVariables () {
        // Se reinician los valores en memoria de Historia Clínica
        MemoriaHistoriaClinica.consultasMedicas = [];
        MemoriaHistoriaClinica.controlesMedicos = [];
        MemoriaHistoriaClinica.diagnosticos = [];
        MemoriaHistoriaClinica.especialista = [];
        MemoriaHistoriaClinica.examenesSolicitados = [];
        MemoriaHistoriaClinica.formulas = [];
        MemoriaHistoriaClinica.imagenesLesiones = [];
        MemoriaHistoriaClinica.lesiones = [];
        MemoriaHistoriaClinica.requerimientos = [];
        MemoriaHistoriaClinica.medico = [];
        MemoriaHistoriaClinica.mipres = [];
        MemoriaHistoriaClinica.posicionControlActivo = 0;
        MemoriaHistoriaClinica.paciente = nil;
        MemoriaHistoriaClinica.informacionPaciente.removeAll();
        MemoriaHistoriaClinica.respuestasEspecialistas.removeAll();
        MemoriaHistoriaClinica.imagenesPadre.removeAll();
        MemoriaHistoriaClinica.imagenesHijas.removeAll();
        MemoriaHistoriaClinica.ordenPadre.removeAll();
        MemoriaHistoriaClinica.ordenHija.removeAll();
    }
    
    class func reiniciarVariablesSinControlActivo () {
        // Se reinician los valores en memoria de Historia Clínica
        MemoriaHistoriaClinica.consultasMedicas = [];
        MemoriaHistoriaClinica.controlesMedicos = [];
        MemoriaHistoriaClinica.diagnosticos = [];
        MemoriaHistoriaClinica.especialista = [];
        MemoriaHistoriaClinica.examenesSolicitados = [];
        MemoriaHistoriaClinica.formulas = [];
        MemoriaHistoriaClinica.imagenesLesiones = [];
        MemoriaHistoriaClinica.lesiones = [];
        MemoriaHistoriaClinica.requerimientos = [];
        MemoriaHistoriaClinica.medico = [];
        MemoriaHistoriaClinica.mipres = [];
        MemoriaHistoriaClinica.paciente = nil;
        MemoriaHistoriaClinica.informacionPaciente.removeAll();
        MemoriaHistoriaClinica.respuestasEspecialistas.removeAll();
        MemoriaHistoriaClinica.imagenesPadre.removeAll();
        MemoriaHistoriaClinica.imagenesHijas.removeAll();
        MemoriaHistoriaClinica.ordenPadre.removeAll();
        MemoriaHistoriaClinica.ordenHija.removeAll();
    }
}
