print = console.log
Async = require 'async'
Series = require 'smart-async'
MongoClient = require('mongodb').MongoClient
Xray = require 'x-ray'
x = Xray
	filters:
		trim: (value) ->
			if typeof value == 'string'
				value.replace(/\s{2,}/g, ' ').trim()
			else
				value
		parseInt: (value) -> parseInt value.replace(/\s/g, '') || -1
		category: (value) -> value.replace(/\(pro\)/, '')

N = process.argv[3]
dbName = process.argv[2]

Series [

	->
		MongoClient.connect "mongodb://localhost:27017/#{dbName}", @_then()

	(err, db) ->
		@_error err

		base_url = 'https://www.leboncoin.fr/annonces/offres/ile_de_france'

		q = Async.queue (i, callback) ->

			print "#{i} / #{N}"
			url = "#{base_url}?o=#{i}"
			Series [
				->
					x(url, '.mainList .tabsContent ul li', [{
						title: '.item_title | trim'
						price: '.item_price | parseInt'
						date: 'aside .item_supp | trim'
						category: '.item_title + .item_supp | category | trim'
						location: '.item_title + .item_supp + .item_supp | trim'
						nbImages: '.item_imageNumber span | parseInt'
					}])(@_then())
					print 'requesting...'
				(err, obj) ->
					@_error err
					if obj and obj.length
						db.collection('annonces').insert obj, @_then()
					else
						@_end()
					print 'inserting...'
				(err, res) ->
					@_error err
					print res.result
					setTimeout @_end(), 0
			], (err) ->
				console.log err if err
				callback()

		q.drain = -> print 'All pages Added'
		q.push [N..1]


], (err) ->
	throw err