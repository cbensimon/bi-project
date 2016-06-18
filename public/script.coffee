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

					data.unshift ['Price', 'Density']

					gData = google.visualization.arrayToDataTable data

					options =
					  title: 'Company Performance'
					  curveType: 'function'
					  legend:
					  	position: 'bottom'

					chart = new google.visualization.LineChart document.getElementById 'curve_chart'
					chart.draw gData, options