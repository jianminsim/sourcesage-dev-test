$(function() {

    var socket = io.connect('http://' + document.domain + ':' + location.port);
    var question_id=0;

    var connected = function() {
        console.log("connected");
	socket.emit('connected', {data: 'I\'m connected!'});
    };


    socket.on('my response', function(msg) {
        	console.log("response data: ", msg.data);
		var ques_id = msg.q_id;
		
		$("#"+ques_id+"_answer").append("<br>Answer: "+ msg.data);
            });

    socket.on('my question', function(msg) {
                console.log("Question data: ", msg.data);
                var current_data = $("#data").val();
		question_id = msg.count;
		var btn_id = question_id + "_response";
		$("<div></div>").attr('id', question_id).appendTo("#log");
		$("#"+question_id).append("<br><br>Question "+ question_id+": "+ msg.data);
		$("<div></div>").attr('id', question_id+"_answer").appendTo("#log");
		var button_text_str = $("#button_text").html();
		var text= $('<input/>').attr({type: "text", id: btn_id});
		var btn = $('<input/>').attr({type: "button", id: "answer", value:"Answer"});
		$("#"+question_id).append("       ");
		$("#"+question_id).append(text);
		$("#"+question_id).append(btn);
		 
            });

    $("#create_question").click(function() {
	console.log("inside create question");
        socket.emit('my question',{data:$("#message").val(), count: question_id});
        });

    var disconnected = function() {
        console.log("disconnected");
        setTimeout(start, 1000);
    };

    $(document).on("click", '#answer', function() {
	console.log("inside answer");
	var q_id = $(this).closest('div').attr('id');
	console.log("closest div ", q_id);
	socket.emit('my response',{data:$("#"+q_id+"_response").val(), q_id:q_id});
	$("#"+q_id+"_response").val("");
	});

    var start = function() {
        socket.on('connect', connected);
        socket.on('disconnect', disconnected);
    };

    start();

});
