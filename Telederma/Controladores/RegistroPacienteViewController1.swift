//
//  RegistroPacienteViewController1.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SearchTextField

class RegistroPacienteViewController1: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var btnNacimiento: UIButton!
    @IBOutlet weak var btnUnidadMedida: UIButton!
    @IBOutlet weak var btnTipoIdentificacion: UIButton!
    @IBOutlet weak var radioSexo: UISegmentedControl!
    @IBOutlet weak var btnEstadoCivil: UIButton!
    @IBOutlet weak var btnDepartamento: UIButton!
    @IBOutlet weak var btnMunicipio: UIButton!
    @IBOutlet weak var radioResidencia: UISegmentedControl!
    @IBOutlet weak var btnTipoUsuario: UIButton!
    @IBOutlet weak var btnCausaExterna: UIButton!
    @IBOutlet weak var btnCondicion: UIButton!
    @IBOutlet weak var imgFooter: UIImageView!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var switchAcompaniante: UISwitch!
    @IBOutlet weak var switchResponsable: UISwitch!
    @IBOutlet weak var switchConsentimiento: UISwitch!
    
    @IBOutlet weak var txtPrimerNombre: UITextField!
    @IBOutlet weak var txtSegundoNombre: UITextField!
    @IBOutlet weak var txtPrimerApellido: UITextField!
    @IBOutlet weak var txtSegundoApellido: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtNumeroIdentificacion: UITextField!
    @IBOutlet weak var txtOcupacion: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDireccionDomicilio: UITextField!
    @IBOutlet weak var txtNombreAcompaniante: UITextField!
    @IBOutlet weak var txtCelularAcompaniante: UITextField!
    @IBOutlet weak var txtNombreResponsable: UITextField!
    @IBOutlet weak var txtCelularResponsable: UITextField!
    @IBOutlet weak var txtParentescoResponsable: UITextField!
    @IBOutlet weak var txtAsegurador: SearchTextField!
    @IBOutlet weak var txtNumeroAutorizacion: UITextField!
    @IBOutlet weak var txtInpec: UITextField!
    
    // Secciones para que se ocultan o muestran
    @IBOutlet weak var vistaAcompaniante: UIView!
    @IBOutlet weak var vistaResponsable: UIView!
    @IBOutlet weak var vistaCondicion: UIView!
    @IBOutlet weak var vistaInpec: UIView!
    @IBOutlet weak var vistaIdentificacion: UIView!
    @IBOutlet weak var vistaTerminosCondiciones: UIView!
    
    // Altos de las secciones.
    @IBOutlet weak var altoAcompaniante: NSLayoutConstraint!
    @IBOutlet weak var altoResponsable: NSLayoutConstraint!
    @IBOutlet weak var altoCondicion: NSLayoutConstraint!
    @IBOutlet weak var altoInpec: NSLayoutConstraint!
    @IBOutlet weak var altoIdentificacion: NSLayoutConstraint!
    @IBOutlet weak var altoTerminosCondiciones: NSLayoutConstraint!
    
    // Se referencia ScrollView para ubicar al usuario en los campos
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Elementos de información de sólo lectura.
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblConsentimiento: UILabel!
    @IBOutlet weak var lblTipoIdentificacion: UILabel!
    @IBOutlet weak var lblNumeroIdentificacion: UILabel!
    @IBOutlet weak var lblFechaNacimiento: UILabel!
    @IBOutlet weak var lblSexo: UILabel!
    @IBOutlet weak var lblCondicionLectura: UILabel!
    // Título número de identificación
    @IBOutlet weak var lblTituloNumeroIdentificacion: UILabel!
    
    // Vistas sólo lectura
    @IBOutlet weak var vistaSoloLectura: UIView!
    @IBOutlet weak var vistaEdicionParte1: UIView!
    @IBOutlet weak var vistaEdicionParte2: UIView!
    
    @IBOutlet weak var vistaLecturaNombre: UIView!
    @IBOutlet weak var vistaLecturaConsentimiento: UIView!
    @IBOutlet weak var vistaLecturaTipoIdentificacion: UIView!
    @IBOutlet weak var vistaLecturaCondicion: UIView!
    @IBOutlet weak var vistaLecturaNumeroIdentificacion: UIView!
    @IBOutlet weak var vistaLecturaFechaNacimiento: UIView!
    @IBOutlet weak var vistaLecturaSexo: UIView!
    
    // Alto vista sólo lectura
    @IBOutlet weak var altoVistaSoloLectura: NSLayoutConstraint!
    @IBOutlet weak var altoEdicionParte1: NSLayoutConstraint!
    @IBOutlet weak var altoEdicionParte2: NSLayoutConstraint!
    @IBOutlet weak var altoCondicionSoloLectura: NSLayoutConstraint!
    
    // Se declaran variables para modificar el alto de cada vista.
    var acompanianteHeightVisible: CGFloat!;
    var responsableHeightVisible: CGFloat!;
    var condicionHeightVisible: CGFloat!;
    var inpecHeightVisible: CGFloat!;
    var identificacionHeightVisible: CGFloat!;
    var soloLecturaHeightVisible: CGFloat!;
    var edicionParte1HeightVisible: CGFloat!;
    var edicionParte2HeightVisible: CGFloat!;
    var condicionSoloLecturaHeightVisible: CGFloat!;
    
    // Se declara un height visible auxiliar que tomará temporalmente el valor de la capa a interactuar.
    var auxiliarHeightVisible: CGFloat!;
    
    // Permiten almacenar la posición del elemento escogido por el usuario.
    var unidadMedidaSeleccionada = 0;
    var tipoIdentificacionSeleccionado = 0;
    var generoSeleccionado = 1;
    var estadoCivilSeleccionado = 0;
    var departamentoSeleccionado = 0;
    var municipioSeleccionado = 0;
    var zonaResidenciaSeleccionada = 1;
    var tipoUsuarioSeleccionado = 0;
    var causaExternaSeleccionada = 0;
    var nacimientoSeleccionado = "";
    var aseguradoraSeleccionada = 0;
    var condicionSeleccionada = 0;
    
    // Permiten cargar en memoria la información traída de la base de datos.
    var listaUnidadMedida = [ConstanteValor]();
    var listaTipoIdentificacion = [ConstanteValor]();
    var listaEstadoCivil = [ConstanteValor]();
    var listaDepartamentos = [Departamento]();
    var listaMunicipios = [Municipio]();
    var listaTipoUsuario = [ConstanteValor]();
    var listaCausaExterna = [ConstanteValor]();
    var listaAseguradoras = [Aseguradora]();
    var listaCondiciones = [ConstanteValor]();
    var listaGeneros = [ConstanteValor]();
    
    // Se declara la conexión para hacer las consultas
    let conexion = Conexion();
    
    // Se declara variable para el número de documento que viene desde la búsqueda.
    var busquedaIdentificacion: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    /**
     Permite inicializar valores, preparar funcionalidades y aplicar estilos.
     */
    private func inits () {
        // Ajustar estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnNacimiento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnUnidadMedida.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTipoIdentificacion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnEstadoCivil.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnDepartamento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnMunicipio.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTipoUsuario.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCausaExterna.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCondicion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.vistaLecturaNombre.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaLecturaConsentimiento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaLecturaTipoIdentificacion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaLecturaNumeroIdentificacion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaLecturaFechaNacimiento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaLecturaSexo.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.btnNacimiento.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnNacimiento.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnUnidadMedida.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnUnidadMedida.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnTipoIdentificacion.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnTipoIdentificacion.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnEstadoCivil.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnEstadoCivil.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnDepartamento.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnDepartamento.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnMunicipio.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnMunicipio.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnTipoUsuario.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnTipoUsuario.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnCausaExterna.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnCausaExterna.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnCondicion.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnCondicion.layer.borderColor = Constantes.BORDE_COLOR;
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se ocultan las opciones de acompañante y resonsable al iniciar la vista.
        self.acompanianteHeightVisible = self.altoAcompaniante.constant;
        self.vistaAcompaniante.isHidden = true;
        self.altoAcompaniante.constant = 0;
        
        self.responsableHeightVisible = self.altoResponsable.constant;
        self.vistaResponsable.isHidden = true;
        self.altoResponsable.constant = 0;
        
        // Condición e INPEC
        self.condicionHeightVisible = self.altoCondicion.constant;
        self.vistaCondicion.isHidden = true;
        self.altoCondicion.constant = 0;
        
        self.inpecHeightVisible = self.altoInpec.constant;
        self.vistaInpec.isHidden = true;
        self.altoInpec.constant = 0;
        
        // Altos vista sólo lectura
        self.soloLecturaHeightVisible = self.altoVistaSoloLectura.constant;
        self.vistaSoloLectura.isHidden = true;
        self.altoVistaSoloLectura.constant = 0;
        
        // Altos vistas editables
        self.edicionParte1HeightVisible = self.altoEdicionParte1.constant;
        self.altoEdicionParte2.constant = 300;
        self.edicionParte2HeightVisible = self.altoEdicionParte2.constant;
        
        self.condicionSoloLecturaHeightVisible = self.altoCondicionSoloLectura.constant;
        self.vistaLecturaCondicion.isHidden = true;
        self.altoCondicionSoloLectura.constant = 0;
        
        self.identificacionHeightVisible = self.altoIdentificacion.constant;
        
        self.radioSexo.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected);
        self.radioResidencia.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected);
        
        // Se carga el documento de identidad después de la búsqueda
        self.txtNumeroIdentificacion.text = self.busquedaIdentificacion;
        
        // Se valida si ya se ha diligenciado todo el proceso y está activo terminación
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.btnSiguiente.setTitle(Mensajes.TEXTO_BOTON_RESUMEN, for: .normal);
        }
        
        // Si la búsqueda de paciente está vacía, entonces se inhabilita la edición del número de documento.
        if (MemoriaRegistroPaciente.busquedaVacia) {
            self.txtNumeroIdentificacion.isEnabled = false;
        }
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
        // Se obtiene la conexión con la base de datos.
        self.conexion.conectarBaseDatos();
        
        // Preparar información para combos de selección.
        self.cargarInformacionSelectores();
    }
    
    /**
     Permite consultar en la base de datos, la información que se debe mostrar en las listas desplegables.
     */
    private func cargarInformacionSelectores () {
        // Se declara un objeto ConstanteValor por defecto para los campos de constantes.
        let constanteValorDefault = ConstanteValor();
        constanteValorDefault.value = 0;
        constanteValorDefault.title = Mensajes.CAMPO_SELECCIONAR;
        constanteValorDefault.id = 0;
        // Se crea un objeto departamento por defecto para anteponer la opción Seleccionar, con valor 0.
        let departamentoDefault = Departamento();
        departamentoDefault.name = Mensajes.CAMPO_SELECCIONAR;
        departamentoDefault.id = 0;
        // Se crea un objeto Aseguradora por defecto para anteponer la opción Selección, con valor 0
        let aseguradoraDefault = Aseguradora();
        aseguradoraDefault.name = Mensajes.CAMPO_SELECCIONAR;
        aseguradoraDefault.id = 0;
        
        self.listaUnidadMedida = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "unit_measurement");
        self.listaUnidadMedida.insert(constanteValorDefault, at: 0);
        
        self.listaTipoIdentificacion = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "type_document");
        self.listaTipoIdentificacion.insert(constanteValorDefault, at: 0);
        
        self.listaEstadoCivil = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "civil_status");
        self.listaEstadoCivil.insert(constanteValorDefault, at: 0);
        
        self.listaDepartamentos = FachadaIndependientesSQL.seleccionarTodoDepartamento(conexion: conexion);
        self.listaDepartamentos.insert(departamentoDefault, at: 0);
        
        self.listaTipoUsuario = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "type_user");
        self.listaTipoUsuario.insert(constanteValorDefault, at: 0);
        
        self.listaCausaExterna = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "external_cause");
        self.listaCausaExterna.insert(constanteValorDefault, at: 0);
        // Causa externa se inicializa en Enfermedad General
        if(self.listaCausaExterna.count > 0) {
            self.causaExternaSeleccionada = 1;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnCausaExterna, texto: self.listaCausaExterna[self.causaExternaSeleccionada].title!);
        }
        
        self.listaCondiciones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "type_condition");
        self.listaCondiciones.insert(constanteValorDefault, at: 0);
        
        self.listaGeneros = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "genre");
        
        self.listaAseguradoras = FachadaIndependientesSQL.seleccionarTodoAseguradora(conexion: conexion);
        self.listaAseguradoras.insert(aseguradoraDefault, at: 0);
        
        // Así como se prepararon los demás elemmentos especiales, se procede con el buscador de Aseguradoras.
        self.prepararAseguradoraAutocompletar();
        // Se carga la información si el paciente ya existe.
        self.precargarInformacionGuardada();
        // Validar sólo lectura
        self.validarVistaSoloLectura();
    }
    
    /**
     Permite configurar y preparar el campo de texto de Aseguradora para poder buscar y seleccionar entre las opciones.
     */
    private func prepararAseguradoraAutocompletar () {
        // Se configuran las variables de estilos y el comportamiento de la lista.
        self.txtAsegurador.theme.font = UIFont.systemFont(ofSize: 13);
        self.txtAsegurador.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.95);
        self.txtAsegurador.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1);
        self.txtAsegurador.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8);
        self.txtAsegurador.theme.fontColor = .black;
        self.txtAsegurador.theme.placeholderColor = .lightGray;
        self.txtAsegurador.theme.cellHeight = 50;
        self.txtAsegurador.comparisonOptions = .caseInsensitive;
        self.txtAsegurador.minCharactersNumberToStartFiltering = 3;
        // Al seleccionar una opción se muestra el nombre en el campo de texto y se consulta en la base de datos para obtener el ID.
        self.txtAsegurador.itemSelectionHandler = {
            item, itemPosition in
            // Se obtiene el nombre del elemento seleccionado de la lista.
            let nombre = item[itemPosition].title;
            // Se asigna ese nombre como valor en el campo de texto que inició la búsqueda.
            self.txtAsegurador.text = nombre;
            // Se valida si ese nombre existe en la base de datos. Se crea un objeto con el resultado de la consulta en BD.
            if let aseguradora = FachadaIndependientesSQL.seleccionarPorNombreAseguradora(conexion: self.conexion, nombre: nombre) {
                // Del objeto creado por medio de la consulta a BD se obtiene el ID para se guardado en la variable aseguradoraSeleccionada.
                self.aseguradoraSeleccionada = aseguradora.id!;
            } else {
                // Si no hay coincidencias en la base de datos, entonces se inicializa el valor de la variable aseguradoraSeleccionada en 0.
                self.aseguradoraSeleccionada = 0;
            }
        }
        
        self.transformarInformacionAseguradoras();
    }
    
    /**
     Permite tomar la lista de aseguradoras en memoria y pasarla a SearchTextFieldItem's para que se puedan mostrar y seleccionar.
     Esto sucede si la lista tiene al menos un elemento. De manera inmediata se cargan al campo de texto a través del método filterItems de la librería.
     */
    private func transformarInformacionAseguradoras () {
        if (self.listaAseguradoras.count > 0) {
            var listaBusqueda = [SearchTextFieldItem]();
            for aseguradora in self.listaAseguradoras {
                let item = SearchTextFieldItem(title: aseguradora.name!, subtitle: aseguradora.code, image: nil);
                listaBusqueda.append(item);
            }
            self.txtAsegurador.filterItems(listaBusqueda);
        }
    }
    
    /**
     Permite validar si el paciente ya existe, para entonces evitar que los campos de sólo lectura se puedan editar.
     */
    private func validarVistaSoloLectura () {
        if let pacienteGuardado = MemoriaRegistroPaciente.paciente {
            
            // Se ocultan editables
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaEdicionParte1, altoInicial: self.altoEdicionParte1, animado: true);
            
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaEdicionParte2, altoInicial: self.altoEdicionParte2, animado: true);
            
            // Se agrega la información a los labels.
            if let sexo = self.listaGeneros.first(where: {$0.value == pacienteGuardado.genre}) {
                self.lblSexo.text = sexo.title;
            }
            if let tipoIdentificacion = self.listaTipoIdentificacion.first(where: {$0.value == pacienteGuardado.type_document}) {
                self.lblTipoIdentificacion.text = tipoIdentificacion.title;
                
                // Se valida si no es Adulto ni Joven sin identificar
                if(tipoIdentificacion.value != 11 && tipoIdentificacion.value != 12) {
                    self.lblNumeroIdentificacion.text = pacienteGuardado.number_document;
                    
                    // Se resta al tamaño de la vista de sólo lectura.
                    self.soloLecturaHeightVisible -= self.condicionSoloLecturaHeightVisible;
                                        
                } else {
                    if let tipoCondicion = self.listaCondiciones.first(where: {$0.value == pacienteGuardado.type_condition}) {
                        
                        // Se muestra la sección Condición Lectura
                        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaLecturaCondicion, altoInicial: self.altoCondicionSoloLectura, altoAuxiliar: self.condicionSoloLecturaHeightVisible, animado: true);
                        
                        self.lblCondicionLectura.text = tipoCondicion.title;
                        
                        // Si se relaciona con INPEC
                        if (tipoCondicion.value == 10) {
                            self.lblTituloNumeroIdentificacion.text = "Número INPEC";
                            self.lblNumeroIdentificacion.text = pacienteGuardado.number_inpec;
                        } else {
                            self.lblNumeroIdentificacion.text = pacienteGuardado.number_document;
                        }
                        
                    }
                }
            }
            self.lblNombre.text = "\(pacienteGuardado.name ?? "") \(pacienteGuardado.last_name ?? "")";
            self.lblFechaNacimiento.text = pacienteGuardado.birthdate;
            
            if let informacionPaciente = MemoriaRegistroPaciente.informacionPaciente {
                
                self.lblConsentimiento.text = (informacionPaciente.terms_conditions ?? false) ? "Si" : "No";
                
                // Vista Consentimiento
                self.vistaTerminosCondiciones.isHidden = true;
                self.altoTerminosCondiciones.constant = 0;
            }
            
            // Se muestra vista sólo lectura
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaSoloLectura, altoInicial: self.altoVistaSoloLectura, altoAuxiliar: self.soloLecturaHeightVisible, animado: false);
            
            
        } else {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaSoloLectura, altoInicial: self.altoVistaSoloLectura, animado: false);
            
            // Se muestran vistas editables
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaEdicionParte1, altoInicial: self.altoEdicionParte1, altoAuxiliar: self.edicionParte1HeightVisible, animado: false);
            
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaEdicionParte2, altoInicial: self.altoEdicionParte2, altoAuxiliar: self.edicionParte2HeightVisible, animado: false);
        }
    }
    
    /**
     Permite rellenar el formulario con la información que ya había sido almacenada.
     */
    private func precargarInformacionGuardada () {
        if let informacionPacienteAlmacenada = MemoriaRegistroPaciente.informacionPaciente {
            
            self.txtEdad.text = informacionPacienteAlmacenada.age?.description;
            
            // Unidad de medida
            if let unidadMedidaId = informacionPacienteAlmacenada.unit_measure_age {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let unidadFila = self.listaUnidadMedida.firstIndex(where: {$0.value == unidadMedidaId}) {
                    
                    self.unidadMedidaSeleccionada = unidadFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnUnidadMedida, texto: self.listaUnidadMedida[self.unidadMedidaSeleccionada].title!);
                }
            }
            
            // Estado civil
            if let estadoCivilId = informacionPacienteAlmacenada.civil_status {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let estadoCivilFila = self.listaEstadoCivil.firstIndex(where: {$0.value == estadoCivilId}) {
                    
                    self.estadoCivilSeleccionado = estadoCivilFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnEstadoCivil, texto: self.listaEstadoCivil[self.estadoCivilSeleccionado].title!);
                }
            }
            
            self.txtOcupacion.text = informacionPacienteAlmacenada.occupation;
            self.txtCelular.text = informacionPacienteAlmacenada.phone;
            self.txtEmail.text = Validacion.esCadenaEmail(texto: informacionPacienteAlmacenada.email) ? informacionPacienteAlmacenada.email : "";
            self.txtDireccionDomicilio.text = informacionPacienteAlmacenada.address;
            
            // Municipio y departamento - Primero se carga departamento para que exista municipio
            if let municipioId = informacionPacienteAlmacenada.municipality_id {
                
                // Se obtiene toda la información de municipio para acceder al departamento.
                if let municipio = FachadaIndependientesSQL.seleccionarPorIdMunicipio(conexion: self.conexion, idRegistro: municipioId) {
                    
                    // Se busca el índice donde coincida el ID dentro de la lista.
                    if let departamentoFila = self.listaDepartamentos.firstIndex(where: {$0.id == municipio.department_id}) {
                        
                        self.departamentoSeleccionado = departamentoFila;
                        Funcionales.ajustarTextoBotonSelector(boton: self.btnDepartamento, texto: self.listaDepartamentos[self.departamentoSeleccionado].name!);
                        
                        self.listaMunicipios = FachadaIndependientesSQL.seleccionarPorDepartamento(conexion: self.conexion, idDepartamento: self.departamentoSeleccionado);
                        
                        if (self.listaMunicipios.count > 0) {
                            if let municipioFila = self.listaMunicipios.firstIndex(where: {$0.id == municipioId}) {
                                
                                self.municipioSeleccionado = municipioFila;
                                Funcionales.ajustarTextoBotonSelector(boton: self.btnMunicipio, texto: self.listaMunicipios[self.municipioSeleccionado].name!);
                            }
                        }
                    }
                }
            }
            
            // Zona Urbana
            self.zonaResidenciaSeleccionada = informacionPacienteAlmacenada.urban_zone!;
            self.radioResidencia.selectedSegmentIndex = self.zonaResidenciaSeleccionada - 1;
            
            // Acompañante
            if(informacionPacienteAlmacenada.companion!) {
                self.switchAcompaniante.isOn = true;
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAcompaniante, altoInicial: self.altoAcompaniante, altoAuxiliar: self.acompanianteHeightVisible, animado: true);
            }
            self.txtNombreAcompaniante.text = informacionPacienteAlmacenada.name_companion;
            self.txtCelularAcompaniante.text = informacionPacienteAlmacenada.phone_companion;
            
            // Responsable
            if(informacionPacienteAlmacenada.responsible!) {
                self.switchResponsable.isOn = true;
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaResponsable, altoInicial: self.altoResponsable, altoAuxiliar: self.responsableHeightVisible, animado: true);
            }
            self.txtNombreResponsable.text = informacionPacienteAlmacenada.name_responsible;
            self.txtCelularResponsable.text = informacionPacienteAlmacenada.phone_responsible;
            self.txtParentescoResponsable.text = informacionPacienteAlmacenada.relationship;
            
            // Tipo Usuario
            if let tipoUsuarioId = informacionPacienteAlmacenada.type_user {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let tipoUsuarioFila = self.listaTipoUsuario.firstIndex(where: {$0.value == tipoUsuarioId}) {
                    
                    self.tipoUsuarioSeleccionado = tipoUsuarioFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnTipoUsuario, texto: self.listaTipoUsuario[self.tipoUsuarioSeleccionado].title!);
                }
            }
            
            // Aseguradora
            if let aseguradoraId = informacionPacienteAlmacenada.insurance_id {
                if let aseguradora = FachadaIndependientesSQL.seleccionarPorIdAseguradora(conexion: self.conexion, idRegistro: aseguradoraId) {
                    
                    self.aseguradoraSeleccionada = aseguradoraId;
                    self.txtAsegurador.text = aseguradora.name;
                }
            }
            
            self.txtNumeroAutorizacion.text = informacionPacienteAlmacenada.authorization_number;
            
            // Causa externa
            if let causaExternaId = informacionPacienteAlmacenada.external_cause {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let causaExternaFila = self.listaCausaExterna.firstIndex(where: {$0.value == causaExternaId}) {
                    
                    self.causaExternaSeleccionada = causaExternaFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnCausaExterna, texto: self.listaCausaExterna[self.causaExternaSeleccionada].title!);
                }
            }
        }
    }
    
    /**
     Permite mostrar un selector de fecha a través de un modal.
     */
    private func mostrarPickerFecha () {
        let dateFormat = DateFormatter();
        dateFormat.dateFormat = "yyyy-MM-dd";
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 200));
        pickerView.datePickerMode = .date;
        
        if (self.nacimientoSeleccionado != "") {
            pickerView.date = dateFormat.date(from: self.nacimientoSeleccionado)!;
        }
        vc.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: "Escoge una fecha", message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(vc, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: {
            UIAlertAction in
            self.nacimientoSeleccionado = dateFormat.string(from: pickerView.date);
            self.btnNacimiento.setTitle(self.nacimientoSeleccionado, for: .normal);
            
            let edadCalculada = Funcionales.calcularEdad(nacimiento: pickerView.date, listaUnidadMedida: self.listaUnidadMedida, enTexto: false);
            
            // Si es posible calclular la edad
            if let (cantidad, unidad) = edadCalculada {
                // Se asignan los valores en edad y unidad de medida.
                self.txtEdad.text = cantidad.description;
                self.unidadMedidaSeleccionada = Int(unidad)!;
                Funcionales.ajustarTextoBotonSelector(boton: self.btnUnidadMedida, texto: self.listaUnidadMedida[Int(unidad)!].title!);
            }
        }));
        
        self.present(opcionesAlert, animated: true);
    }
    
    /**
     Permite mostrar un modal para la selección de las opciones de tipo de profesional.
     No requiere de parámetros y no retorna.
     */
    private func mostrarPickerSelectores (grupo: String, titulo: String) {
        // Se declara un tag que permita identificar sobre cuál picker trabajarán los delegados.
        var tag = 0;
        // Se declara una variable que permitira precargar el selector cuando el valor es mayor a 0.
        var itemSeleccionado = 0;
        // Se reinicia el valor por defecto a la variable que representa la selección del usuario.
        switch grupo {
        case "unit_measurement":
            itemSeleccionado = self.unidadMedidaSeleccionada;
            tag = 1;
        case "type_document":
            itemSeleccionado = self.tipoIdentificacionSeleccionado;
            tag = 2;
        case "civil_status":
            itemSeleccionado = self.estadoCivilSeleccionado;
            tag = 3;
        case "department":
            itemSeleccionado = self.departamentoSeleccionado;
            tag = 4;
        case "municipality":
            itemSeleccionado = self.municipioSeleccionado;
            tag = 5;
        case "type_user":
            itemSeleccionado = self.tipoUsuarioSeleccionado;
            tag = 6;
        case "external_cause":
            itemSeleccionado = self.causaExternaSeleccionada;
            tag = 7;
        case "type_condition":
            itemSeleccionado = self.condicionSeleccionada;
            tag = 8;
        default:
            self.unidadMedidaSeleccionada = 0;
            self.tipoIdentificacionSeleccionado = 0;
            self.estadoCivilSeleccionado = 0;
            self.departamentoSeleccionado = 0;
            self.municipioSeleccionado = 0;
            self.tipoUsuarioSeleccionado = 0;
            self.causaExternaSeleccionada = 1;
            self.condicionSeleccionada = 0;
        }
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200));
        pickerView.tag = tag;
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        // si es mayor a cero es que ya ha sido seleccionado y se ubica en el selector.
        if (itemSeleccionado > 0) {
            pickerView.selectRow(itemSeleccionado, inComponent: 0, animated: true);
        }
        
        vc.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(vc, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil));
        
        self.present(opcionesAlert, animated: true);
    }
    
    /**
     Permite validar si los datos obligatorios del formuario se diligenciaron correctamente.
     - Returns: Devuelve True si todo es correcto y False en caso contrario.
     */
    private func sonCamposCorrectos () -> Bool {
        
        var campos = [UITextField]();
        // Se incluyen los campos cuando el usuario es nuevo.
        if(MemoriaRegistroPaciente.paciente == nil) {
            campos.append(self.txtPrimerNombre!);
            campos.append(self.txtPrimerApellido!);
            campos.append(self.txtEdad!);
        }            
        campos.append(self.txtAsegurador!);
        
        // Primero se valida que los campos de texto no estén vacíos.
        let camposVaciosOK = !Validacion.sonCamposVacios(textos: campos);
        // Si no pasa la validación de campos vacíos no continúa con la siguientes validaciones.
        if !camposVaciosOK {
            self.txtPrimerNombre.becomeFirstResponder();
            self.scrollView.scrollToTop(animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        // Se evalúan los campos numéricos
        let camposNumericosOK = Validacion.sonCamposNumericos(textos: [self.txtEdad]);
        // Si no pasa la validación de campos numéricos no contnúa con la siguiente.
        if !camposNumericosOK {
            self.txtEdad.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtEdad, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_NUMEROS);
            return false;
        }
        
        if (!self.txtEmail.text!.isEmpty) {
            // Se evalúa los campos Email si el usuario ha digitado algo.
            let camposEmailOK = Validacion.esCampoEmail(email: self.txtEmail);
            // Si no pasa la validación de correo electrónico, no continúa con la siguiente.
            if !camposEmailOK {
                self.txtEmail.becomeFirstResponder();
                self.scrollView.scrollToView(view: self.txtEmail, animated: true);
                Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_CORREO);
                return false;
            }
        }
        
        // Se evalúa número mínimo de caracteres campos opcionales.
        if (!self.txtCelular.text!.isEmpty){
            let camposMinimosOpcionalesOK = Validacion.sonCamposCaracteresMinimos(campos: [self.txtCelular], min: 7);
            // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
            if !camposMinimosOpcionalesOK {
                self.txtCelular.becomeFirstResponder();
                self.scrollView.scrollToView(view: self.txtCelular, animated: true);
                Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MINIMO_CARACTERES) 7");
                return false;
            }
        }
        
        // Se incluyen los campos cuando el usuario es nuevo.
        if(MemoriaRegistroPaciente.paciente == nil) {
            // Se evalúa si se ha seleccionado un tipo de identificación.
            let tipoIdentificacionOK = (self.tipoIdentificacionSeleccionado > 0) ? true : false;
            if !tipoIdentificacionOK {
                Validacion.pintarErrorCampoFormulario(view: self.btnTipoIdentificacion);
                self.txtEdad.becomeFirstResponder();
                self.scrollView.scrollToView(view: self.btnTipoIdentificacion, animated: true);
                Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_TIPO_IDENTIFICACION);
                return false;
            } else {
                Validacion.pintarCorrectoCampoFormulario(view: self.btnTipoIdentificacion, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
                
                // Se valida si es menor o adulto sin identificar.
                let objTipoIdentificacion = self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado];
                if (objTipoIdentificacion.value == 11 || objTipoIdentificacion.value == 12) {
                    let condicionOK = (self.condicionSeleccionada > 0 ? true : false);
                    if !condicionOK {
                        Validacion.pintarErrorCampoFormulario(view: self.btnTipoIdentificacion);
                        self.txtEdad.becomeFirstResponder();
                        self.scrollView.scrollToView(view: self.btnTipoIdentificacion, animated: true);
                        Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_CONDICION);
                        return false;
                    } else {
                        Validacion.pintarCorrectoCampoFormulario(view: self.btnCondicion, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
                    }
                    
                    // Se valida si la condición seleccionada corresponde a caso INPEC
                    if (self.listaCondiciones[self.condicionSeleccionada].value == 10) {
                        if (Validacion.esCampoTextoVacio(view: self.txtInpec)) {
                            Validacion.pintarErrorCampoFormulario(view: self.txtInpec);
                            self.txtInpec.becomeFirstResponder();
                            self.scrollView.scrollToView(view: self.txtInpec, animated: true);
                            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_INPEC);
                            return false;
                        }
                    } else {
                        Funcionales.vaciarCamposTexto(campos: [self.txtInpec]);
                    }
                }
                
                if (self.listaCondiciones[self.condicionSeleccionada].value != 10 && !MemoriaRegistroPaciente.busquedaVacia) {
                    let identificacionOK = !Validacion.esCampoTextoVacio(view: self.txtNumeroIdentificacion);
                    if (!identificacionOK) {
                        Validacion.pintarErrorCampoFormulario(view: self.txtNumeroIdentificacion);
                        self.txtNumeroIdentificacion.becomeFirstResponder();
                        self.scrollView.scrollToView(view: self.txtNumeroIdentificacion, animated: true);
                        Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
                        return false;
                    } else {
                        // Se evalúa número mínimo de caracteres campos obligatorios.
                        let camposMinimosObligatoriosOK = Validacion.sonCamposCaracteresMinimos(campos: [self.txtNumeroIdentificacion], min: 5);
                        // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
                        if !camposMinimosObligatoriosOK {
                            Validacion.pintarErrorCampoFormulario(view: self.txtNumeroIdentificacion);
                            self.txtNumeroIdentificacion.becomeFirstResponder();
                            self.scrollView.scrollToView(view: self.txtNumeroIdentificacion, animated: true);
                            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MINIMO_CARACTERES) 5");
                            return false;
                        }
                        
                        // Se evalúa número máximo de caracteres campos obligatorios.
                        let camposMaximosObligatoriosOK = Validacion.sonCamposCaracteresMaximos(campos: [self.txtNumeroIdentificacion], max: 16);
                        // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
                        if !camposMaximosObligatoriosOK {
                            Validacion.pintarErrorCampoFormulario(view: self.txtNumeroIdentificacion);
                            self.txtNumeroIdentificacion.becomeFirstResponder();
                            self.scrollView.scrollToView(view: self.txtNumeroIdentificacion, animated: true);
                            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MAXIMO_CARACTERES) 16");
                            return false;
                        }
                        
                        let campoNumericoOK = Validacion.esCampoNumerico(texto: self.txtNumeroIdentificacion);
                        if (!campoNumericoOK) {
                            Validacion.pintarErrorCampoFormulario(view: self.txtNumeroIdentificacion);
                            self.txtNumeroIdentificacion.becomeFirstResponder();
                            self.scrollView.scrollToView(view: self.txtNumeroIdentificacion, animated: true);
                            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_NUMEROS);
                            return false;
                        }
                    }
                } // Fin if 10
            } // !tipoIdentificacionOK
        }
        
        // Se evalúa si se ha seleccionado un unidad de medida.
        let unidadMedidaOK = (self.unidadMedidaSeleccionada > 0) ? true : false;
        if !unidadMedidaOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnUnidadMedida);
            self.txtEdad.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnUnidadMedida, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_UNIDAD_MEDIDA);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnUnidadMedida, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un estado civil.
        let estadoCivilOK = (self.estadoCivilSeleccionado > 0) ? true : false;
        if !estadoCivilOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnEstadoCivil);
            self.txtOcupacion.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnEstadoCivil, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_ESTADO_CIVIL);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnEstadoCivil, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un departamento.
        let departamentoOK = (self.departamentoSeleccionado > 0) ? true : false;
        if !departamentoOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnDepartamento);
            self.txtDireccionDomicilio.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnDepartamento, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_DEPARTAMENTO);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnDepartamento, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un municipio.
        let municipioOK = (self.municipioSeleccionado > 0) ? true : false;
        if !municipioOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnMunicipio);
            self.txtDireccionDomicilio.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnMunicipio, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_MUNICIPIO);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnMunicipio, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un tipo usuario.
        let tipoUsuarioOK = (self.tipoUsuarioSeleccionado > 0) ? true : false;
        if !tipoUsuarioOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnTipoUsuario);
            self.txtAsegurador.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnTipoUsuario, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_TIPO_USUARIO);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnTipoUsuario, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un causa externa.
        let causaExternaOK = (self.causaExternaSeleccionada > 0) ? true : false;
        if !causaExternaOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnCausaExterna);
            self.txtNumeroAutorizacion.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnCausaExterna, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_CAUSA_EXTERNA);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnCausaExterna, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado una aseguradora.
        let aseguradoraOK = (self.aseguradoraSeleccionada > 0) ? true : false;
        if !aseguradoraOK {
            Validacion.pintarErrorCampoFormulario(view: self.txtAsegurador);
            self.txtAsegurador.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtAsegurador, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_ASEGURADORA);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.txtAsegurador, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se incluyen los campos cuando el usuario es nuevo.
        if(MemoriaRegistroPaciente.paciente == nil) {
            // Se evalúa si se ha firmado consentimiento.
            let consentimientoOK = self.switchConsentimiento.isOn;
            if !consentimientoOK {
                Validacion.pintarErrorCampoFormulario(view: self.switchConsentimiento);
                self.txtAsegurador.becomeFirstResponder();
                self.scrollView.scrollToView(view: self.switchConsentimiento, animated: true);
                Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_CONSENTIMIENTO);
                return false;
            } else {
                Validacion.pintarCorrectoCampoFormulario(view: self.switchConsentimiento, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
            }
        }
        return true;
    }
    
    /**
     Permite guardar la información del formulario en un objeto paciente.
     Posteriormente se almacena en memoria.
     Aquí ya se guardan los ID de la base de datos interna.
     */
    private func capturarInformacionPaciente () {
        
        // Se guarda la información del paciente en un objeto local.
        let paciente = Paciente();
        paciente.name = MemoriaRegistroPaciente.paciente == nil ?  self.txtPrimerNombre.text! : MemoriaRegistroPaciente.paciente?.name;
        paciente.second_name = MemoriaRegistroPaciente.paciente == nil ? (self.txtSegundoNombre.text != "" ? self.txtSegundoNombre.text : Mensajes.NO_REPORTA) : MemoriaRegistroPaciente.paciente?.second_name;
        paciente.last_name = MemoriaRegistroPaciente.paciente == nil ? self.txtPrimerApellido.text! : MemoriaRegistroPaciente.paciente?.last_name;
        paciente.second_surname = MemoriaRegistroPaciente.paciente == nil ? (self.txtSegundoApellido.text != "" ? self.txtSegundoApellido.text : Mensajes.NO_REPORTA) : MemoriaRegistroPaciente.paciente?.second_surname;
        paciente.type_document = MemoriaRegistroPaciente.paciente == nil ?  self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value : MemoriaRegistroPaciente.paciente?.type_document;
        
        // Se valida tipo de identificación antes de asignar condición.
        paciente.type_condition = MemoriaRegistroPaciente.paciente == nil ?  ((self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value != 11 && self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value != 12) ? nil : self.listaCondiciones[self.condicionSeleccionada].value) : MemoriaRegistroPaciente.paciente?.type_condition;
        
        // Se valida si aplica o no número de documento
        paciente.number_document = MemoriaRegistroPaciente.paciente == nil ?  (((self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value != 11 && self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value != 12) || (self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value == 11 || self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value == 12 && self.listaCondiciones[self.condicionSeleccionada].value != 10)) ? self.txtNumeroIdentificacion.text! : nil) : MemoriaRegistroPaciente.paciente?.number_document;
        
        // Se valida si aplica o no INPEC
        paciente.number_inpec = MemoriaRegistroPaciente.paciente == nil ?  (((self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value == 11 || self.listaTipoIdentificacion[self.tipoIdentificacionSeleccionado].value == 12) && self.listaCondiciones[self.condicionSeleccionada].value == 10) ? self.txtInpec.text! : nil) : MemoriaRegistroPaciente.paciente?.number_inpec;
        
        paciente.birthdate = MemoriaRegistroPaciente.paciente == nil ? (self.nacimientoSeleccionado != "" ? self.nacimientoSeleccionado : Mensajes.NO_REPORTA) : MemoriaRegistroPaciente.paciente?.birthdate;
        paciente.genre = MemoriaRegistroPaciente.paciente == nil ? self.listaGeneros[self.generoSeleccionado].value : MemoriaRegistroPaciente.paciente?.genre;
        
        paciente.id = MemoriaRegistroPaciente.paciente?.id;
        paciente.created_at = MemoriaRegistroPaciente.paciente == nil ? nil : MemoriaRegistroPaciente.paciente?.created_at;
        paciente.updated_at = MemoriaRegistroPaciente.paciente == nil ? nil : MemoriaRegistroPaciente.paciente?.updated_at;
        paciente.sincronizado = MemoriaRegistroPaciente.paciente?.sincronizado;
        paciente.id_local = MemoriaRegistroPaciente.paciente?.id_local;
        
        // Se almacena en la variable estática en memoria.
        MemoriaRegistroPaciente.paciente = paciente;
        
        Funcionales.imprimirObjetoConPropiedades(objeto: MemoriaRegistroPaciente.paciente!, titulo: "Paciente Test");
    }
    
    /**
     Permite almacenar la información del formulario en un objeto InformacionPaciente.
     Posteriormente se almacena en memoria en variable estática.
     Aquí ya se guardan los ID de la base de datos interna.
     */
    private func capturarInformacionAdicionalPaciente () {
        // Se guarda la información en un objeto local.
        let informacionPaciente = InformacionPaciente();
        
        informacionPaciente.terms_conditions = MemoriaRegistroPaciente.informacionPaciente == nil ? self.switchConsentimiento.isOn ? true : false : MemoriaRegistroPaciente.informacionPaciente?.terms_conditions;
        informacionPaciente.insurance_id = self.aseguradoraSeleccionada;
        informacionPaciente.unit_measure_age = self.listaUnidadMedida[self.unidadMedidaSeleccionada].value;
        informacionPaciente.age = Int(self.txtEdad.text!);
        informacionPaciente.occupation = self.txtOcupacion.text != "" ? self.txtOcupacion.text : Mensajes.NO_REPORTA;
        informacionPaciente.phone = self.txtCelular.text != "" ? self.txtCelular.text : Mensajes.NO_REPORTA;
        informacionPaciente.email = self.txtEmail.text;
        informacionPaciente.address = self.txtDireccionDomicilio.text != "" ? self.txtDireccionDomicilio.text : Mensajes.NO_REPORTA;
        informacionPaciente.municipality_id = self.listaMunicipios[self.municipioSeleccionado].id;
        informacionPaciente.urban_zone = self.zonaResidenciaSeleccionada;
        informacionPaciente.companion = self.switchAcompaniante.isOn ? true : false;
        informacionPaciente.name_companion = self.switchAcompaniante.isOn ? (self.txtNombreAcompaniante.text != "" ? self.txtNombreAcompaniante.text : Mensajes.NO_REPORTA) : nil;
        informacionPaciente.phone_companion = self.switchAcompaniante.isOn ? (self.txtCelularAcompaniante.text != "" ? self.txtCelularAcompaniante.text : Mensajes.NO_REPORTA) : nil;
        informacionPaciente.responsible = self.switchResponsable.isOn ? true : false;
        informacionPaciente.name_responsible = self.switchResponsable.isOn ? (self.txtNombreResponsable.text != "" ? self.txtNombreResponsable.text : Mensajes.NO_REPORTA) : nil;
        informacionPaciente.phone_responsible = self.switchResponsable.isOn ? (self.txtCelularResponsable.text != "" ? self.txtCelularResponsable.text : Mensajes.NO_REPORTA) : nil;
        informacionPaciente.relationship = self.switchResponsable.isOn ? (self.txtParentescoResponsable.text != "" ? self.txtParentescoResponsable.text : Mensajes.NO_REPORTA) : nil;
        informacionPaciente.type_user = self.listaTipoUsuario[self.tipoUsuarioSeleccionado].value;
        informacionPaciente.authorization_number = self.txtNumeroAutorizacion.text  != "" ? self.txtNumeroAutorizacion.text : Mensajes.NO_REPORTA;
        informacionPaciente.purpose_consultation = 1;
        informacionPaciente.external_cause = self.listaCausaExterna[self.causaExternaSeleccionada].value;
        informacionPaciente.civil_status = self.listaEstadoCivil[self.estadoCivilSeleccionado].value;
        
        informacionPaciente.patient_id = MemoriaRegistroPaciente.informacionPaciente == nil ? nil : MemoriaRegistroPaciente.informacionPaciente?.patient_id;
        informacionPaciente.id = MemoriaRegistroPaciente.informacionPaciente == nil ? nil : MemoriaRegistroPaciente.informacionPaciente?.id;
        informacionPaciente.created_at = MemoriaRegistroPaciente.informacionPaciente == nil ? nil : MemoriaRegistroPaciente.informacionPaciente?.created_at;
        informacionPaciente.updated_at = MemoriaRegistroPaciente.informacionPaciente == nil ? nil : MemoriaRegistroPaciente.informacionPaciente?.updated_at;
        
        // Pendiente los id
        
        // Se almacena en la variable estática en memoria.
        MemoriaRegistroPaciente.informacionPaciente = informacionPaciente;
    }
    
    /**
     Permite guardar la información en la base de datos y continuar a la siguiente vista.
     */
    private func guardarPaciente () {
        // Si está activa la consulta lista para enviar se dirige al último paso del proceso
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
            self.present(vc, animated: true, completion: nil);
            
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_2") as! RegistroPacienteViewController2;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    
    // Comportamiento teclado para que se recupere el espacio que ocupa al aparecer
    @objc func keyboardWillShow(notification: NSNotification) {
        if (self.txtNumeroAutorizacion.isEditing) {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                // if keyboard size is not available for some reason, dont do anything
                return;
            }
            
            // move the root view up by the distance of keyboard height
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionNacimiento(_ sender: UIButton) {
        // Se incluyen los campos cuando el usuario es nuevo.
        if(MemoriaRegistroPaciente.paciente == nil) {
            self.mostrarPickerFecha();
        }
    }
    
    
    @IBAction func accionUnidadMedida(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "unit_measurement", titulo: Mensajes.CAMPO_SELECCIONAR_UNIDAD_MEDIDA);
    }
    @IBAction func accionTipoIdentificacion(_ sender: UIButton) {
        // Se incluyen los campos cuando el usuario es nuevo.
        if(MemoriaRegistroPaciente.paciente == nil) {
            self.mostrarPickerSelectores(grupo: "type_document", titulo: Mensajes.CAMPO_SELECCIONAR_TIPO_IDENTIFICACION);
        }
    }
    @IBAction func accionSexo(_ sender: UISegmentedControl) {
        self.generoSeleccionado = sender.selectedSegmentIndex;
    }
    @IBAction func accionEstadoCivil(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "civil_status", titulo: Mensajes.CAMPO_SELECCIONAR_ESTADO_CIVIL);
    }
    @IBAction func accionDepartamento(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "department", titulo: Mensajes.CAMPO_SELECCIONAR_DEPARTAMENTO);
    }
    @IBAction func accionMunicipio(_ sender: UIButton) {
        if(self.departamentoSeleccionado == 0) {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_DEPARTAMENTO);
        } else {
            self.mostrarPickerSelectores(grupo: "municipality", titulo: Mensajes.CAMPO_SELECCIONAR_MUNICIPIO);
        }
    }
    @IBAction func accionResidencia(_ sender: UISegmentedControl) {
        self.zonaResidenciaSeleccionada = sender.selectedSegmentIndex + 1;
    }
    @IBAction func accionAcompaniante(_ sender: UISwitch) {
        if (sender.isOn) {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAcompaniante, altoInicial: self.altoAcompaniante, altoAuxiliar: self.acompanianteHeightVisible, animado: true);
        } else {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaAcompaniante, altoInicial: self.altoAcompaniante, animado: true);
        }
    }
    @IBAction func accionResponsable(_ sender: UISwitch) {
        if (sender.isOn) {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaResponsable, altoInicial: self.altoResponsable, altoAuxiliar: self.responsableHeightVisible, animado: true);
        } else {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaResponsable, altoInicial: self.altoResponsable, animado: true);
        }
    }
    @IBAction func accionTipoUsuario(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "type_user", titulo: Mensajes.CAMPO_SELECCIONAR_TIPO_USUARIO);
    }
    @IBAction func accionCausaExterna(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "external_cause", titulo: Mensajes.CAMPO_SELECCIONAR_CAUSA_EXTERNA);
    }
    @IBAction func accionConsentimiento(_ sender: UISwitch) {
    }
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
                
        if (self.sonCamposCorrectos()) {
            
            // Se construye la información del paciente.
            self.capturarInformacionPaciente();
            
            // Se construye la información adicional del paciente.
            self.capturarInformacionAdicionalPaciente();
            
            // Se guarda la información y se avanza.
            self.guardarPaciente();
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        }
    }
    
    @IBAction func accionCondicion(_ sender: UIButton) {
        self.mostrarPickerSelectores(grupo: "type_condition", titulo: Mensajes.CAMPO_SELECCIONAR_CONDICION);
    }
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        
        // Se puede regresar a diferentes ventanas, por tanto se valida
        if (MemoriaHistoriaClinica.paciente == nil && MemoriaRegistroPaciente.paciente != nil) {
            // Al regresar a buscar paciente se resetean los valores almacenados en memoria.
            MemoriaRegistroConsulta.consultaMedica = nil;
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_paciente") as! PacienteViewController;
            
            self.present(vc, animated: true, completion: nil);
        } else if (MemoriaHistoriaClinica.paciente != nil && MemoriaRegistroPaciente.paciente != nil) {
            // Al regresar a consulta se resetea la variable paciente en memoria.
            MemoriaHistoriaClinica.reiniciarVariables();
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_consulta") as! ConsultaViewController;
            
            self.present(vc, animated: true, completion: nil);
        } else {
            self.dismiss(animated: true, completion: nil);
        }
                
    }
    
}

