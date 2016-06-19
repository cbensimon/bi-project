express = require 'express'
Async = require 'async'
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

		query =
			'$text':
				'$search': "\"#{req.body.query}\""

		data = {}

		Async.parallel [

			(callback) ->

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
							data.density = pyRes
							callback()

			(callback) ->
				$match =
					$match: query
				$group =
					$group:
						'_id': '$category'
						'count':
							'$sum': 1
				db.collection('annonces')
					.aggregate [$match, $group]
					.sort
						count: -1
					.toArray (err, docs) ->
						throw err if err
						categories = docs.map (v) -> [v._id, v.count]
						data.categories = categories
						callback()



		], (err) ->
			throw err if err
			res.send data

	app.listen(8080)