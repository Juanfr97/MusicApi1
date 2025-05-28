import Fluent
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class Album: Model, @unchecked Sendable {
    static let schema = "albums"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "artist")
    var artist: String

    @Field(key: "description")
    var description: String

    @Field(key: "image")
    var image: String

    init() { }

    init(id: UUID? = nil, title: String, artist: String, description: String, image: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.description = description
        self.image = image
    }
    func toDTO() -> AlbumDTO {
            .init(
                id: self.id,
                title: self.$title.value ?? "",
                artist: self.$artist.value ?? "",
                description: self.$description.value ?? "",
                image: self.$image.value ?? ""
            )
        }
    
}
