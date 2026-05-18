import Foundation
import Ignite

struct Home: StaticPage {
    var title = "ZELU"

    var body: some HTML {
        Section {
            Text("ZELU")
                .font(.title1)

            Text("Não deixe seus amigos no vácuo!")
                .font(.title2)
                .margin(.top, 6)

            Text("Uma forma simples de manter suas conexões ativas.")
                .font(.body)
                .margin(.top, 10)
        }
        .padding(.bottom, 24)

        Section {
            Text("O que o app faz")
                .font(.title2)
                .margin(.bottom, 10)

            Text("Organize seus contatos")
                .font(.title3)
                .margin(.bottom, 6)

            Text("Perfil simples para cada amigo, com notas e histórico de interações.")
                .margin(.bottom, 14)

            Text("Defina metas")
                .font(.title3)
                .margin(.bottom, 6)

            Text("Estabeleça frequência e receba lembretes.")
                .margin(.bottom, 14)

            Text("Registre momentos")
                .font(.title3)
                .margin(.bottom, 6)

            Text("Marque encontros, salve fotos e acompanhe a evolução da relação.")
        }
        .padding(.vertical, 20)

        Section {
            Text("Conheça a interface")
                .font(.title2)
                .margin(.bottom, 14)

            Image("/images/dog.jpg", description: "Foto de destaque do app")
                .resizable()
                .cornerRadius(10)
        }
        .padding(.vertical, 20)

        Section {
            Text("Participe do teste")
                .font(.title2)
                .margin(.bottom, 12)

            Text("Em breve no TestFlight. Inscreva-se para receber acesso exclusivo!")
                .margin(.bottom, 24)

            Link("Acessar o TestFlight", target: "https://testflight.apple.com/")
                .linkStyle(.button)
                .role(.primary)
        }

        Section {
            Text("© 2026 ZELU")
                .font(.body)
                .foregroundStyle(.secondary)

            Text("Desenvolvido por Cami, Dayó, Enzo, Jonas, Mathias, Thomas")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 22)
    }
}
