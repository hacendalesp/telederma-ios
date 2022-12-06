//
//  Validacion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 26/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class Validacion: NSObject {
    
    /**
     Permite transformar estilos para las VIEW de los formulario que no cumplen las condiciones.
     - Parameter view: Corresponde al VIEW que se está evaluando.
     */
    class func pintarErrorCampoFormulario (view: UIView) {
        view.layer.borderColor = Constantes.BORDE_COLOR_ERROR;
        view.layer.borderWidth = Constantes.BORDE_GROSOR_ERROR;
        view.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
    }
    
    /**
     Permite transformar estilos para las VIEW de los formularios que cumplen las condiciones.
     - Parameter view: Corresponde al VIEW que se está evaluando.
     */
    class func pintarCorrectoCampoFormulario (view: UIView, color: CGColor?, borde: CGFloat?) {
        if (color == nil) {
            view.layer.borderColor = Constantes.BORDE_COLOR_CORRECTO;
        } else {
            view.layer.borderColor = color;
        }
        
        if (borde == nil) {
            view.layer.borderWidth = CGFloat(0.0);
        } else {
            view.layer.borderWidth = borde!;
        }
    }
    
    /**
     Permite validar si una cadena de texto está vacía o es nula.
     - Parameter texto: Corresponde a la cadena de texto a evaluar.
     - Returns: True si la cadena está vacía o False en caso contrario.
     */
    class func esCadenaVacia(texto: String?) -> Bool {
        var esCadenaVacia = true;
        if(texto != nil){
            let nuevoTexto = texto!.trimmingCharacters(in: .whitespacesAndNewlines);
            if(nuevoTexto != ""){
                esCadenaVacia = false;
            }
        }
        return esCadenaVacia;
    }
    
    /**
     Permite validar si un campo de texto es vacío.
     Si el campo es vacío la función colorea el borde de rojo.
     - Parameter view: Corresponde al campo de texto que se desea evaluar.
     - Returns: True si el campo es vacío y False si no está vacío.
     */
    class func esCampoTextoVacio(view: UITextField) -> Bool {
        if (self.esCadenaVacia(texto: view.text)) {
            self.pintarErrorCampoFormulario(view: view);
            return true;
        } else {
            self.pintarCorrectoCampoFormulario(view: view, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
            return false;
        }
    }
    
    /**
     Permite validar si existe al menos un campo de texto vacío en una lista de campos de texto.
     - Parameter textos: Corresponde a una lista de campos de texto.
     - Returns: True si existe al menos un campo de texto vacío, False si ningún campo está vacío.
     */
    class func sonCamposVacios (textos: [UITextField]) -> Bool {
        var algunTextoVacio = false;
        for texto in textos {
            if (self.esCampoTextoVacio(view: texto)) {
                algunTextoVacio = true;
            }
        }
        return algunTextoVacio;
    }
    
    /**
     Permite validar si una cadena de texto sólo contiene números.
     - Parameter texto: Corresponde a la cadena de texto a evaluar.
     - Returns: True si la cadena es numérica, False en caso contrario.
     */
    class func esCadenaNumerico (texto: String?) -> Bool {
        var esNumerico = false;
        if(!self.esCadenaVacia(texto: texto)) {
            if Int(texto!) != nil {
                esNumerico = true;
            }
        }
        return esNumerico;
    }
    
    /**
     Permite validar si un campo de texto contiene un valor numérico.
     - Parameter texto: Corresponde al campo de texto a evaluar.
     - Returns: True si el campo de texto contiene un valor númerico, False en caso contrario.
     */
    class func esCampoNumerico (texto: UITextField) -> Bool{
        var esNumerico = false;
        if (self.esCadenaNumerico(texto: texto.text)) {
            esNumerico = true;
            self.pintarCorrectoCampoFormulario(view: texto, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        } else {
            self.pintarErrorCampoFormulario(view: texto);
        }
        return esNumerico;
    }
    
    /**
     Permite validar si un conjunto de campos de texto tienen valores numéricos.
     - Parameter textos: Corresponde al conjunto de campos de texto a evaluar.
     - Returns: True si todos los campos son numéricos, False en caso contrario.
     */
    class func sonCamposNumericos (textos: [UITextField]) -> Bool{
        var todosSonNumericos = true;
        for campo in textos {
            if(!self.esCampoNumerico(texto: campo)){
                todosSonNumericos = false;
            }
        }
        return todosSonNumericos;
    }
    
    /**
     Permite validar si una cadena de texto corresponde a una dirección de correo electrónico válida.
     - Parameter texto: Corresponde a la cadena de texto a evaluar.
     - Returns: True si la cadena es válida, False en caso contrario.
     */
    class func esCadenaEmail(texto: String?) -> Bool {
        if texto == nil {
            return false;
        }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        let validarEamil = NSPredicate(format:"SELF MATCHES %@", regEx);
        let esEmail = validarEamil.evaluate(with: texto!);
        return esEmail;
    }
    
    /**
     Permite validar si el valor de un campo de texto es un email válido.
     - Parameter email: Corresponde al email que se desea evaluar.
     - Returns: True si es un email válido, False en caso contrario.
     */
    class func esCampoEmail(email: UITextField) -> Bool {
        let esEmail = self.esCadenaEmail(texto: email.text);
        if (esEmail) {
            self.pintarCorrectoCampoFormulario(view: email, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        } else {
            self.pintarErrorCampoFormulario(view: email);
        }
        return esEmail;
    }
    
    /**
     Permite validar si una cadena de texto cumple con el tamaño mínimo asígnado.
     - Parameter texto: Corresponde a la cadena de texto a evaluar.
     - Parameter min: Corresponde al tamaño mínimo de caracteres que debe cumplir la cadena a evaluar.
     - Returns: True si la cadena cumple con el tamaño mínimo, False si es menor.
     */
    class func minimoCaracteresValidos (texto: String?, min: Int) -> Bool {
        var minimoValido = false;
        if texto == nil {
            return false;
        }
        if(texto!.count >= min) {
            minimoValido = true;
        }
        return minimoValido;
    }
    
    /**
     Permite evaluar si el valor de un campo de texto cumple con el tamaño mínimo asignado.
     - Parameter campo: Corresponde al campo de texto a evaluar.
     - Parameter min: Corresponde al tamaño mínimo que debe cumplir el valor del campo.
     - Returns: True si el valor del campo es igual o mayor al tamaño mínimo, False en caso contrario.
     */
    class func esCampoCaracteresMinimo (campo: UITextField, min: Int) -> Bool {
        let esCampoCaracteresMinimo = self.minimoCaracteresValidos(texto: campo.text, min: min);
        if (esCampoCaracteresMinimo) {
            self.pintarCorrectoCampoFormulario(view: campo, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        } else {
            self.pintarErrorCampoFormulario(view: campo);
        }
        
        return esCampoCaracteresMinimo;
    }
    
    /**
     Permite validar si un conjunto de campos cumplen con los valores mínimos.
     - Parameter campos: Corresponde al conjunto de campos a evaluar.
     - Parameter min: Corresponde al valor mínimo de caracteres que deben cumplir los campos.
     - Returns: True si todos los campos cumplen con el valor mínimo, False en caso contrario.
     */
    class func sonCamposCaracteresMinimos (campos: [UITextField], min: Int) -> Bool {
        var cumplenCaracteresMinimos = true;
        for campo in campos {
            if (!self.esCampoCaracteresMinimo(campo: campo, min: min)) {
                cumplenCaracteresMinimos = false;
            }
        }
        return cumplenCaracteresMinimos;
    }
    
    
    /**
     Permite validar si una cadena de texto cumple con el tamaño máximo asígnado.
     - Parameter texto: Corresponde a la cadena de texto a evaluar.
     - Parameter max: Corresponde al tamaño máximo de caracteres que debe cumplir la cadena a evaluar.
     - Returns: True si la cadena cumple con el tamaño máximo, False si es mayor.
     */
    class func maximoCaracteresValidos (texto: String?, max: Int) -> Bool {
        var maximoValido = false;
        if texto == nil {
            return false;
        }
        if(texto!.count <= max) {
            maximoValido = true;
        }
        return maximoValido;
    }
    
    /**
     Permite evaluar si el valor de un campo de texto cumple con el tamaño mínimo asignado.
     - Parameter campo: Corresponde al campo de texto a evaluar.
     - Parameter max: Corresponde al tamaño máximo que debe cumplir el valor del campo.
     - Returns: True si el valor del campo es igual o menor al tamaño mínimo, False en caso contrario.
     */
    class func esCampoCaracteresMaximo (campo: UITextField, max: Int) -> Bool {
        let esCampoCaracteresMaximo = self.maximoCaracteresValidos(texto: campo.text, max: max);
        if (esCampoCaracteresMaximo) {
            self.pintarCorrectoCampoFormulario(view: campo, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        } else {
            self.pintarErrorCampoFormulario(view: campo);
        }
        
        return esCampoCaracteresMaximo;
    }
    
    /**
     Permite validar si un conjunto de campos cumplen con los valores máximos.
     - Parameter campos: Corresponde al conjunto de campos a evaluar.
     - Parameter max: Corresponde al valor máximo de caracteres que deben cumplir los campos.
     - Returns: True si todos los campos cumplen con el valor máimo, False en caso contrario.
     */
    class func sonCamposCaracteresMaximos (campos: [UITextField], max: Int) -> Bool {
        var cumplenCaracteresMaximos = true;
        for campo in campos {
            if (!self.esCampoCaracteresMaximo(campo: campo, max: max)) {
                cumplenCaracteresMaximos = false;
            }
        }
        return cumplenCaracteresMaximos;
    }
    
    /**
     Permite comparar un conjunto de cadenas de texto, para saber si todas son iguales.
     - Parameter cadenas: Corresponde al conjunto de cadenas de texto que se desean comparar.
     - Returns: True si todas las cadenas son iguales, False en caso contrario.
     */
    class func sonCadenasIguales (cadenas: [String?]) -> Bool {
        var sonIguales = true;
        var contadorApariciones = 0;
        let tamanio = cadenas.count;
        let cadena = cadenas[0];
        for item in cadenas {
            if (cadena == item) {
                contadorApariciones += 1;
            }
        }
        if (contadorApariciones != tamanio) {
            sonIguales = false;
        }
        return sonIguales;
    }
    
    /**
     Permite comparar si un conjunto de campos de texto tienen los mismos valores.
     - Parameter campos: Corresponde al conjunto de campos a evaluar.
     - Returns: True si los valores de los campos son iguales, False en caso contrario.
     */
    class func sonCamposTextoIguales (campos: [UITextField]) -> Bool {
        if (campos.count == 0) {
            return false;
        }
        var cadenas = [String?]();
        for item in campos {
            let texto = item.text;
            cadenas.append(texto);
        }
        let sonCamposIguales = self.sonCadenasIguales(cadenas: cadenas);
        if (!sonCamposIguales) {
            for campo in campos {
                self.pintarErrorCampoFormulario(view: campo);
            }
        }
        return sonCamposIguales;
    }
    
}
