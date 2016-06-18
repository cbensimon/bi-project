PythonShell = require 'python-shell'

density = (values, callback) ->
	options =
		mode: 'json'

	shell = new PythonShell 'density.py', options

	shell.send values

	shell.on 'message', (message) ->
		console.log message
		callback message

	shell.end (err, res) ->
		console.error err if err

module.exports =
	density: density