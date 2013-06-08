Highcharts.setOptions({
    global: {
        useUTC: true
    }
});

var url = '/temperatures/get_metrics?time_span=last_1_hour';
$(function () {
    $.getJSON(url, function (data) {
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: 'temperatures_chart'
            },
            title: {
                text: 'System Temperature'
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'Temperature (℃)'
                }
            },
            scrollbar: {
                enabled: true
            },
            series: data
        });
    });
});


//var temp_chart;
//console.log("var temp_chart");
//var core1_series = 0;
//
//$(function(){
//    new Highcharts.Chart({
//        chart: {
//            renderTo: 'temperatures_chart'
//        },
//        title: {
//            text: 'System Temperature'
//        },
//        xAxis: {
//            type: 'datetime'
//        },
//        yAxis: {
//            title: {
//                text: 'Temperature (℃)'
//            }
//        },
//        scrollbar: {
//            enabled: true
//        },
//        series: [{
//            name: 'cpu_core_1',
//            data: (function() {
//                // generate an array of random data
//                var data = [],
//                    time = (new Date()).getTime(),
//                    i;
//
//                for (i = -19; i <= 0; i++) {
//                    data.push({
//                        x: time + i * 1000,
//                        y: Math.random()
//                    });
//                }
//                return data;
//            })()
//        }]
//    });
//});
//
//function loadData(time_span) {
//    console.log("loaddata");
//    var url = '/temperatures/' + time_span;
//    $.getJSON (url, function(data) {
//        console.log("----" + response + "====" + core1_series);
//        temp_chart.series[core1_series].setData(response[core1_series], true);
//    });
//    $.ajax({
//        url: '/temperatures/' + time_span,
//        // on success, it returns all sets of temperature metrics: CPU, HD, Mobo, etc.
//        success: function(response) {
//            console.log("----" + response)
//            window.temp_chart.series[core1_series].setData(response[core1_series], true);
//            // call it again after 61 seconds
//            setTimeout(loadData, 61000);
//        }
//    });
//}

