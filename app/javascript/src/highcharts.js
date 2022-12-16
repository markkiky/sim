// highchart import
import Highcharts from "highcharts";
require("highcharts/modules/data")(Highcharts)
require("highcharts/modules/drilldown")(Highcharts)
require("highcharts/modules/exporting")(Highcharts)
require("highcharts/modules/export-data")(Highcharts)
require("highcharts/modules/offline-exporting")(Highcharts)
require("highcharts/modules/accessibility")(Highcharts)
window.Highcharts = Highcharts;

const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'KES',
    // These options are needed to round to whole numbers if that's what you want.
    //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
    //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
});

$(function () {
    Highcharts.chart('container', {
        chart: {
            type: 'column'
        },
        title: {
            align: 'left',
            text: 'Annual Payment Report.'
        },
        subtitle: {
            align: 'left',
            text: 'Click the columns to view daily report'
        },
        accessibility: {
            announceNewData: {
                enabled: true
            }
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            gridLineColor: '#95aac9',
            gridLineDashStyle: 'ShortDot',
            gridLineWidth: 0.3,
            min: 0,

            title: {
                text: 'Money In KES',
                style: {
                    color: '#12263f'
                }

            },
            stackLabels: {
                enabled: false,
                style: {
                    fontWeight: 'bold',
                    color: '#12263f'
                }
            }

        },
        legend: {
            enabled: true,
            borderWidth: 1,
            backgroundColor: 'transparent',
            itemStyle: {
                color: '#95aac9',
                font: '600 12px "Muli", sans-serif'
            },
            itemHoverStyle: {
                color: '#12263f',
                font: '600 12px "Muli", sans-serif'
            },
        },



        plotOptions: {
            column: {
                stacking: 'normal',
                grouping: false,
                pointPadding: 0.2,
                borderWidth: 0,
                dataLabels: {
                    enabled: false
                },
                states: {
                    hover: {
                        enabled: false
                    }
                },
            },
            series: {
                pointWidth: 15,
                borderWidth: 0,
                borderColor: 'black',

                dataLabels: {
                    enabled: true,
                    format: '{point.y:.1f} KES',
                    style: {
                        color: 'white',
                        // textShadow: '0 0 2px black, 0 0 2px black'
                    },
                    stacking: 'normal'
                }

            },
        },

        tooltip: {
            headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
            pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y} KES</b> of total<br/>'
        },

        series: [
            {
                name: "In",
                color: '#A6C5F7', //Blue
                data: gon.annual_in
            },
            {
                name: "Out",
                color: '#ff3301', // Orange
                data: gon.annual_out
            }
        ],
        drilldown: {
            activeDataLabelStyle: {
                color: 'white',
                textShadow: '0 0 2px black, 0 0 2px black'
            },
            breadcrumbs: {
                position: {
                    align: 'right'
                }
            },
            series: gon.drilldown
        }
    });
})

