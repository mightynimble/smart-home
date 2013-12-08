/**
 * Created with JetBrains RubyMine.
 * User: server
 * Date: 12/8/13
 * Time: 1:28 PM
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function () {
    $("#torrent-btn-10").click(function () {
        $(this).addClass("active");
        $("#torrent-btn-all").removeClass("active");
        $("#torrent-btn-active").removeClass("active");
    });

    $("#torrent-btn-all").click(function () {
        $(this).addClass("active");
        $("#torrent-btn-10").removeClass("active");
        $("#torrent-btn-active").removeClass("active");
    });

    $("#torrent-btn-active").click(function () {
        $(this).addClass("active");
        $("#torrent-btn-10").removeClass("active");
        $("#torrent-btn-all").removeClass("active");
    });
})