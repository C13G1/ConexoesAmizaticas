import Foundation
import Ignite

@main
struct IgniteWebsite {
    static func main() async {
        var site = ZeluSite()
        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ZeluSite: Site {
    var name = "Zelu"
    var url = URL(static: "https://c13g1.github.io/ConexoesAmizaticas/")
    var homePage = Home()
    var layout = MainLayout()
}
