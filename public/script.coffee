google.charts.load('current', {'packages':['corechart']})

$ ->

	$form = $('#search-form')

	$form.submit (e) ->
		e.preventDefault()

		button = $form.find('[type=submit]')
		button.button 'loading'
		query = $form.find('#query').val()
		$.ajax
			type: 'POST'
			contentType: 'application/json'
			url: '/'
			data: JSON.stringify
				query: query
			success: (data) ->

				button.button 'reset'

				google.charts.setOnLoadCallback ->

					categories = data.categories
					categories.unshift ['Category', 'Count']

					gData = google.visualization.arrayToDataTable categories

					options =
						title: 'Répartition des catégories'
						reverseCategories: true
						sliceVisibilityThreshold: .05

					chart = new google.visualization.PieChart document.getElementById 'category_chart'
					chart.draw gData, options

					google.visualization.events.addListener chart, 'onmouseover', (e) ->
						console.log categories[e.row+1][0]

				google.charts.setOnLoadCallback ->

					locations = data.locations
					locations.unshift ['Location', 'Nombre d\'annonces']

					gData = google.visualization.arrayToDataTable locations

					options =
						title: 'Répartition des départements'

					chart = new google.visualization.ColumnChart document.getElementById 'location_chart'
					chart.draw gData, options

				google.charts.setOnLoadCallback ->

					density = data.density

					for v, i in density
						if v[2] == 0
							v[2] = null
						else
							v[2] = numeral(v[0]).format('0,0.00')+ ' €'

					gData = new google.visualization.DataTable()
					gData.addColumn 'number', 'Price'
					gData.addColumn 'number', 'Density'
					gData.addColumn
						type: 'string'
						role: 'annotation'
					gData.addRows density

					options =
					  title: 'Répartition des prix'
					  curveType: 'function'
					  legend:
					  	position: 'bottom'

					chart = new google.visualization.LineChart document.getElementById 'curve_chart'
					chart.draw gData, options