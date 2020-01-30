# Godot - JS gateway

A gateway that helps communicate between Godot app exported as HTML5 and JS application, that holds the Godot app.

It's made via one singleton script: GodotGateway, and one helping singleton: JS_API, that provides some functions for better communication into JavaScript.

All code is based on the JavaScript singleton from official Godot Engine: [read the docs](https://docs.godotengine.org/en/3.2/classes/class_javascript.html)

JavaScript side of the code was inspired by thread on [Godot's questions](https://godotengine.org/qa/23735/possible-call-gdscript-function-javascript-project-export)
