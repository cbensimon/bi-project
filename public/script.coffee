google.charts.load('current', {'packages':['corechart']})

$ ->

	$form = $('#search-form')

	$form.submit (e) ->
		e.preventDefault()

		query = $form.find('#query').val()
		$.ajax
			type: 'POST'
			contentType: 'application/json'
			url: '/'
			data: JSON.stringify
				query: query
			success: (data) ->

				console.log data

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

				google.charts.setOnLoadCallback ->

					density = data.density

					max =
						index: 0
						value: density[0][1]
					for v, i in density
						if v[1] > max.value
							max.value = v[1]
							max.index = i

					for v, i in density
						if i == max.index
							density[i] = [v[0], v[1], numeral(v[0]).format('0,0.00')+ ' €']
						else
							density[i] = [v[0], v[1], null]

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
					  # hAxis:
					  # 	minValue: 0
					  # 	maxValue: 10000
					  legend:
					  	position: 'bottom'

					chart = new google.visualization.LineChart document.getElementById 'curve_chart'
					chart.draw gData, options