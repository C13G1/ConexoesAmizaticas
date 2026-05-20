import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Zelu"

    var body: some HTML {
        Section {
            """
                    <style>
                      * { margin:0; padding:0; box-sizing:border-box; }
                      body, html { overflow:hidden; background:#1C1C1C; }
                    </style>
                    <div style="position:fixed; inset:0; width:100vw; height:100vh;">
                      <img src="/images/hero.png"
                           style="position:absolute; top:50%; left:50%;
                                  transform:translate(-50%,-50%);
                                  width:100%; height:100%;
                                  object-fit:contain;" />
                      <a href="https://testflight.apple.com" target="_blank"
                         style="position:absolute; top:75%; left:42%;
                                width:16%; height:9.6%;
                                border-radius:999px; display:block;
                                cursor:pointer; z-index:10;"></a>
                    </div>
                    """
        }
    }
}
