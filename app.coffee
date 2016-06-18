express = require 'express'
MongoClient = require('mongodb').MongoClient
Python = require './python'
app = express()

dbName = process.argv[2]

MongoClient.connect "mongodb://localhost:27017/#{dbName}", (err, db) ->

	throw err if err

	console.log 'connected'

	app.use express.static 'public'
	app.use require('body-parser').json()

	app.post '/', (req, res) ->

		searchQuery = req.body.query

		query =
			'$text':
				'$search': "\"#{searchQuery}\""
		fields =
			'_id': false
			'price': true
		db.collection('annonces')
			.find query, fields
			.toArray (err, docs) ->
				throw err if err

				values = docs.map (v) -> v.price
				values = values.filter (v) -> v > 0

				Python.density values, (pyRes) ->
					res.send pyRes

	app.listen(8080)