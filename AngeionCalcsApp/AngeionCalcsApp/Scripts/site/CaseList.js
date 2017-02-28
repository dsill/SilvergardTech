/// references: WebAPI.js

// Handle click event on Update button
function CreateClick(obj) {
    // Build Case object from inputs
    CaseRecord = new Object();
    CaseRecord.CaseName = $("#CaseName_tb").val();
    CaseRecord.CaseCode =$("#CaseCode_tb").val();

    CaseRecordAdd(CaseRecord);
    $('#CaseModal').modal('toggle');
}

function UpdateClick(obj) {
    // Build Case object from inputs
    CaseRecord = new Object();
    CaseRecord.CaseName = $("#CaseName_tb").val();
    CaseRecord.CaseCode = $("#CaseCode_tb").val();

    CaseRecordUpdate(CaseRecord);
    $('#CaseModal').modal('toggle');

}

// Handle click event on Clear button
function clearClick(obj) {
    console.log("clearClick() fired");
    formClear();

    if (obj.id = "CaseModalClear_btn") {
        $("#CaseModalClear_btn").prop("disabled", true);
        $("#CaseModalSave_btn").prop("disabled", true);
    }
}

function CaseList(action) {
    // Call Web API to get a list of Cases
    component = "case/";
    GetAll_API(component, action, CaseRecord);

    
}

function CaseRecordGet(obj) {
    // Get CaseID from data- attribute
    var CaseID = $(obj).data("id");
    var action = $(obj).data("action");

    // Store CaseID in hidden field
    $("#CaseID_hf").val(CaseID);

    // Call Web API to get a list of Cases
    component = "case/";
    Get_API(component, action, CaseRecord, CaseID);
}

function CaseRecordAdd(CaseRecord) {

    component = "case/";
    Add_API(component, CaseRecord);
}

function CaseRecordUpdate(CaseRecord) {
    var CaseID = $("#CaseID_hf").val();

    // Call Web API to update selected record
    component = "case/";
    Update_API(component, CaseRecord, CaseID);
}

function CaseRecordDelete(CaseID) {
    // Get CaseID from data- attribute
    var CaseID = $(CaseID).data("id");

    bootbox.confirm({
        size: "small",
        message: "Are you sure you want to delete this case?",
        buttons: {
            cancel: {
                label: '<i class="fa fa-times"></i> Cancel'
            },
            confirm: {
                label: '<i class="fa fa-check"></i> Confirm'
            }
        },
        callback: function (result) {
            console.log('This was logged in the callback: ' + result);

            if (result == true) {
                // Call Web API to delete selected record
                component = "case/";
                Delete_API(component, CaseID);
            }
        }
    });

    
}


function CaseRecordAddRow(CaseRecord) {
    // Check if <tbody> tag exists, add one if not
    if ($("#CaseList_tbl tbody").length == 0) {
        $("#CaseList_tbl").append("<tbody></tbody>");
    }

    // Append row to <table>
    $("#CaseList_tbl tbody").append(CaseListBuildTableRow(CaseRecord));

}

