using namespace sqlite;
using std::Result;

public func main() : int {
    var db_res = Database.open(":memory:");
    var Ok(db) = db_res else return 1

    var queryRes = db.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT);")
    if(queryRes is Result.Err) {
        printf("failure in query");
        return 1;
    }

    var stmt_res = db.prepare("INSERT INTO users (name) VALUES (?);");
    var Ok(stmt) = stmt_res else return 1

    if(stmt.bind_text(1, "Alice") is Result.Err) return 1
    if(stmt.step() is Result.Err) return 1

    if(stmt.reset() is Result.Err) return 1
    if(stmt.bind_text(1, "Bob") is Result.Err) return 1
    if(stmt.step() is Result.Err) return 1

    var query_res = db.prepare("SELECT id, name FROM users;");
    var Ok(query) = query_res else return 1

    loop {
        var Ok(has_row) = query.step() else return 0;
        if(!has_row) break;
        const id = query.column_int(0);
        const name = query.column_text(1);
        printf("id : %d, text : %s\n", id, name.data());
    }

    return 0
}