extension RegistroPacienteViewController1: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.listaUnidadMedida.count;
        case 2:
            return self.listaTipoIdentificacion.count;
        case 3:
            return self.listaEstadoCivil.count;
        case 4:
            return self.listaDepartamentos.count;
        case 5:
            return self.listaMunicipios.count;
        case 6:
            return self.listaTipoUsuario.count;
        case 7:
            return self.listaCausaExterna.count;
        case 8:
            return self.listaCondiciones.count;
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.listaUnidadMedida[row].title;
        case 2:
            return self.listaTipoIdentificacion[row].title;
        case 3:
            return self.listaEstadoCivil[row].title;
        case 4:
            return self.listaDepartamentos[row].name;
        case 5:
            return self.listaMunicipios[row].name;
        case 6:
            return self.listaTipoUsuario[row].title;
        case 7:
            return self.listaCausaExterna[row].title;
        case 8:
            return self.listaCondiciones[row].title;
        default:
            return nil;
        }
    }
    
    // Tener presente que seleccionado corresponde a la fila y no al id.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            let texto = self.listaUnidadMedida[row].title!;
            self.unidadMedidaSeleccionada = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnUnidadMedida, texto: texto);
        case 2:
            let data = self.listaTipoIdentificacion[row];
            let texto = data.title!;
            self.tipoIdentificacionSeleccionado = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnTipoIdentificacion, texto: texto);
            
            // Se valida, si selecciona adulto sin identificar o menor sin identificar se habilita condición
            if(data.value == 11 || data.value == 12) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaCondicion, altoInicial: self.altoCondicion, altoAuxiliar: self.condicionHeightVisible, animado: true);
                
                // Se aumenta el alto de la vista 2
                self.altoEdicionParte2.constant = 350;
            } else {
                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaCondicion, altoInicial: self.altoCondicion, animado: true);
                
                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaInpec, altoInicial: self.altoInpec, animado: true);

                // Se reduce el alto de la vista 2
                self.altoEdicionParte2.constant = 300;
                
                self.condicionSeleccionada = 0;
                self.btnCondicion.setTitle(Mensajes.CAMPO_SELECCIONAR, for: .normal);
                
                if (self.altoIdentificacion.constant == 0){
                    Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaIdentificacion, altoInicial: self.altoIdentificacion, altoAuxiliar: self.identificacionHeightVisible, animado: true);
                    
                    Funcionales.vaciarCamposTexto(campos: [self.txtInpec]);
                }
            }
        case 3:
            let texto = self.listaEstadoCivil[row].title!;
            self.estadoCivilSeleccionado = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnEstadoCivil, texto: texto);
        case 4:
            let texto = self.listaDepartamentos[row].name!;
            self.departamentoSeleccionado = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnDepartamento, texto: texto);
            // Cuando se selecciona un departamento, se consulta la lista de municipios asociados.
            self.listaMunicipios = FachadaIndependientesSQL.seleccionarPorDepartamento(conexion: self.conexion, idDepartamento: self.listaDepartamentos[row].id!);
            
            // Se crea un objeto municipio por defecto para anteponer la opción Seleccionar, con valor 0.
            let municipioDefault = Municipio();
            municipioDefault.name = Mensajes.CAMPO_SELECCIONAR;
            municipioDefault.id = 0;
            self.listaMunicipios.insert(municipioDefault, at: 0);
            self.btnMunicipio.setTitle(self.listaMunicipios[0].name, for: .normal);
            self.municipioSeleccionado = 0;
        case 5:
            if (self.departamentoSeleccionado > 0) {
                let texto = self.listaMunicipios[row].name!;
                self.municipioSeleccionado = row;
                Funcionales.ajustarTextoBotonSelector(boton: self.btnMunicipio, texto: texto);
            }
        case 6:
            let texto = self.listaTipoUsuario[row].title!;
            self.tipoUsuarioSeleccionado = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnTipoUsuario, texto: texto);
        case 7:
            let texto = self.listaCausaExterna[row].title!;
            self.causaExternaSeleccionada = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnCausaExterna, texto: texto);
        case 8:
            let data = self.listaCondiciones[row];
            let texto = data.title!;
            self.condicionSeleccionada = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnCondicion, texto: texto);
            
            // Se valida, si selecciona condición reclusa INPEC
            if(data.value == 10) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaInpec, altoInicial: self.altoInpec, altoAuxiliar: self.inpecHeightVisible, animado: true);
                
                if (self.altoIdentificacion.constant > 0){
                    Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaIdentificacion, altoInicial: self.altoIdentificacion, animado: true);
                    
                    Funcionales.vaciarCamposTexto(campos: [self.txtNumeroIdentificacion]);
                }
            } else {
                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaInpec, altoInicial: self.altoInpec, animado: true);
                
                if (self.altoIdentificacion.constant == 0){
                    Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaIdentificacion, altoInicial: self.altoIdentificacion, altoAuxiliar: self.identificacionHeightVisible, animado: true);
                    
                    Funcionales.vaciarCamposTexto(campos: [self.txtInpec]);
                }
            }
        default:
            break;            
        }
    }
    
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height - 50), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