function CaseListBuildTableRow(CaseRecord) {
    var rowClass = "tr-deleted";
    var qtyCusip = getRandomInt(0, 5);
    

    var CusipColumnHtml = "<td class='text-center'><a href='#' data-toggle='tooltip' data-placement='right' title='Edit CUSIP&apos;s'>" + qtyCusip + "</a></td>";
    var LastColumnHtml = "<td class='last text-right'><span class='label label-danger'>Deleted</span>&nbsp;&nbsp;</td>";

    var isEditDisabled = "";
    var isSetupDisabled = "";
    var isDeleteDisabled = "";

    var EditToolTip = "data-toggle='tooltip' data-placement='top' title='Edit Case'";
    var SetupToolTip = "data-toggle='tooltip' data-placement='top' title='Setup Case Attributes'";
    var DeleteToolTip = "data-toggle='tooltip' data-placement='top' title='Delete Case'";
    
    if (qtyCusip == 0) {
        CusipColumnHtml = "<td class='text-center'><a href='#' style='color: #d9534f' data-toggle='tooltip' data-placement='right' title='Setup CUSIP&apos;s'>" + qtyCusip + " <i class='fa fa-warning'></i></a></td>";
        isSetupDisabled = "disabled";
        SetupToolTip = "";
    }


    if (CaseRecord.isDeleted == "0")
    {
        rowClass = "even pointer";

        LastColumnHtml =
            "<td class='last text-right'>" +
                    "<button type='button' " +
                        "id='CaseEdit_btn' " +
                        "onclick='CaseCreateEditModal(this);' " +
                        "class='btn-narrow-form-dark' " +
                        "data-toggle='modal'" +
                        "data-target='.bs-example-modal-lg'" +
                        "data-id='" + CaseRecord.CaseID + "' " +
                        "data-action='CaseEdit' " +
                        isEditDisabled + " >" +
                        "<span class='glyphicon glyphicon-pencil' " + EditToolTip + " />" +
                    "</button>" +
                    "<button type='button' " +
                        "id='CaseSetup_btn' " +
                        "onclick='CaseAttributeModalList_Get(this);' " +
                        "class='btn-narrow-form-dark' " +
                        "data-toggle='modal'" +
                        "data-target='.bs-example-modal-lg'" +
                        "data-id='" + CaseRecord.CaseID + "' " +
                        "data-action='CaseAttributeSetup' " +
                        isSetupDisabled + " >" +
                        "<span class='glyphicon glyphicon-cog' " + SetupToolTip + " />" +
                    "</button>" +
                    "<button type='button' " +
                        "id='CaseDelete_btn' " +
                        "onclick='CaseRecordDelete(this);' " +
                        "class='btn-narrow-form-dark' " +
                        "data-id='" + CaseRecord.CaseID + "' " +
                        isDeleteDisabled + " >" +
                        "<span class='glyphicon glyphicon-trash' " + DeleteToolTip + " />" +
                        "</button>" +
            "</td>"
    }

    var ret =
        "<tr class=" + rowClass + ">" +
            "<td>" + CaseRecord.CaseID + "</td>" +
            "<td>" + CaseRecord.CaseName + "</td>" +
            "<td>" + CaseRecord.CaseCode + "</td>" +
            CusipColumnHtml +
            "<td class='text-right'>" + ConvertToLocalDate(CaseRecord.CreatedDate) + "</td>" +
            "<td class='text-right'>" + ConvertToLocalDate(CaseRecord.ModifiedDate) + "</td>" +
            LastColumnHtml +
        "</tr>";

    return ret;
}

function CaseListSuccess(action, CaseList) {
    CaseListUnfiltered = CaseList;

    //Check filter and build table
    CaseListFilter();

    //Tooltip
    CustomHTMLStyle('Tooltip');
}


function CaseListStatusFilterChange(FilterValue) {
    var ButtonText = "";
    var html = "";

    $("#CaseListStatusFilter_dd").data("id", FilterValue);

    switch (FilterValue)
    {
        case "Active":
            ButtonText = "Show Active";
            html = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='caret'></span>"
            break;
        case "Deleted":
            ButtonText = "Show Deleted";
            html = "&nbsp;&nbsp;&nbsp;&nbsp;<span class='caret'></span>"
            break;
        case "All":
            ButtonText = "Show All";
            html = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<span class='caret'></span>"
            break;
        default:
            ButtonText = "Show Active";
            html = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='caret'></span>"
    }

    $("#CaseListStatusFilter_dd").text(ButtonText);
    $("#CaseListStatusFilter_dd").append(html)

    CaseListFilter();
}

function CaseListDateFilterChanged() {

    CaseListFilter();
}

function CaseListSortChanged(obj) {
    CaseListFilter(obj);
}

function CaseListFilter(obj) {
    var Status_filter = $("#CaseListStatusFilter_dd").data("id");
    var isDeleted = "0";

    var CreatedDate_json;
    var CreatedStartDate_filter = $("#CaseListStartDateFilter_cal").val();
    var CreatedEndDate_filter = $("#CaseListEndDateFilter_cal").val();

    var CreatedStartDate_datetime = new Date(CreatedStartDate_filter != "" ? CreatedStartDate_filter : "1/1/1900");
    var CreatedEndDate_datetime = new Date(CreatedEndDate_filter != "" ? CreatedEndDate_filter : "1/1/2099");

    //clear existing table
    CaseRecordTableClear();

    //Logger("isDeleted", isDeleted);

    //Set isDeleted value
    switch (Status_filter) {
        case "Active":
            isDeleted = "0";
            break;
        case "Deleted":
            isDeleted = "1";
            break;
        case "All":
            isDeleted = "-1";
            break;
        default:
            isDeleted = "0";
    }

    //filter json [Status]
    CaseListFiltered = CaseListUnfiltered.filter(function (CaseRecord) {
        // include in json if status criteria met
        if (isDeleted == CaseRecord.isDeleted || Status_filter == "All")
        { return true; }
        else
        { return false; }
    });

    //filter json [Created Date]
    CaseListFiltered = CaseListFiltered.filter(function (CaseRecord) {
        //make date from json a date type
        CreatedDate_json = new Date(CaseRecord.CreatedDate);

        //include in json if date criteria met
        if (CreatedDate_json >= CreatedStartDate_datetime && CreatedDate_json < CreatedEndDate_datetime)
        { return true; }
        else
        { return false; }
    });

    CaseListSortOrder(CaseListFiltered, obj);
    
}


