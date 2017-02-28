var component = "";

var CaseRecord = {
    CaseName: "",
    CaseCode: "",
    CreatedDate: "",
    ModifiedDate: "",
    isDeleted: ""
}

var CaseAttributeRecord = {
    CaseID: "",
    CaseAttributeID: "",
    CaseAttributeTypeID: "",
    CaseAttributeValue: ""
}


function ConvertToLocalDate(DateString) {
    var DateValue = moment.utc(DateString).local();
    DateValue = DateValue.format("lll");

    if (DateString == "0001-01-01T00:00:00") {
        DateValue = "";
    }
    return DateValue;
}

var CaseListUnfiltered;
var CaseListFiltered;

function Logger(LogLabel, LogValue) {

    console.log(LogLabel + ": " + LogValue)
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

//lose focus on btn-narrow class buttons as soon as mouseup is detected
$('.btn-narrow').mouseup(function () { this.blur() });
$('.btn-default').mouseup(function () { this.blur() });