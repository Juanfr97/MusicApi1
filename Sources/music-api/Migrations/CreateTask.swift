import Fluent

struct CreateTasks: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("tasks")
            .id()
            .field("title", .string, .required)
            .field("image", .custom("VARCHAR(500)"), .required)
            .field("description", .string, .required)
            .field("artist", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("tasks").delete()
    }
}