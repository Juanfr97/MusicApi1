import Fluent
import Vapor

func routes(_ app: Application) throws {
app.get { req async in
        "It worksss!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    try app.register(collection: AlbumController())
}
