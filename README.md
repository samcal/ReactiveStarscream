# ReactiveStarscream

ReactiveStarscream is a conforming WebSocket ([RFC 6455](http://tools.ietf.org/html/rfc6455)) client library in Swift for iOS and OSX, that uses RAC 3.0 signals.


## Features

- Conforms to all of the base [Autobahn test suite](http://autobahn.ws/testsuite/).
- Nonblocking. Everything happens in the background, thanks to GCD.
- Simple reactive design
- TLS/WSS support.
- Simple concise codebase at just a few hundred LOC.

## Example

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import ReactiveStarscream
```

Once imported, you can open a connection to your WebSocket server.

```swift
var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/"))
socket.connect()
```

In order to read data and text from the WebSocket, use the two public `Signal`s
from the WebSocket class. `socket.dataEvents: Signal<NSData, NSError>` and
`socket.textEvents: Signal<String, NSError>`. The `Signal` will carry the
information that the WebSocket receives, and will send `Completed` and `Error`
events as appropriate.

### writeData

The writeData method gives you a simple way to send `NSData` (binary) data to the server.

```swift
self.socket.writeData(data) //write some NSData over the socket!
```

### writeString

The writeString method is the same as writeData, but sends text/string.

```swift
self.socket.writeString("Hi Server!") //example on how to write text over the socket!
```

### writePing

The writePing method is the same as writeData, but sends a ping control frame.

```swift
self.socket.writePing(NSData()) //example on how to write a ping control frame over the socket!
```

### disconnect

The disconnect method does what you would expect and closes the socket.

```swift
self.socket.disconnect()
```

### isConnected

Returns if the socket is connected or not.

```swift
if self.socket.isConnected {
  // do cool stuff.
}
```

### Custom Headers

You can also override the default websocket headers with your own custom ones like so:

```swift
socket.headers["Sec-WebSocket-Protocol"] = "someother protocols"
socket.headers["Sec-WebSocket-Version"] = "14"
socket.headers["My-Awesome-Header"] = "Everything is Awesome!"
```

### Protocols

If you need to specify a protocol, simple add it to the init:

```swift
//chat and superchat are the example protocols here
var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/"), protocols: ["chat","superchat"])
socket.delegate = self
socket.connect()
```

### Self Signed SSL and VOIP

There are a couple of other properties that modify the stream:

```swift
var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/"), protocols: ["chat","superchat"])

//set this if you are planning on using the socket in a VOIP background setting (using the background VOIP service).
socket.voipEnabled = true

//set this you want to ignore SSL cert validation, so a self signed SSL certificate can be used.
socket.selfSignedSSL = true
```

### SSL Pinning

SSL Pinning is also supported in ReactiveStarscream. 

```swift
var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/"), protocols: ["chat","superchat"])
let data = ... //load your certificate from disk
socket.security = Security(certs: [SSLCert(data: data)], usePublicKeys: true)
//socket.security = Security() //uses the .cer files in your app's bundle
```
You load either a `NSData` blob of your certificate or you can use a `SecKeyRef` if you have a public key you want to use. The `usePublicKeys` bool is whether to use the certificates for validation or the public keys. The public keys will be extracted from the certificates automatically if `usePublicKeys` is choosen.

### Custom Queue

A custom queue can be specified when delegate methods are called. By default `dispatch_get_main_queue` is used, thus making all delegate methods calls run on the main thread. It is important to note that all WebSocket processing is done on a background thread, only the delegate method calls are changed when modifying the queue. The actual processing is always on a background thread and will not pause your app.

```swift
var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/"), protocols: ["chat","superchat"])
//create a custom queue
socket.queue = dispatch_queue_create("com.vluxe.starscream.myapp", nil)
```

## Example Project

Check out the SimpleTest project in the examples directory to see how to setup a simple connection to a WebSocket server.

## Requirements

ReactiveStarscream works with iOS 7/OSX 10.9 or above. It is recommended to use iOS 8/10.10 or above for Cocoapods/framework support.

## Installation

### Carthage

To use ReactiveStarscream in your project add the following 'Cartfile' to your project

	github "samcal/ReactiveStarscream"

Then run:

    carthage install

### Rogue

First see the [installation docs](https://github.com/acmacalister/Rogue) for how to install Rogue.

To install ReactiveStarscream run the command below in the directory you created the rogue file.

```
rogue add https://github.com/daltoniam/starscream
```

Next open the `libs` folder and add the `ReactiveStarscream.xcodeproj` to your Xcode project. Once that is complete, in your "Build Phases" add the `ReactiveStarscream.framework` to your "Link Binary with Libraries" phase. Make sure to add the `libs` folder to your `.gitignore` file.

### Other

Simply grab the framework (either via git submodule or another package manager).

Add the `ReactiveStarscream.xcodeproj` to your Xcode project. Once that is complete, in your "Build Phases" add the `ReactiveStarscream.framework` to your "Link Binary with Libraries" phase.

### Add Copy Frameworks Phase

If you are running this in an OSX app or on a physical iOS device you will need to make sure you add the `ReactiveStarscream.framework` to be included in your app bundle. To do this, in Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar. In the tab bar at the top of that window, open the "Build Phases" panel. Expand the "Link Binary with Libraries" group, and add `ReactiveStarscream.framework`. Click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `ReactiveStarscream.framework` respectively.

## TODOs

- [ ] Complete Docs
- [ ] Add Unit Tests

## License

ReactiveStarscream is licensed under the Apache v2 License.

## Contact

### Dalton Cherry
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com

### Austin Cherry ###
* https://github.com/acmacalister
* http://twitter.com/acmacalister
* http://austincherry.me
