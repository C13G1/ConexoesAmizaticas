import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Zelu"

    var body: some HTML {
        Section {
            Image("/images/hero.png", description: "ZELU Hero")
                .resizable()
                .style(.position, "absolute")
                .style(.top, "50%")
                .style(.left, "50%")
                .style(.transform, "translate(-50%, -50%)")
                .style(.zIndex, "1")
            
            Link("", target: "https://testflight.apple.com")
                .style(.position, "absolute")
                .style(.top, "75%")
                .style(.left, "42%")
                .style(.width, "16%")
                .style(.height, "9.6%")
                .style(.borderRadius, "999px")
                .style(.cursor, "pointer")
                .style(.zIndex, "10")
                .style(.background, "transparent")
                .style(.border, "none")
        }
        .style(.position, "relative")
        .style(.width, "100%")
        .style(.height, "100vh")
        .style(.overflow, "hidden")
        .style(.margin, "0")
        .style(.padding, "0")
        .style(.background, "#1C1C1C")
    }
}
