//
//  RegistroPacienteViewController4Anadir.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 2/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class RegistroPacienteViewController4Anadir: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var lblPaso: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var coleccionFotos: UICollectionView!
    @IBOutlet weak var btnAnadirFoto: UIButton!
    @IBOutlet weak var imgFooter: UIImageView!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var altoPaso: NSLayoutConstraint!
    @IBOutlet weak var altoTitulo: NSLayoutConstraint!
    @IBOutlet weak var btnRegresar: UIBarButtonItem!
    @IBOutlet weak var altoBtnAnadirFoto: NSLayoutConstraint!
    
    // Se declara una lista que contendrá las imágenes seleccionadas temporales al guardar en modo dermatoscopia. Al guardar se asignarán a la lista definitiva en RegistroCamara.
    var listaSeleccionadasTemporal = [UIImage?]();
    // Se declara una lista que contendrá las imágenes tomadas disponibles para ser seleccionadas.
    var listaImagenesDisponibles = [UIImage?]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.coleccionFotos.reloadData();
    }
    
    private func inits () {
        // Ajustando estilos.
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        
        // Para utilizar el mismo controlador, se valida si está activa o no, dermatoscopia.
        if (!MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        } else {
            self.header.standardAppearance.backgroundColor = .systemYellow;
            self.header.topItem?.title = "Imágenes dermatoscopía";
            self.btnAnadirFoto.setBackgroundImage(UIImage(named: "anadir_img_dermatoscopia"), for: .normal);
            self.lblTitulo.isHidden = true;
            self.lblPaso.isHidden = true;
            self.altoTitulo.constant = 0;
            self.altoPaso.constant = 0;
            self.btnSiguiente.setTitle("Guardar", for: .normal);
        }
        
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnAnadirFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnAnadirFoto.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se oculta añadir imágnes para Anexos
        if(MemoriaRegistroConsulta.estaAnexosActiva) {
            self.btnAnadirFoto.isHidden = true;
            self.btnRegresar.isEnabled = false;
            self.altoBtnAnadirFoto.constant = 0;
        }
        
        // Se valida si ya se ha diligenciado todo el proceso y está activo terminación
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.btnSiguiente.setTitle(Mensajes.TEXTO_BOTON_RESUMEN, for: .normal);
        }
        
        // Si está activo control médico se oculta el titulo del paso 4
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            self.lblTituloHeader.isHidden = true;
        }
        
        self.coleccionFotos.delegate = self;
        self.coleccionFotos.dataSource = self;
        
    }
    
    /**
     Permite devolver la imagen con o sin el símbolo de chequeo.
     */
    private func obtenerImagenChecked (needChecked: Bool) -> UIImage {
        var image: UIImage;
        if (needChecked) {
            image = UIImage(named: Constantes.BOTON_CHECK_ON_AZUL)!;
        } else {
            image = UIImage(systemName: Constantes.BOTON_CHECK_OFF)!;
        }
        
        return image;
    }
    
    /**
     Permite guardar las imágenes definitivas que han sido seleccionadas, al momento de continuar con el paso 5.
     */
    private func guardarImagenesSeleccionadas (posicion: Int?) {
        
        var inicio = 0;
        if(posicion != nil) {
            inicio = posicion!;
        }
        for index in inicio..<MemoriaRegistroConsulta.listaFotosTomadas.count {
            
            // Se valida que el index debe ser menor a la cantidad de fotos tomadas.
            if(index < MemoriaRegistroConsulta.listaFotosTomadas.count) {
                // Si la foto tomada no está dentro de las seleccionadas...
                if(!MemoriaRegistroConsulta.listaFotosSeleccionadas.contains(MemoriaRegistroConsulta.listaFotosTomadas[index])) {
                    // Se elimina la foto
                    Funcionales.eliminarFotoYActualizar(posicion: index);
                    // Se valida si los tamaños son iguales
                    if(MemoriaRegistroConsulta.listaFotosTomadas.count != MemoriaRegistroConsulta.listaFotosSeleccionadas.count) {
                        // Se vuelve a llamar por los cambios que se realizaron en los índices.
                        self.guardarImagenesSeleccionadas(posicion: index);
                    } else {
                        // Se rompe el ciclo
                        break;
                    }
                } else {
                    if(MemoriaRegistroConsulta.listaFotosTomadas.count == MemoriaRegistroConsulta.listaFotosSeleccionadas.count) {
                        // Se rompe el ciclo
                        break;
                    }
                }
            } else {
                // Se rompe el ciclo
                break;
            }
        }
    }
    
    /**
     Permite añadir o remover una imagen de la lista de seleccionadas.
     */
    @objc func seleccionarFoto (_ sender: UIButton) {
        var estaSeleccionada = false;
        
        if let index = self.listaSeleccionadasTemporal.firstIndex(of: self.listaImagenesDisponibles[sender.tag]) {
            self.listaSeleccionadasTemporal.remove(at: index);
            estaSeleccionada = false;
        } else {
            self.listaSeleccionadasTemporal.append(self.listaImagenesDisponibles[sender.tag]);
            estaSeleccionada = true;
        }
        
        sender.setBackgroundImage(self.obtenerImagenChecked(needChecked: estaSeleccionada), for: .normal);
    }
    
    @objc func verFoto (_ sender: UIButton) {
        let posicion = sender.tag;
        let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_foto") as! RegistroPacienteViewController4Foto;
        // vc.imagen = RegistroPacienteViewController4_Camara.listaFotosTomadas[posicion];
        vc.posicion = posicion;
        self.present(vc, animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionAnadir(_ sender: UIButton) {
        // Cuando se va al paso 5 y se regresa, el botón añadir no puede usar dismiss.
        if(!MemoriaRegistroConsulta.estaDermatoscopiaActiva && MemoriaRegistroConsulta.listaFotosSeleccionadas.count > 0) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
            self.present(vc, animated: true, completion: nil);
        } else {
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
        var cantidadMinima = 0;
        var cantidadMaxima = 0;
        
        if(MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_DERMATOSCOPIA_ANADIR;
            cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_DERMATOSCOPIA_ANADIR;
        } else {
            // Se valida si está activa Anexos paso 5
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_ANEXOS_ANADIR;
                cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_ANEXOS_ANADIR;
            } else {
                // De lo contrario corresponde a las imágenes base paso 1
                cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_TOMADAS_ANADIR;
                cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_TOMADAS_ANADIR;
            }
        }
        
        if(self.listaSeleccionadasTemporal.count < cantidadMinima){
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.FOTOS_CANTIDAD_MINIMA)\(cantidadMinima)");
        } else {
            if(self.listaSeleccionadasTemporal.count > cantidadMaxima) {
                Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.FOTOS_CANTIDAD_MAXIMA)\(cantidadMaxima)");
            } else {
                // Se valida si está dermatoscopia activa
                if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
                    // Regresa a cámara normal mostrando seleccionadas (no dermatoscopía)
                    // Se desactiva el estado dermatoscopía
                    // Se pasa la información temporal a la lista definitiva
                    // Se guarda la imagen correspondiente.
                    MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!] = MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia;
                    MemoriaRegistroConsulta.estaDermatoscopiaActiva = false;
                    MemoriaRegistroConsulta.estaDermatoscopiaGuardada = true;
                    MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia = nil;
                    // Las fotos tomadas dermatoscopia se eliminan.
                    MemoriaRegistroConsulta.listaFotosDermatoscopias = [:];
                    MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!] = self.listaSeleccionadasTemporal;
                    MemoriaRegistroConsulta.indiceDermatoscopiaActiva = nil;
                    // Si está activa la consulta lista para enviar se dirige al último paso del proceso
                    if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
                        let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                        self.present(vc, animated: true, completion: nil);
                        
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
                        self.present(vc, animated: true, completion: nil);
                    }
                } else {
                    // Se valida si está Anexos activa
                    if(MemoriaRegistroConsulta.estaAnexosActiva){
                        // Se muestra confirmación cuando no ha seleccionado fotos.
                        if(self.listaSeleccionadasTemporal.count == 0) {
                            let accionContinuar = UIAlertAction(title: "Continuar", style: .default, handler: {
                                (UIAlertAction) in
                                
                                MemoriaRegistroConsulta.estaAnexosActiva = false;
                                
                                // Si está activa la consulta lista para enviar se dirige al último paso del proceso
                                if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                                    self.present(vc, animated: true, completion: nil);
                                    
                                } else {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_5") as! RegistroPacienteViewController5;
                                    self.present(vc, animated: true, completion: nil);
                                }
                            });
                            let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil);
                            let alerta = UIAlertController(title: "Confirmación", message: Mensajes.CONFIRMACION_ANEXOS_VACIO, preferredStyle: .alert);
                            alerta.addAction(accionContinuar);
                            alerta.addAction(accionCancelar);
                            self.present(alerta, animated: true, completion: nil);
                        } else {
                            
                            // Si hay selección se asignan a la lista estática y sigue a paso 5.
                            MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos = self.listaSeleccionadasTemporal;
                            MemoriaRegistroConsulta.estaAnexosActiva = false;
                            
                            // Si está activa la consulta lista para enviar se dirige al último paso del proceso
                            if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
                                let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                                self.present(vc, animated: true, completion: nil);
                                
                            } else {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_5") as! RegistroPacienteViewController5;
                                self.present(vc, animated: true, completion: nil);
                            }
                        }
                    } else {
                        MemoriaRegistroConsulta.listaFotosSeleccionadas = self.listaSeleccionadasTemporal;
                        // Se valida si está activo control médico
                        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
                            RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar = true;
                            let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                            self.present(vc, animated: true, completion: nil);
                        } else {
                            // Paso 5
                            // Se guardan las imágenes definitivas.
                            self.guardarImagenesSeleccionadas(posicion: nil);
                            // Si está activa la consulta lista para enviar se dirige al último paso del proceso
                            if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
                                let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                                self.present(vc, animated: true, completion: nil);
                                
                            } else {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_5") as! RegistroPacienteViewController5;
                                self.present(vc, animated: true, completion: nil);
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        // Se valida si está activa Dermatoscopia
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
            self.present(vc, animated: true, completion: nil);
        } else {
            // Se valida si está activo control médico
            if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
                // Se eliminan las imágnes de anexos y se activa modo anexos.
                MemoriaRegistroConsulta.listaFotosAnexos = [];
                MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos = [];
                self.dismiss(animated: true, completion: nil);
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_control_medico") as! ControlMedicoViewController;
                //self.present(vc, animated: true, completion: nil);
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_3") as! RegistroPacienteViewController3;
                self.present(vc, animated: true, completion: nil);
            }
        }
    }
}