function CaseListSortOrder(CaseListFiltered, obj) {
    var sortOrder;
    var SortColumn;
    var ColumnType;
    var CurrentSortDirection;
    var NewSortDirection;
    var HeaderSortButtons = document.getElementsByClassName("btn-narrow-header");
    var numElements = HeaderSortButtons.length;
    var isReload = 0;

    $(".fa-sort-asc").toggleClass('fa-sort-asc fa-sort');
    $(".fa-sort-desc").toggleClass('fa-sort-desc fa-sort');

    if (!obj) { //not triggered by sort click (first load or filter change)
        
        for (var i = 0; i < numElements; i++) {
            obj = HeaderSortButtons[i];
            isReload = 1;

            SortColumn = $(obj).data("id");
            ColumnType = $(obj).data("type");
            CurrentSortDirection = $(obj).data("sort");

            //break loop when there is a sort value
            if (CurrentSortDirection != "") { break; }
        }
    }
    else {
        SortColumn = $(obj).data("id");
        ColumnType = $(obj).data("type");
        CurrentSortDirection = $(obj).data("sort");

        //empty all data-sort values on re-sort
        $(".btn-narrow-header").data("sort", "");
    }

    
    if (isReload == 1) { //don't flip values on reload
        switch (CurrentSortDirection) {
            case "asc":
                NewSortDirection = CurrentSortDirection;
                $("#" + SortColumn + "Sort_icon").toggleClass('fa-sort fa-sort-asc'); //set sort icon
                break;
            case "desc":
                NewSortDirection = CurrentSortDirection;
                $("#" + SortColumn + "Sort_icon").toggleClass('fa-sort fa-sort-desc'); //set sort icon
                break;
        }
    }
    else {

        switch (CurrentSortDirection) {
            case "asc":
                NewSortDirection = "desc";
                $("#" + SortColumn + "Sort_icon").toggleClass('fa-sort fa-sort-desc'); //set sort icon
                $(obj).data("sort", "desc"); //set data-sort item
                break;
            case "desc":
                NewSortDirection = "asc";
                $("#" + SortColumn + "Sort_icon").toggleClass('fa-sort fa-sort-asc'); //set sort icon/
                $(obj).data("sort", "asc"); //set data-sort item
                break;
            default:
                NewSortDirection = "asc";
                $("#" + SortColumn + "Sort_icon").toggleClass('fa-sort fa-sort-asc'); //set sort icon/
                $(obj).data("sort", "asc"); //set data-sort item
        }
    }

    CaseListFiltered.sort(function CaseSort(a, b) {

        switch (ColumnType) {
            case "int":
                a = parseInt(a[SortColumn], 10);
                b = parseInt(b[SortColumn], 10);
                break;
            case "string":
                a = a[SortColumn].toString().toLowerCase();
                b = b[SortColumn].toString().toLowerCase();
                break;
            case "date":
                a = new Date(a[SortColumn]).getTime();
                b = new Date(b[SortColumn]).getTime();
                break;
        }

        if (NewSortDirection == "asc") {
            sortOrder = (a < b) ? -1 : (a > b) ? 1 : 0;
        }
        else {
            sortOrder = (a > b) ? -1 : (a < b) ? 1 : 0;
        }

        return sortOrder;
    });

    ProcessJSON(CaseListFiltered);
}


function ProcessJSON(CaseListFiltered) {

    // Iterate over the collection of data
    $.each(CaseListFiltered, function (index, CaseRecord) {
        // Add a row to the Product table
        CaseRecordAddRow(CaseRecord);
    });
}


function CaseRecordGetSuccess(action, CaseRecord) {

    if (action == 'CaseEdit') {

        CaseEditModalSetValues(CaseRecord);

    }

    
}

function CaseRecordAddSuccess(CaseRecord) {

    CaseRecordTableReload();
}

function CaseRecordUpdateSuccess(CaseRecord) {

    CaseRecordTableReload();
}

function CaseRecordDeleteSuccess(CaseID) {

    CaseRecordTableReload();
}

function CaseRecordTableClear() {
    $("#CaseList_tbl tbody").empty();

}

function CaseRecordTableReload() {
    var action = "CaseList";
    formClear();
    CaseRecordTableClear();
    $("#CaseList_tbl tbody").append(CaseList(action));
    
}

function CaseEditModalSetValues(CaseRecord) {

    //Set CaseModal header text
    $("#CaseModalHeader").text("Case Edit: " + CaseRecord.CaseName);

    //Set text box values
    $("#CaseName_tb").val(CaseRecord.CaseName);
    $("#CaseCode_tb").val(CaseRecord.CaseCode);


}



