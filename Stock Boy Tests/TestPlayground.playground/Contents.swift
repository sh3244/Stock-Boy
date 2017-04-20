//: Playground - noun: a place where people can play

import UIKit
import Just

var str = "Hello, playground"

let parama = "\"username\":\"sh3244\",\"password\":\"5ezypqj9omp\""
let param = [
  "username": "sh3244",
  "password": "5ezypqj9omp"
]

let url = "https://api.robinhood.com/api-token-auth/"

let json = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)

var finished: Bool = false
DispatchQueue.global().async {
  var request = URLRequest.init(url: URL(string: url)!)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.httpBody = json

  let session = URLSession.shared

  session.dataTask(with: request) {data, response, err in
    print(response, String(data: data!, encoding: String.Encoding.utf8))
    finished = true
    }.resume()
}

while !finished {

}




