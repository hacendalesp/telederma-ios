//
//  WebViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 20/10/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var webView: WKWebView!
    
    var url: String!;
    var titulo: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: self.url)!
        webView.load(URLRequest(url: url));
        webView.allowsBackForwardNavigationGestures = false;
        
        self.header.title = self.titulo;
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
    
}
