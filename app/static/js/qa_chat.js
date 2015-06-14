$(function() {

    var socket = io.connect('http://' + document.domain + ':' + location.port);

    var connected = function() {
	    socket.emit('connected', {data: 'I\'m connected!'});
    };


    socket.on('my response', function(msg) {
		var quesId = msg.q_id;
		$("#"+quesId+"_answer").append("<ol class='breadcrumb'><li><p class='question-response'><strong>" + msg.user_name + "</strong>: " + msg.data + "</p></li></ol>");
    });

    socket.on('my question', function(msg) {
		var questionId = msg.count;
		$("<div></div>").attr('id', questionId).appendTo("#log");
		$("#"+questionId).append("<h3 class='question-text'>" +  msg.user_name +  ": "+ msg.data+ "</h3>");
		$("<div class='tab-left-margin answer-text'></div><br>").attr('id', questionId+"_answer").appendTo("#log");
		$("#"+questionId).append("<form class='form-inline tab-left-margin answer-text'> \
		    <input type='text' class='form-control answer-text' id=" + questionId + "_response placeholder='Answer here'> \
		    <input type='button' value='Answer' class='btn btn-primary' id='answer'></form>");
    });

    $("#create_question").click(function() {
        socket.emit('my question',{data:$("#message").val()});
        $("#message").val("");
    });

    var disconnected = function() {
        setTimeout(start, 1000);
    };

    $(document).on("click", '#answer', function() {
	    var quesId = $(this).closest('div').attr('id');
	    socket.emit('my response',{data:$("#"+quesId+"_response").val(), q_id:quesId});
    	$("#"+quesId+"_response").val("");
	});

    var start = function() {
        socket.on('connect', connected);
        socket.on('disconnect', disconnected);
    };

    start();

});
