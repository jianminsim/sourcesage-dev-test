$(document).ready(function(){

    $('.comment_submit').on('click', function() {
        var raiser = $(this).prev();
        var comment = $(this).parent().prev().children();
        var pointTo = $(this).val();
        if (raiser.val() && comment.val()) {
            send_comment(raiser, comment, pointTo);
        } else {
            alert("Please fill in both your name and the comment")
        }
        clear(raiser, comment);
    });

    function clear(raiser, comment){
        raiser.val("");
        comment.val("");
    }

    function send_comment(raiser, comment, pointTo) {
        var data = {
            "raiser": raiser.val(),
            "comment": comment.val(),
            "pointQ": pointTo
        };
        $.ajax({
            url: '/answer_form/',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function() {
                window.location.href = "/";
            }
        });
    }



});