//
//  MemoriaRegistroConsulta.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class MemoriaRegistroConsulta: NSObject {
    static var consultaMedica: ConsultaMedica?;
    static var lesion: Lesion?;
    static var controlMedico: ControlMedico?;
    
    // Sección de la cámara
    static var estaControlMedicoActivo = false;
    // Se declara una lista de clase, para manejo de imágenes en memoria desde cualquier parte.
    static var listaFotosTomadas = [UIImage?]();
    
    static var estaDermatoscopiaActiva = false;
    static var estaDermatoscopiaGuardada = false;
    static var fotoPrincipalTemporalDermatoscopia: UIImage?;
    static var estaViendoImagenesDermatoscopia = false;

    // Lista de tomadas
    static var fotosPrincipalesDermatoscopia = [Int:UIImage?]();
    // Se toma el índice de la principal para llenar la matriz
    static var listaFotosDermatoscopias: [Int: [UIImage]] = [0 : []];
    // Se declara un índice para manejo de la matriz
    // El índice tiene que cambiar con la posición (tag del botón) en foto y añadir
    static var indiceDermatoscopiaActiva: Int?;
    
    
    // Varialbes Anexos (paso 5)
    static var estaAnexosActiva = false;
    static var listaFotosAnexos = [UIImage?]();
    
    // Se declara una lista para el manejo de las imágenes que han sido seleccionadas.
    static var listaFotosSeleccionadas = [UIImage?]();
    static var listaFotosSeleccionadasDermatoscopia = [Int: [UIImage?]]();
    static var listaFotosSeleccionadasAnexos = [UIImage?]();
    
    
    class func reiniciarVariables () {
        MemoriaRegistroConsulta.consultaMedica = nil;
        MemoriaRegistroConsulta.lesion = nil;
        MemoriaRegistroConsulta.controlMedico = nil;
        
        MemoriaRegistroConsulta.listaFotosTomadas = [];
        MemoriaRegistroConsulta.estaDermatoscopiaActiva = false;
        MemoriaRegistroConsulta.estaDermatoscopiaGuardada = false;
        MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia = nil;
        MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia = false;
        MemoriaRegistroConsulta.estaControlMedicoActivo = false;
        
        MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.removeAll();
        MemoriaRegistroConsulta.listaFotosDermatoscopias.removeAll();
        MemoriaRegistroConsulta.indiceDermatoscopiaActiva = nil;
        
        MemoriaRegistroConsulta.estaAnexosActiva = false;
        MemoriaRegistroConsulta.listaFotosAnexos = [];
        
        MemoriaRegistroConsulta.listaFotosSeleccionadas = [];
        MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia.removeAll();
        MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos = [];
    }
}
