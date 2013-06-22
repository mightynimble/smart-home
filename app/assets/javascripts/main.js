$(document).ready(function () {
    $('.nav-list li').click(function(e) {
        $('.nav-list li').removeClass('active');
        var $this = $(this);
        if (!$this.hasClass('active')) {
            $this.addClass('active');
        }
    });
})