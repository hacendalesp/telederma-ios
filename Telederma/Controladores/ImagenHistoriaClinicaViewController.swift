//
//  ImagenHistoriaClinicaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 21/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class ImagenHistoriaClinicaViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblCantidadImagenes: UILabel!
    @IBOutlet weak var imgPrincipal: UIImageView!
    @IBOutlet weak var btnImagenesDermatoscopicas: UIButton!
    @IBOutlet weak var lblComentarios: UILabel!
    
    // Variables para el manejo de la informació
    private var consulta: ConsultaMedica!;
    private var contadorImagenes = 0;
    var imagenPrincipal: UIImage?;
    // El índice corresponde al id del padre (imagenLesion ID).
    var listaImagenesPadre = [Int: UIImage]();
    // El indice corresponde al id del padre (imagenLesion ID).
    var listaImagenesHijas = [Int: [Int: UIImage]]();
    var posicion:Int = 0;
    var orden = [Int]();
    
    // Imagen por defecto
    let imagenCargando = UIImage(named: "cargando");
    
    // Comentarios respuesta especialista
    var comentariosRespuesta: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnImagenesDermatoscopicas.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        // Se agregan el manejo de eventos para el controlador.
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)));
        swipeLeft.direction = .left;
        self.view.addGestureRecognizer(swipeLeft);
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)));
        swipeRight.direction = .right;
        self.view.addGestureRecognizer(swipeRight);
        
        self.btnImagenesDermatoscopicas.isHidden = true;
        self.lblComentarios.isHidden = true;
        
        if (self.comentariosRespuesta != nil) {
            self.lblComentarios.text = self.comentariosRespuesta;
            self.lblComentarios.isHidden = false;
        }
        
        self.imgPrincipal.image = self.imagenPrincipal;
        
        self.cargarImagenes();
    }
    
    // Permite cargar las imagenes asociadas a la consulta.
    private func cargarImagenes () {
        if let indice = self.listaImagenesPadre.first(where: {$0.value == self.imagenPrincipal}) {
            if let pos = self.orden.firstIndex(of: indice.key) {
                // Posición en el arreglo de orden.
                self.posicion = pos;
            }
        }
        self.contadorImagenes = self.listaImagenesPadre.count;
        self.validarVerDermatoscopia();
        self.cambiarNumeracion();
    }
    
    private func cambiarNumeracion () {
        self.lblCantidadImagenes.text = "\(self.posicion + 1)/\(self.contadorImagenes)";
    }
    
    private func validarVerDermatoscopia () {
        if (self.listaImagenesHijas.count > 0) {
            let imagenPrincipal = self.listaImagenesPadre[ self.orden[self.posicion]];
            // Identificar la imagen actual como padre.
            if let indice = self.listaImagenesPadre.first(where: {$0.value == imagenPrincipal}) {
                let hijas = self.listaImagenesHijas.filter({$0.key == indice.key});
                if (hijas.count > 0) {
                    self.btnImagenesDermatoscopicas.isHidden = false;
                } else {
                    self.btnImagenesDermatoscopicas.isHidden = true;
                }
            } else {
                self.btnImagenesDermatoscopicas.isHidden = true;
            }
        }else {
            self.btnImagenesDermatoscopicas.isHidden = true;
        }
    }
    
    private func anterior(){
        self.posicion -= 1;
        if (self.posicion > -1) {
            let prev = self.listaImagenesPadre[ self.orden[self.posicion]];
            self.imgPrincipal.image = prev;
            self.imgPrincipal.contentMode = .scaleToFill;
            self.validarVerDermatoscopia();
            self.cambiarNumeracion();
        } else {
            self.posicion = 0;
        }
    }
    
    private func siguiente(){
        self.posicion += 1;
        if (self.posicion < self.contadorImagenes) {
            let next = self.listaImagenesPadre[ self.orden[self.posicion]];
            self.imgPrincipal.image = next;
            self.imgPrincipal.contentMode = .scaleToFill;
            self.validarVerDermatoscopia();
            self.cambiarNumeracion();
        } else {
            self.posicion = self.contadorImagenes - 1;
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
        //self.validarVerImagenesDermatoscopicas();
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
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func accionVerDermatoscopicas(_ sender: UIButton) {
        if (self.listaImagenesHijas.count > 0) {
            let imagenPrincipal = self.listaImagenesPadre[ self.orden[self.posicion]];
            // Identificar la imagen actual como padre.
            if let indice = self.listaImagenesPadre.first(where: {$0.value == imagenPrincipal}) {
                let hijas = self.listaImagenesHijas.filter({$0.key == indice.key});
                if (hijas.count > 0) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_imagen_historia_clinica") as! ImagenHistoriaClinicaViewController;
                    vc.imagenPrincipal = hijas[indice.key]![(MemoriaHistoriaClinica.ordenHija[indice.key]?.first)!];
                    vc.listaImagenesPadre = hijas[indice.key]!;
                    vc.listaImagenesHijas = [:];
                    vc.orden = MemoriaHistoriaClinica.ordenHija[indice.key]!;
                    self.present(vc, animated: true, completion: nil);
                }
            }
        }
    }
    
}
