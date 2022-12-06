//
//  RegistroPacienteViewController4Foto.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 1/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class RegistroPacienteViewController4Foto: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var imgDetalle: UIImageView!
    @IBOutlet weak var btnEliminarFoto: UIButton!
    @IBOutlet weak var btnAgregarDermatoscopia: UIButton!
    @IBOutlet weak var btnVerDermatoscopicas: UIButton!
    
    // Altos de botones para esconder
    
    // Se declara una variable que permite conocer la posición de la foto en la lista.
    var posicion: Int?;    
    
    // Se declaran variables para el paso de imágenes.
    private var contadorImagenes = 0;
    // Se toma la lista como la original, y en inits se invierte.
    // Para que no se pierda la referencia de la foto en la lista.
    private var imagenes = [UIImage?]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    
    private func inits () {
        // Ajustando estilos.
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnVerDermatoscopicas.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        // Se valida si no está activa dermatoscopía ni anexos
        if (!MemoriaRegistroConsulta.estaDermatoscopiaActiva && !MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia && !MemoriaRegistroConsulta.estaAnexosActiva) {
            // Toma las fotos básicas del paso 1
            self.imagenes = MemoriaRegistroConsulta.listaFotosTomadas;
        } else {
            // Si estamos viendo las imágenes seleccionadas para dermatoscopia
            if(MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia) {
                self.imagenes = MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[self.posicion!] ?? [];
            } else {
                // Si está activa anexos paso 5
                if(MemoriaRegistroConsulta.estaAnexosActiva) {
                    self.imagenes = MemoriaRegistroConsulta.listaFotosAnexos;
                } else {
                    // De lo contrario corresponde a imágenes dermatoscopía
                    self.imagenes = MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]!;
                }
                
            }
        }
        
        // Ocultar botones aplica para detalle dermatoscopica y ver imágenes dermatoscópicas
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva || MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia || MemoriaRegistroConsulta.estaAnexosActiva) {
            self.btnEliminarFoto.isHidden = true;
            self.btnAgregarDermatoscopia.isHidden = true;
        }
        
        // Para ver las imágenes guardadas en dermatoscopía los cálculos cambian.
        // Se debe considerar la lista de imágenes guardadas
        if(MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia) {
            self.contadorImagenes = MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[self.posicion!]!.count;
            self.imgDetalle.image = self.imagenes[self.contadorImagenes-1];
        }else {
            self.contadorImagenes = self.posicion!;
            self.imgDetalle.image = self.imagenes[self.contadorImagenes];
        }
        
        
        // Se invierte la lista para tener referencia de la selección del usuario.
        self.imagenes.reverse();
        // Se obtiene el índice que la imagen seleccionada tiene en la lista original, pero invertida.
        if let imagenIndex = self.imagenes.firstIndex(of: self.imgDetalle.image) {
            self.contadorImagenes = imagenIndex;
        }
        
        // Validar botón ver imágenes dermatoscópicas
        self.validarVerImagenesDermatoscopicas();
        
        // Se agregan el manejo de eventos para el controlador.
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)));
        swipeLeft.direction = .left;
        self.view.addGestureRecognizer(swipeLeft);
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)));
        swipeRight.direction = .right;
        self.view.addGestureRecognizer(swipeRight);
    }
    
    
    private func reiniciarInformacion () {
        MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia = false;
        self.posicion = nil;
        self.contadorImagenes = 0;
        self.imagenes = [];
        self.dismiss(animated: true, completion: nil);
    }
    
    private func anterior(){
        if(self.contadorImagenes > 0) {
            self.contadorImagenes -= 1;
            self.imgDetalle.image = self.imagenes[self.contadorImagenes]!;
            self.posicion! += 1;
        }
    }
    
    private func siguiente(){
        if(self.contadorImagenes < (self.imagenes.count - 1)) {
            self.contadorImagenes += 1;
            self.imgDetalle.image = self.imagenes[self.contadorImagenes]!;
            self.posicion! -= 1;
        }
    }
    
    private func validarVerImagenesDermatoscopicas () {
        // Se valida si la imagen corresponde a la imagen principal dermatoscopía y que el estado sea guardada
        if(MemoriaRegistroConsulta.estaDermatoscopiaGuardada) {
            if let imagenPrincipal = MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[self.posicion!] {
                if(self.imgDetalle.image!.isEqual(imagenPrincipal)) {
                    // Las imágenes dermatoscopia están guardadas y la imagen actual corresponde a la imagen seleccionada como principal
                    self.btnVerDermatoscopicas.isHidden = false;
                } else {
                    self.btnVerDermatoscopicas.isHidden = true;
                }
            } else {
                self.btnVerDermatoscopicas.isHidden = true;
            }
        } else {
            self.btnVerDermatoscopicas.isHidden = true;
        }
    }
    
    /**
     Permite pasar entre imágenes a través de gestos sobre la pantalla.
     */
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            self.anterior();
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            self.siguiente();
            
        }
        // Se valida al inicio y cada vez que cambia la imagen.
        self.validarVerImagenesDermatoscopicas();
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        self.reiniciarInformacion();
    }
    @IBAction func accionEliminarFoto(_ sender: UIButton) {
        // Se usa la función para eliminar una foto y organizar índices y valores.
        Funcionales.eliminarFotoYActualizar(posicion: self.posicion!);
        
        self.reiniciarInformacion();
    }
    @IBAction func accionAgregarDermatoscopia(_ sender: UIButton) {
        
        // Se guarda la imagen correspondiente.
        MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia = MemoriaRegistroConsulta.listaFotosTomadas[self.posicion!];
        // Se activa modo imágenes dermatoscopia
        MemoriaRegistroConsulta.estaDermatoscopiaActiva = true;
        // Se activa el índice para la matriz dermatoscopía
        MemoriaRegistroConsulta.indiceDermatoscopiaActiva = self.posicion!;
        // Se inicializa el view controller de la cámara.
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionVerDermatoscopicas(_ sender: UIButton) {
        // Activa modo viendo imágenes dermatoscopia.
        MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia = true;
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_foto") as! RegistroPacienteViewController4Foto;
        // Como la lista se encuentra invertida, se debe tomar el último elemento, para que el usuario pueda verlas en orden desde la última hasta la primera tomada.
        vc.posicion = self.posicion!;
        self.present(vc, animated: true, completion: nil);
    }
    
}
