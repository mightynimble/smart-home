//
// WORKING VERSION
//


$(function () {

    var chart = new Highcharts.Chart({

            chart: {
                type: 'spline',
                animation: true,
                renderTo: 'temperatures_chart'
            },
            title: {
                text: 'System Temperature'
            },
            xAxis: {
                type: 'datetime'
//                tickPixelInterval: 150
            },
            yAxis: {
                title: {
                    text: 'Temperature (℃)'
                }
            },
            scrollbar: {
                enabled: true
            },
            series: [{
                name: 'CPU Core 1',
//                pointInterval: 60000,
                data: (function() {
                    $.getJSON(
                        '/temperatures/get_metrics?method=init_chart&interval=1',
                        function(data) {
                            var series = chart.series[0];
                            series.setData(data);
                            return data;
                        }
                    );
                })()
//                data: [[1371771646000,36]]
            }]
        },
        function (chart) {
            setInterval(function() {
                $.getJSON(
                    '/temperatures/get_metrics?method=every_1_minute',
                    function(data) {
                        var series = chart.series[0];
                        series.addPoint(data[0], true, true);
                    }
                );
            }, 32000);
        }
    );
});
