import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some Document {
        Body {
            """
            <style>
              * { margin: 0; padding: 0; box-sizing: border-box; }
              html, body { 
                width: 100%; 
                height: 100%; 
                overflow: hidden;
                background: #1C1C1C;
              }
              .container, .container-fluid, .ig-main-content {
                max-width: 100% !important;
                width: 100% !important;
                padding: 0 !important;
                margin: 0 !important;
              }
            </style>
            """
            content
        }
    }
}