MongoClient = require('mongodb').MongoClient

dbName = process.argv[2]
dbNameDest = process.argv[3]

locations = {}

MongoClient.connect "mongodb://localhost:27017/#{dbName}", (err, db) ->

	annonces2 = db.collection('annonces2')
	cursor = db.collection('annonces').find()
	cursor.each (err, doc) ->
		throw err if err

		if doc == null
			console.log 'Over'
			return
		else if doc.location.match /paris/i
			doc.location = 'Paris'
		else if doc.location.match /\//
			doc.location = doc.location.match(/\/\s*(.*)/)[1]

		annonces2.insertOne doc