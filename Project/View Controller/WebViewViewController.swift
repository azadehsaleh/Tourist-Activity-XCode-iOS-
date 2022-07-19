import UIKit
import WebKit


class WebViewViewController: UIViewController, WKNavigationDelegate {
    var defaults = UserDefaults.standard
    var currentActivityLink:String = ""
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URL(string: currentActivityLink)!
        webView.navigationDelegate = self
        webView.load(URLRequest(url: request))
        webView.allowsBackForwardNavigationGestures = true
        print("Done")
     
        // programatically add a navigation bar Logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
    }
    
    @objc func logoutButtonPressed() {
        print("Logout button pressed")
        guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as? ViewController else {
            print("Cannot find Login screen")
            return
        }
        defaults.removeObject(forKey: "loggedIn")
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    //MARK:- WKNavigationDelegate Methods
      //Equivalent of shouldStartLoadWithRequest:
          func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
              var action: WKNavigationActionPolicy?
   
              defer {
                  decisionHandler(action ?? .allow)
              }
   
              guard let url = navigationAction.request.url else { return }
              print("decidePolicyFor - url: \(url)")
   
              //Uncomment below code if you want to open URL in safari
              
//              if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("https:developer.apple.com/") {
//                  action = .cancel   //Stop in WebView
//                  UIApplication.shared.open(url)
//              }
            
          }
   
          //Equivalent of webViewDidStartLoad:
          func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
              print("didStartProvisionalNavigation - webView.url: \(String(describing: webView.url?.description))")
          }
   
          //Equivalent of didFailLoadWithError:
          func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
              let nserror = error as NSError
              if nserror.code != NSURLErrorCancelled {
                  webView.loadHTMLString("Page Not Found", baseURL: URL(string: "https://developer.apple.com/"))
              }
          }
   
          //Equivalent of webViewDidFinishLoad:
          func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
              print("didFinish - webView.url: \(String(describing: webView.url?.description))")
          }


}
