$(document).ready(function(){
	$('#question-form').on('submit', function(e){
		e.preventDefault();
		if (!$('#asker').val())
			return;
		if (!$('#question').val())
			return;
		
		dataToSend = {
			asker	 	: $('#asker').val(),
			question	: $('#question').val()
		}
		var POSTdata = JSON.stringify(dataToSend);
		$.ajax({
			type	:"POST",
			url 	:"/addQ",
			contentType:"application/json",
			data	:POSTdata,
			success	: function(data){
				$('#question-list').html(data);
			},
			error : function(data){
				console.log(data);
			}
		});
	});	

	$('#answer-form').on('submit', function(e){
		e.preventDefault();
		if (!$('#answered_by').val())
			return;
		if (!$('#answer').val())
			return;
		
		dataToSend = {
			qn 			: $('#question').val(),
			written_by	: $('#answered_by').val(),
			text		: $('#answer').val()
		}
		var POSTdata = JSON.stringify(dataToSend);
		$.ajax({
			type	:"POST",
			url 	:"/addA",
			contentType:"application/json",
			data	:POSTdata,
			success	: function(data){
				$('#answer-list').html(data);
			},
			error : function(data){
				console.log(data);
			}
		});
	});	
});