import Factory

extension Container {
    var networkClient: Factory<NetworkClientProtocol> {
        self { @MainActor in NetworkClient() }
            .singleton
    }
}
