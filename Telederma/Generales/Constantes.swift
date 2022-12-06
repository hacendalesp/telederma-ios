//
//  Constantes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class Constantes: NSObject {
    
    // Dirección electrónica que aplica para todas las peticiones hacia la API.
    // static let URL_BASE = "http://167.172.242.158/";
    static let URL_BASE = "https://telederma.gov.co:443/";
    
    static let NOMBRE_APP = "Telederma";
    static let BORDE_BOTON_REDONDEADO = CGFloat(5.0);
    static let BORDE_GROSOR = CGFloat(0.5);
    static let BORDE_GROSOR_ERROR = CGFloat(2.0);
    static let BORDE_GROSOR_CORRECTO = CGFloat(1.0);
    static let BORDE_COLOR = UIColor.lightGray.cgColor;
    static let BORDE_COLOR_ERROR = UIColor.red.cgColor;
    static let BORDE_COLOR_CORRECTO = UIColor.systemGreen.cgColor;
    static let COLOR_WARNING = UIColor(red: 0.933, green: 0.741, blue: 0.137, alpha: 1.00);
    static let COLOR_BOTON_PRIMARIO = UIColor(red: 0, green: 0.914, blue: 0.999, alpha: 1.00);
    static let COLOR_BOTON_SECUNDARIO = UIColor(red: 0, green: 0.416, blue: 0.678, alpha: 1.00);
    static let COLOR_FONDO_AZUL_CLARO = UIColor.systemBlue;
    static let NOMBRE_BASE_DATOS = "telederma.sqlite3";
    static let UDID = UIDevice.current.identifierForVendor!.uuidString;
    static let USER_DEFAULTS = UserDefaults.standard;
    
    static let BOTON_CHECK_ON_AZUL = "seleccionado";
    static let BOTON_CHECK_ON = "checkmark.rectangle.fill";
    static let BOTON_CHECK_OFF = "square";
    
    static let BOTON_CHECK_CIRCULO_ON = "largecircle.fill.circle";
    static let BOTON_CHECK_CIRCULO_OFF = "circle";
    
    static let BOTON_DINAMICO_ANCHO = 398;
    static let BOTON_DINAMICO_ALTO = 34;
    static let BOTON_DINAMICO_X = 8;
    static let BOTON_DINAMICO_SIGUIENTE_BOTON_Y = 6;
    static let BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO = CGFloat(20);
    static let BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN = CGFloat(0);
    static let VISTA_DINAMICA_ALTO = CGFloat(40);
    
    // Imágenes
    static let CANTIDAD_MAXIMA_IMAGENES_TOMADAS = 10;
    static let CANTIDAD_MINIMA_IMAGENES_TOMADAS = 2;
    static let CANTIDAD_MAXIMA_IMAGENES_TOMADAS_ANADIR = 8;
    static let CANTIDAD_MINIMA_IMAGENES_TOMADAS_ANADIR = 2;
    static let CANTIDAD_MAXIMA_IMAGENES_DERMATOSCOPIA = 6;
    static let CANTIDAD_MINIMA_IMAGENES_DERMATOSCOPIA = 2;
    static let CANTIDAD_MAXIMA_IMAGENES_DERMATOSCOPIA_ANADIR = 2;
    static let CANTIDAD_MINIMA_IMAGENES_DERMATOSCOPIA_ANADIR = 2;
    static let CANTIDAD_MAXIMA_IMAGENES_ANEXOS = 10;
    static let CANTIDAD_MINIMA_IMAGENES_ANEXOS = 0;
    static let CANTIDAD_MAXIMA_IMAGENES_ANEXOS_ANADIR = 10;
    static let CANTIDAD_MINIMA_IMAGENES_ANEXOS_ANADIR = 0;
    
    // User Defaults
    static let SETTINGS_ID = "user_id";
    static let SETTINGS_LOGIN = "logged_in";
    static let SETTINGS_ACCESS_TOKEN = "access_token";
    static let SETTINGS_EMAIL = "email";
    static let SETTINGS_NOMBRE = "nombre";
    static let SETTINGS_DOCUMENTO = "documento";
    
    // Diccionario de campos de formularios según respuesta servidor
    static let DICCIONARIO_CAMPOS = [
        "name": "Nombre(s)",
        "surnames": "Apellido(s)",
        "email": "Correo",
        "number_document": "Número de Documento",
        "phone": "Teléfono",
        "professional_card": "Tarjeta Profesional",
        "type_professional": "Tipo de Profesional",
        "password": "Contraseña",
        "password_confirmation": "Confirmar Contraseña",
        "terms_and_conditions": "Términos y Condiciones",
        "photo": "Foto",
        "image_digital": "Imagen Digital",
        "digital_signature": "Firma Digital",
        "current_password": "Contraseña Actual"
    ];
    
    // Descarga de imágenes
    static let GRUPO_USUARIO = "USER_";
    // GRUPO DOCUMENTO_USUARIO_LOGUEADO NOMBRE_IMAGEN EXTENSION
    // "\(Constantes.GRUPO_USUARIO)\(self.usuarioLogueado!.number_document!)_photo.png"
    static let GRUPO_CONSULTA = "CONSULTA_";
    // GRUPO IDImagen IDImagenPadre IDLesion IDControl/Consulta
    // "\(Constantes.GRUPO_LESION)\(imagen.id!.description)_\(imagen.image_injury_id ?? 0)_\(imagen.injury_id!)_\(consultaControlTexto ?? "").png";
    static let GRUPO_CONTROL = "CONTROL_";
    static let GRUPO_SISTEMA = "SYS_";
    static let GRUPO_MESA_AYUDA = "HELPDESK_";
    static let GRUPO_LESION = "LESION_";
    static let GRUPO_DERMATOSCOPIA = "DERMATOSCOPIA_";
    static let GRUPO_ANEXO = "ANEXO_";
    static let GRUPO_MIPRES = "MIPRES_";
    // GRUPO IDImagen IDControl/Consulta
    // "\(Constantes.GRUPO_ANEXO)\(imagen.id!.description)_\(consultaControlTexto ?? "").png";
    
    // Estados helpdesk
    static let ESTADO_HELPDESK_TEXTO = [
        1: "Pendiente",
        3: "Resuelto"
    ];
    
    static let ESTADO_HELPDESK_IMAGEN = [
        1: "enviado",
        3: "revisado"
    ];
    
    // Estados consulta
    static let ESTADO_CONSULTA_TEXTO = [
        -1: "En proceso",
        0: "Sin enviar",
        1: "Resuelto",
        2: "Requerimiento",
        3: "Pendiente",
        4: "Archivado",
        6: "Sin créditos",
        7: "Remisión",
        8: "Evaluado"
    ];
    
    static let ESTADO_CONSULTA_IMAGEN = [
        -1: "en_proceso",
        0: "sin_enviar",
        1: "revisado",
        2: "warning",
        3: "enviado",
        4: "desarchivar", // está archivado
        6: "sin_creditos",
        7: "remision",
        8: "evaluacion"
    ];
    
}
