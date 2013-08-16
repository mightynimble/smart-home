var process_gauge =
    $(function () {

        var chart = new Highcharts.Chart({

                chart: {
                    type: 'gauge',
                    plotBackgroundColor: null,
                    plotBackgroundImage: null,
                    plotBorderWidth: 0,
                    plotShadow: false,
                    renderTo: 'processes'
                },

                title: {
                    text: 'Total Processes'
                },

                pane: {
                    startAngle: -150,
                    endAngle: 150,
                    background: [
                        {
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#FFF'],
                                    [1, '#333']
                                ]
                            },
                            borderWidth: 0,
                            outerRadius: '109%'
                        },
                        {
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#333'],
                                    [1, '#FFF']
                                ]
                            },
                            borderWidth: 1,
                            outerRadius: '107%'
                        },
                        {
                            // default background
                        },
                        {
                            backgroundColor: '#DDD',
                            borderWidth: 0,
                            outerRadius: '105%',
                            innerRadius: '103%'
                        }
                    ]
                },

                // the value axis
                yAxis: {
                    min: 90,
                    max: 200,

                    minorTickInterval: 'auto',
                    minorTickWidth: 1,
                    minorTickLength: 10,
                    minorTickPosition: 'inside',
                    minorTickColor: '#666',

                    tickPixelInterval: 30,
                    tickWidth: 2,
                    tickPosition: 'inside',
                    tickLength: 10,
                    tickColor: '#666',
                    labels: {
                        step: 2,
                        rotation: 'auto'
                    },
                    title: {
                        text: 'Processes'
                    },
                    plotBands: [
                        {
                            from: 90,
                            to: 160,
                            color: '#55BF3B' // green
                        },
                        {
                            from: 160,
                            to: 185,
                            color: '#DDDF0D' // yellow
                        },
                        {
                            from: 185,
                            to: 200,
                            color: '#DF5353' // red
                        }
                    ]
                },

                series: [
                    {
                        name: 'Total Processes',
                        data: (function() {
                            $.getJSON(
                                '/system_metrics/total_processes',
                                function(data) {
                                    var series = chart.series[0];
                                    series.setData(data);
                                }
                            );
                        })()
                    }
                ]
            },
            function (chart) {
                setInterval(function () {
                    $.getJSON(
                        '/system_metrics/total_processes',
                        function(data) {
                            var point = chart.series[0].points[0];
                            point.update(data);                        }
                    );
                }, 120000);
            }
        );
    });



var cpu_gauge =
    $(function () {

        var chart = new Highcharts.Chart({

                chart: {
                    type: 'gauge',
                    plotBackgroundColor: null,
                    plotBackgroundImage: null,
                    plotBorderWidth: 0,
                    plotShadow: false,
                    renderTo: 'cpu'
                },

                title: {
                    text: 'CPU Usage'
                },

                pane: {
                    startAngle: -150,
                    endAngle: 150,
                    background: [
                        {
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#FFF'],
                                    [1, '#333']
                                ]
                            },
                            borderWidth: 0,
                            outerRadius: '109%'
                        },
                        {
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#333'],
                                    [1, '#FFF']
                                ]
                            },
                            borderWidth: 1,
                            outerRadius: '107%'
                        },
                        {
                            // default background
                        },
                        {
                            backgroundColor: '#DDD',
                            borderWidth: 0,
                            outerRadius: '105%',
                            innerRadius: '103%'
                        }
                    ]
                },

                // the value axis
                yAxis: {
                    min: 0,
                    max: 100,

                    minorTickInterval: 'auto',
                    minorTickWidth: 1,
                    minorTickLength: 10,
                    minorTickPosition: 'inside',
                    minorTickColor: '#666',

                    tickPixelInterval: 30,
                    tickWidth: 2,
                    tickPosition: 'inside',
                    tickLength: 10,
                    tickColor: '#666',
                    labels: {
                        step: 2,
                        rotation: 'auto'
                    },
                    title: {
                        text: 'CPU Usage'
                    },
                    plotBands: [
                        {
                            from: 0,
                            to: 30,
                            color: '#55BF3B' // green
                        },
                        {
                            from: 30,
                            to: 60,
                            color: '#DDDF0D' // yellow
                        },
                        {
                            from: 60,
                            to: 100,
                            color: '#DF5353' // red
                        }
                    ]
                },

                series: [
                    {
                        name: 'CPU Usage',
                        data: (function() {
                            $.getJSON(
                                '/system_metrics/total_cpu',
                                function(data) {
                                    var series = chart.series[0];
                                    series.setData(data);
                                }
                            );
                        })()
                    }
                ]
            },
            function (chart) {
                setInterval(function () {
                    $.getJSON(
                        '/system_metrics/total_cpu',
                        function(data) {
                            var point = chart.series[0].points[0];
                            point.update(data);                        }
                    );
                }, 120000);
            }
        );
    });



var memory_pie =
    $(function () {
       Highcharts.setOptions({
           colors: ['#ED561B', '#DDDF00', '#24CBE5', '#50B432', '#64E572', '#FF9655', '#FFF263',      '#6AF9C4']
       });
       var chart = new Highcharts.Chart({
           chart: {
               plotBackgroundColor: null,
               plotBorderWidth: null,
               plotShadow: false,
               renderTo: 'memory'
           },
           title: {
               text: 'Memory Usage'
           },
           tooltip: {
               pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
           },
           plotOptions: {
               pie: {
                   allowPointSelect: true,
                   cursor: 'pointer',
                   dataLabels: {
                       enabled: false
                   },
                   showInLegend: false
               }
           },
           series: [{
               type: 'pie',
               name: 'Browser share',
               data: (function() {
                   $.getJSON(
                       '/system_metrics/mem_usage',
                       function(data) {
                           var series = chart.series[0];
                           series.setData(data);
                       }
                   );
               })()
           }]
           },
           function (chart) {
               setInterval(function () {
                   $.getJSON(
                       '/system_metrics/mem_usage',
                       function(data) {
                           var series = chart.series[0];
                           series.setData(data);
                       }
                   );
               }, 120000);
           }
       );
    });


