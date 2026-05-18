import Foundation
import Ignite

@main
struct IgniteWebsite {
    static func main() async {
        var site = ExampleSite()

        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ExampleSite: Site {
    var name = "ZELU"
    var titleSuffix = " — Não deixe seus amigos no vácuo"
    var url = URL(static: "https://c13g1.github.io")
    var builtInIconsEnabled = true

    var author = "ZELU Team"

    var homePage = Home()
    var layout = MainLayout()
}