function formClear() {
    console.log("formClear() fired");
    $("#CaseName_tb").val("");
    $("#CaseCode_tb").val("");

}


function ClearFilterInput(obj, FilterElement) {
    var FormInput = "#" + obj;
    $(FormInput).val("");

    CaseListDateFilterChanged();

    $(FormInput).daterangepicker({
        singleDatePicker: true,
        calender_style: "picker_4"
    }, function (start, end, label) {
        console.log(start.toISOString(), end.toISOString());
        CaseListDateFilterChanged();
    });

}

function CaseCreateEditModal(obj) {
    Logger("obj", obj.id);

    //Clear CaseAttributeList html from prior load
    CaseModalContentEmpty();

    //build modal content
    CaseCreateEditModalBuild(obj);
    
}


function CaseCreateEditModalBuild(obj) {
    var action = "CaseCreate"
    $("#CaseModalContent").append(CaseCreateEditModalHtml(obj));

    if (obj.id == "CaseCreate_btn") {
        //Set CaseModal header text
        $("#CaseModalHeader").text("Case Create");

        //Set modal button properties
        $("#CaseModalSave_btn").text("Create");
        $("#CaseModalSave_btn").attr("onclick", "CreateClick(this)");
        $("#CaseModalClear_btn").prop("disabled", true);
        $("#CaseModalSave_btn").prop("disabled", true);
    }
    else {
        

        //Set modal button properties
        $("#CaseModalSave_btn").text("Update");
        $("#CaseModalSave_btn").attr("onclick", "UpdateClick(this)");
        $("#CaseModalClear_btn").prop("disabled", false);
        $("#CaseModalSave_btn").prop("disabled", false);

        //Get CaseRecord from API
        CaseRecordGet(obj);
    }

    //Set modal clear button click action
    $("#CaseModalClear_btn").attr("onclick", "clearClick(this)");

    //Assign event handlers to fields
    $("#CaseName_tb").keyup(CaseCreateEditCheckForText).focusout(CaseCreateEditCheckForText);
    $("#CaseCode_tb").keyup(CaseCreateEditCheckForText).focusout(CaseCreateEditCheckForText);
    
}


function CaseCreateEditModalHtml(obj) {

    var rowHtml = "";

    rowHtml = "<form class='form-horizontal form-label-left input_mask'>" +
                    
                    "<div class='col-md-6 col-sm-6 col-xs-6'>" +
                        "<label class='control-label' for='CaseName_tb'>Case Name:</label>" +
                    "</div>" +
                    "<div class='col-md-6 col-sm-6 col-xs-6'>" +
                        "<label class='control-label' for='CaseCode_tb'>Case Code:</label>" +
                    "</div>" +
                    "<div class='col-md-6 col-sm-6 col-xs-6 form-group has-feedback'>" +
                        "<input type='text' class='form-control has-feedback-left' id='CaseName_tb' placeholder='Case Name'>" +
                        "<span class='fa fa-edit form-control-feedback left' aria-hidden='true'></span>" +
                    "</div>" +
                    
                    "<div class='col-md-6 col-sm-6 col-xs-6 form-group has-feedback'>" +
                        "<input type='text' class='form-control has-feedback-left' id='CaseCode_tb' placeholder='Case Code'>" +
                        "<span class='fa fa-barcode form-control-feedback left' aria-hidden='true'></span>" +
                    "</div>" +
                "</form>"


    return rowHtml;
}

// Check for text in fields
function CaseCreateEditCheckForText() {
    var CaseNameFilled = false;
    var CaseCodeFilled = false;
    var isSaveDisabled = true;
    var isCancelDisabled = true;
    var CaseNameValue = $("#CaseName_tb").val();
    var CaseCodeValue = $("#CaseCode_tb").val();

    //check field contents
    if (CaseNameValue != "") { CaseNameFilled = true; }
    if (CaseCodeValue != "") { CaseCodeFilled = true; }

    //set save disabled value
    if (CaseNameFilled == true && CaseCodeFilled == true && CaseCodeValue.length >= 4) { isSaveDisabled = false; }

    //set clear disabled value
    if (CaseNameFilled == true || CaseCodeFilled == true) { isCancelDisabled = false; }

    //Set clear & save button disabled value based on field contents
    $("#CaseModalSave_btn").prop("disabled", isSaveDisabled);
    $("#CaseModalClear_btn").prop("disabled", isCancelDisabled);
}


function CaseModalContentEmpty() {
    //formClear();
    $("#CaseModalContent").empty();

}