extension RegistroPacienteViewController4Anadir: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Se valida si está activa dermatoscopía
        if(MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            return MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]?.count ?? 0;
        } else {
            // Se valida si está activa Anexos paso 5
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                return MemoriaRegistroConsulta.listaFotosAnexos.count;
            } else {
                // De lo contrario corresponde a fotos básicas paso 1
                return MemoriaRegistroConsulta.listaFotosTomadas.count;
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Se valida si está activa la funcionalidad de imágenes dermatoscopia.
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            self.listaImagenesDisponibles = MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]!;
            
        } else {
            // Se valida si está activa Anexos paso 5
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                self.listaImagenesDisponibles = MemoriaRegistroConsulta.listaFotosAnexos;
            } else {
                // De lo contrario corresponde a fotos básicas paso 1
                self.listaImagenesDisponibles = MemoriaRegistroConsulta.listaFotosTomadas;
            }
        }
        let indiceEnFotosTomadas = indexPath.row;
        // Se crea el tag con su respectivo valor según la lista activa.
        let tag = self.listaImagenesDisponibles.count - indiceEnFotosTomadas - 1;
        // Se crea una lista inversa para mostrar las imágenes disponibles.
        let listaInversaImagenesDisponibles: [UIImage?] = self.listaImagenesDisponibles.reversed();
        
        let imagen = listaInversaImagenesDisponibles[indiceEnFotosTomadas];
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda_foto", for: indexPath) as! FotosCollectionViewCell;
        // let imagenConRotacion = Funcionales.rotarImagen(oldImage: imagen!, grados: 90);
        celda.btnFoto.setBackgroundImage(imagen, for: .normal);
        celda.btnFoto.tag = tag;
        celda.btnFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        // celda.btnFoto.setTitle(tag.description, for: .normal);
        celda.btnSeleccion.tag = tag;
        celda.btnSeleccion.addTarget(self, action: #selector(self.seleccionarFoto(_:)), for: .touchUpInside);
        celda.btnFoto.addTarget(self, action: #selector(self.verFoto(_:)), for: .touchUpInside);
        
        if (self.listaSeleccionadasTemporal.contains(imagen)) {
            celda.btnSeleccion.setBackgroundImage(UIImage(named: Constantes.BOTON_CHECK_ON_AZUL), for: .normal);
        } else {
            celda.btnSeleccion.setBackgroundImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
        }
        
        // Se valida que no esté activa dermatoscopia y que sí esté guardada para agregar marca.
        if(!MemoriaRegistroConsulta.estaDermatoscopiaActiva && MemoriaRegistroConsulta.estaDermatoscopiaGuardada && !MemoriaRegistroConsulta.estaAnexosActiva) {
            
            // Se valida si existen fotos seleccionadas para dermatoscopia
            if(MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.count > 0) {
                
                if let imagenPrincipal = MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[tag] {
                    
                    // Si la imagen coincide con la principal
                    if (imagen!.isEqual(imagenPrincipal)) {
                        celda.lblMarcaDermatoscopia.text = "\(Mensajes.TEXTO_ETIQUETA_DERMATOSCOPIA) - \(MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[tag]!.count)";
                        celda.lblMarcaDermatoscopia.isHidden = false;
                    } else {
                        celda.lblMarcaDermatoscopia.isHidden = true;
                    }
                } else {
                    celda.lblMarcaDermatoscopia.isHidden = true;
                }
            } else {
                celda.lblMarcaDermatoscopia.isHidden = true;
            }
            
        } else {
            celda.lblMarcaDermatoscopia.isHidden = true;
        }
        
        return celda;
    }
    
    
}
