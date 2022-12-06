//
//  Gestos.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 26/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class Gestos: NSObject {
    class func ocultarTeclado(seflView: UIView, view: UIView) {
        let tap = UITapGestureRecognizer.init(target: seflView, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap);
    }
}
