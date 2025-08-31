//
//  ViewController.swift
//  Project4
//
//  Created by Ray Varkki on 2025-08-30.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{

    var webView : WKWebView!
    var progressView : UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    var goBack : UIBarButtonItem!
    var goForward : UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action : nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action : #selector(webView.reload))
        goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton,goBack, goForward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        updateNavigationButtons()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
        
        let url = URL(string: "https://www." + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    
    func updateNavigationButtons(){
        
        goBack.isEnabled = webView.canGoBack
        goForward.isEnabled = webView.canGoForward
    }
    
    @objc func openTapped(){
        
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .alert)
        for website in websites {
            
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else {
            return
        }
        guard let url = URL(string: "https://" + actionTitle) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        updateNavigationButtons()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress"){
            progressView.progress = Float(webView.estimatedProgress)
        
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites {
                if(host.contains(website)){
                    decisionHandler(.allow)
                    return
                }
            }
            let notAllowed = UIAlertController(title: "Error", message: "You can only go to websites that are displayed, when you tap on the 'open' button in the top right", preferredStyle: .alert)
            notAllowed.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(notAllowed, animated: true)
        }
        decisionHandler(.cancel)
    }
    
    
    
//    // Debug: see what’s happening
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation nav: WKNavigation!) {
//        print("➡️ started:", webView.url?.absoluteString ?? "nil")
//    }
//    func webView(_ webView: WKWebView, didFinish nav: WKNavigation!) {
//        print("✅ finished")
//    }
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation nav: WKNavigation!, withError error: Error) {
//        print("❌ provisional fail:", error)
//    }
//    func webView(_ webView: WKWebView, didFail nav: WKNavigation!, withError error: Error) {
//        print("❌ nav fail:", error)
//    }

}

