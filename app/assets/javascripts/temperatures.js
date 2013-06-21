//
// WORKING VERSION
//
//Highcharts.setOptions({
//    global: {
//        useUTC: true
//    }
//});
//
//var url = '/temperatures/get_metrics?time_span=last_1_hour';
//$(function () {
//    $.getJSON(url, function (data) {
//        var chart = new Highcharts.Chart({
//            chart: {
//                renderTo: 'temperatures_chart'
//            },
//            title: {
//                text: 'System Temperature'
//            },
//            xAxis: {
//                type: 'datetime'
//            },
//            yAxis: {
//                title: {
//                    text: 'Temperature (℃)'
//                }
//            },
//            scrollbar: {
//                enabled: true
//            },
//            series: data
//        });
//    });
//});


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
                        }
                    );
                })()
            }]
        },
        function (chart) {
            setInterval(function() {
                $.getJSON(
                    '/temperatures/get_metrics?method=every_1_minute',
                    function(data) {
                        var series = chart.series[0];
                        series.addPoint(data[0]);
                    }
                );
            }, 32000);
        }
    );
});

//
//$(function () {
//
//    var chart = new Highcharts.Chart({
//
//            chart: {
//                renderTo: 'container',
//                type: 'gauge',
//                plotBackgroundColor: null,
//                plotBackgroundImage: null,
//                plotBorderWidth: 0,
//                plotShadow: false
//            },
//
//            title: {
//                text: 'Speedometer'
//            },
//
//            pane: {
//                startAngle: -150,
//                endAngle: 150,
//                background: [{
//                    backgroundColor: {
//                        linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
//                        stops: [
//                            [0, '#FFF'],
//                            [1, '#333']
//                        ]
//                    },
//                    borderWidth: 0,
//                    outerRadius: '109%'
//                }, {
//                    backgroundColor: {
//                        linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
//                        stops: [
//                            [0, '#333'],
//                            [1, '#FFF']
//                        ]
//                    },
//                    borderWidth: 1,
//                    outerRadius: '107%'
//                }, {
//                    // default background
//                }, {
//                    backgroundColor: '#DDD',
//                    borderWidth: 0,
//                    outerRadius: '105%',
//                    innerRadius: '103%'
//                }]
//            },
//
//            // the value axis
//            yAxis: {
//                min: 0,
//                max: 200,
//
//                minorTickInterval: 'auto',
//                minorTickWidth: 1,
//                minorTickLength: 10,
//                minorTickPosition: 'inside',
//                minorTickColor: '#666',
//
//                tickPixelInterval: 30,
//                tickWidth: 2,
//                tickPosition: 'inside',
//                tickLength: 10,
//                tickColor: '#666',
//                labels: {
//                    step: 2,
//                    rotation: 'auto'
//                },
//                title: {
//                    text: 'km/h'
//                },
//                plotBands: [{
//                    from: 0,
//                    to: 120,
//                    color: '#55BF3B' // green
//                }, {
//                    from: 120,
//                    to: 160,
//                    color: '#DDDF0D' // yellow
//                }, {
//                    from: 160,
//                    to: 200,
//                    color: '#DF5353' // red
//                }]
//            },
//
//            series: [{
//                name: 'Speed',
//                data: [80],
//                tooltip: {
//                    valueSuffix: ' km/h'
//                }
//            }]
//
//        },
//        // Add some life
//        function (chart) {
//            setInterval(function () {
//                $.post('/echo/json/',{
//                        json: JSON.stringify({
//                            inc: Math.round((Math.random() - 0.5) * 20)
//                        })},
//                    function(data) {
//                        var point = chart.series[0].points[0],
//                            newVal,
//                            inc = data.inc;
//
//                        newVal = point.y + inc;
//                        if (newVal < 0 || newVal > 200) {
//                            newVal = point.y - inc;
//                        }
//
//                        point.update(newVal);
//                    });
//            }, 3000);
//        }
//    );
//});