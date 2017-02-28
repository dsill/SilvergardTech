$(document).ready(function () {
    $('#CaseListStartDateFilter_cal').daterangepicker({
        singleDatePicker: true,
        calender_style: "picker_4"
    }, function (start, end, label) {
        console.log(start.toISOString(), end.toISOString());
        CaseListDateFilterChanged();
    });

    $('#CaseListEndDateFilter_cal').daterangepicker({
        singleDatePicker: true,
        calender_style: "picker_4"
    }, function (start, end, label) {
        console.log(start.toISOString(), end.toISOString());
        CaseListDateFilterChanged();
    });
});