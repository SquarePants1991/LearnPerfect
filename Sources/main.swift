import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

func JsonResult(json: Any) -> String {
    let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    if let data = data, let str = String(data: data, encoding: .utf8) {
        return str
    }
    return ""
}

func getUser(request: HTTPRequest, response: HTTPResponse) {
    let userID = request.urlVariables["user_id"]
    response.setHeader(.contentType, value: "application/json")
    let json: [String : Any] = ["code": 0, "data": [ "id": userID, "name": "ocean", "token": "12312312312312" ]]
    response.appendBody(string: JsonResult(json: json))
    response.completed()
}

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes(baseUri: "/v1")
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    response.completed()
})

routes.add(method: .get, uri: "/user/{user_id}", handler: getUser)


// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181
server.documentRoot = "./"
do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
