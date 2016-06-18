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

					max =
						index: 0
						value: data[0][1]
					for v, i in data
						if v[1] > max.value
							max.value = v[1]
							max.index = i

					for v, i in data
						if i == max.index
							data[i] = [v[0], v[1], numeral(v[0]).format('0,0.00')+ ' €']
						else
							data[i] = [v[0], v[1], null]

					gData = new google.visualization.DataTable()
					gData.addColumn 'number', 'Price'
					gData.addColumn 'number', 'Density'
					gData.addColumn
						type: 'string'
						role: 'annotation'
					gData.addRows data

					#gData = google.visualization.arrayToDataTable data

					options =
					  title: 'Company Performance'
					  curveType: 'function'
					  legend:
					  	position: 'bottom'

					chart = new google.visualization.LineChart document.getElementById 'curve_chart'
					chart.draw gData, options