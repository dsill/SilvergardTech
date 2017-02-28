/// references: WebAPI.js


// Handle click event on Update button
//function updateClick() {
//    // Build Case object from inputs
//    CaseRecord = new Object();
//    CaseRecord.CaseName = $("#CaseName_tb").val();
//    CaseRecord.CaseCode = $("#CaseCode_tb").val();

//    if ($("#CaseSave_btn").text().trim() == "Create") {
//        CaseRecordAdd(CaseRecord);
//    }
//    else {
//        CaseRecordUpdate(CaseRecord);
//    }

//}


// Handle click event on Clear button
//function clearClick() {
//    formClear();
//}

function CaseAttributeModalList_Get(obj) {
    var CaseID = $(obj).data("id");
    var action = $(obj).data("action");

    // Call Web API to get a list of CaseAttributes
    CaseAttributeAPIGet(action, CaseID);

    
}



function CaseAttributeAPIGet(action, CaseID) {
    // Call Web API to get a list of CaseAttributes
    component = "caseattribute/";
    Get_API(component, action, CaseAttributeRecord, CaseID);

}

//function CaseRecordAdd(CaseAttributeRecord) {

//    Add_API(component, CaseAttributeRecord);
//}

//function CaseRecordUpdate(CaseAttributeRecord) {
//    var CaseID = $CaseAttributeRecord.CaseID;

//    // Call Web API to update selected record
//    Update_API(component, CaseRecord, CaseID);
//}

//function CaseRecordDelete(CaseID) {
//    // Get CaseID from data- attribute
//    var CaseID = $(CaseID).data("id");

//    bootbox.confirm({
//        size: "small",
//        message: "Are you sure you want to delete this case?",
//        buttons: {
//            cancel: {
//                label: '<i class="fa fa-times"></i> Cancel'
//            },
//            confirm: {
//                label: '<i class="fa fa-check"></i> Confirm'
//            }
//        },
//        callback: function (result) {
//            console.log('This was logged in the callback: ' + result);

//            if (result == true) {
//                // Call Web API to delete selected record
//                Delete_API(component, CaseID);
//            }
//        }
//    });


//}




function CaseAttributeRecordGetSuccess(action, CaseAttributeObject) {

    
    //console.log("CaseAttributeObject3: " + CaseAttributeList)

    ////Set CaseAttributeList header text
    //$("#CaseModalContent").html(CaseAttributeHeaderHtml(CaseAttributeRecord));

    ////Clear CaseAttributeList html from prior load
    //CaseModalContentEmpty();

    //// Iterate over the collection of data
    //$.each(CaseAttributeRecord, function (index, CaseAttributeRecord) {
    //    // Add a row to the CaseAttribute table
    //    CaseAttributeListBuild(CaseAttributeRecord);
    //});

    if (action == "CaseAttributeSetup")
    {
        CaseAttributeSettingsModal_Build(CaseAttributeObject);
    }
}

function CaseAttributeSettingsModal_Build(CaseAttributeObject) {

    //Set CaseAttributeList header text
    $("#CaseModalHeader").text("Case Attributes");
    //$("#myModalLabel").text("Case Attributes - " + CaseRecord.CaseName);

    //Clear CaseAttributeList html from prior load
    CaseModalContentEmpty();

    //Add Sub Header
    $("#CaseModalSubHeader").append("<div class='clearfix'></div>");
    
    // Iterate over the collection of data
    $.each(CaseAttributeObject, function (index, CaseAttributeRecord) {
        // Add a row to the CaseAttribute table
        CaseAttributeListBuild(CaseAttributeRecord);
    });

    //Switchery
    CustomHTMLStyle('Switchery');
    
}

function CaseAttributeListBuild(CaseAttributeRecord) {
    
    $("#CaseModalContent").append(CaseAttributeListHtml(CaseAttributeRecord));

}


function CaseAttributeListHtml(CaseAttributeRecord) {

    var CaseAttributeValue = "";
    var rowHtml = "";
    var isChecked = "";

    if (CaseAttributeRecord.CaseAttributeValue) {
        CaseAttributeValue = CaseAttributeRecord.CaseAttributeValue;
    }

    var labelHtml = "<div class='form-group'><label class='control-label col-md-6 col-sm-6 col-xs-12'>" + CaseAttributeRecord.CaseAttributePrompt + "</label>";
    var divBeginHtml = "<div class='col-md-4 col-sm-4 col-xs-12'>";
    var inputHtml = "<input type='text' class='form-control' value='" + CaseAttributeValue + "' />";
    var divEndHtml = "</div></div>";

    //if question is yes/no
    if (CaseAttributeRecord.isBool == 1) {

        if (CaseAttributeValue == "1")
        {
            inputHtml = "<label>No <input type='checkbox' class='js-switch' checked /> Yes</label>";
        }
        else
        {
            inputHtml = "<label>No <input type='checkbox' class='js-switch' /> Yes</label>";
        }

        console.log("CaseAttributeID: " + CaseAttributeRecord.CaseAttributeID + ", isBool: " + CaseAttributeRecord.isBool + ", CaseAttributeValue: " + CaseAttributeRecord.CaseAttributeValue + ", CaseAttributeValue(set): " + CaseAttributeValue);
    }


    rowHtml = labelHtml + divBeginHtml + inputHtml + divEndHtml;

    return rowHtml;
}


function CaseAttributeHeaderHtml(CaseAttributeRecord) {

    var html = "";

    html = "<h2>[CaseName] <small>[some case specific text]</small></h2>";

    return html;
}



//function CaseAttributeRecordAddSuccess(CaseAttributeRecord) {

//    CaseAttributeRecordTableReload()
//}

//function CaseAttributeRecordSuccess(CaseAttributeRecord) {

//    CaseAttributeRecordTableReload()
//}

//function CaseAttributeRecordDeleteSuccess(CaseID) {

//    CaseAttributeRecordTableReload()
//}



//function CaseAttributeRecordToFields(CaseAttributeRecord) {
//    $("#CaseName_tb").val(CaseRecord.CaseName);
//    $("#CaseCode_tb").val(CaseRecord.CaseCode);
//}


//function formClear() {
//    $("#CaseName_tb").val("");
//    $("#CaseCode_tb").val("");

//    // Change Update Button Text
//    $("#CaseSave_btn").text("Create");
//}


//function DateInitialize() {

//    $('#CaseListStartDateFilter_cal').daterangepicker({
//        singleDatePicker: true,
//        calender_style: "picker_4"
//    }, function (start, end, label) {
//        console.log(start.toISOString(), end.toISOString(), label);
//    });

//    $('#CaseListEndDateFilter_cal').daterangepicker({
//        singleDatePicker: true,
//        calender_style: "picker_4"
//    }, function (start, end, label) {
//        console.log(start.toISOString(), end.toISOString(), label);
//    });

//}

