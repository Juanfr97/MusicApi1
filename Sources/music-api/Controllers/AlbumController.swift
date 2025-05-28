
import Vapor
import Fluent

struct AlbumDTO: Content {
    var id: UUID?
    var title: String
    var artist: String
    var description: String
    var image: String
}

extension AlbumDTO {
    func toModel() -> Album {
        Album(
            id: self.id,
            title: self.title,
            artist: self.artist,
            description: self.description,
            image: self.image
        )
    }
}



struct AlbumController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let albums = routes.grouped("albums")

        albums.get(use: self.index)
        albums.post(use: self.create)
        albums.group(":albumID") { album in
            album.get(use: self.get)
            album.put(use: self.update)
            album.delete(use: self.delete)
        }
    }

        func index(req: Request) async throws -> [AlbumDTO] {
            try await Album.query(on: req.db).all().map { $0.toDTO() }
        }

    func create(req: Request) async throws -> AlbumDTO {
        let dto = try req.content.decode(AlbumDTO.self)
        let album = dto.toModel()
        try await album.save(on: req.db)
        return album.toDTO()
    }

    func get(req: Request) async throws -> AlbumDTO {
        guard let album = try await Album.find(req.parameters.get("albumID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return album.toDTO()
    }

    func update(req: Request) async throws -> AlbumDTO {
        let dto = try req.content.decode(AlbumDTO.self)
        guard let album = try await Album.find(req.parameters.get("albumID"), on: req.db) else {
            throw Abort(.notFound)
        }

        album.title = dto.title
        album.artist = dto.artist
        album.description = dto.description
        album.image = dto.image

        try await album.save(on: req.db)
        return album.toDTO()
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let album = try await Album.find(req.parameters.get("albumID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await album.delete(on: req.db)
        return .noContent
    }
}
