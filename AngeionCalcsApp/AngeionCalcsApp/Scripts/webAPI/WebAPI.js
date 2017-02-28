/// referenced by: CaseList.js
/// referenced by: CaseAttribute.js

var API_URL = "http://localhost:63245/api/";


function GetAll_API(component, action, object) {
    var APIType = "GET";

    $.ajax({
        url: API_URL + component,
        type: APIType,
        dataType: "json",
        success: function (object) {
            APIType = APIType + "All";
            handleSuccess(component, action, APIType, object);
        },
        error: function (request, message, error) {
            ErrMessage = "WebAPI.js::GetAll_API - " + message;
            handleException(request, ErrMessage, error);
        }
    });

}


function Get_API(component, action, object, id) {
    var APIType = "GET";

    $.ajax({
        url: API_URL + component + id,
        type: APIType,
        dataType: "json",
        success: function (object) {
            handleSuccess(component, action, APIType, object);
        },
        error: function (request, message, error) {
            ErrMessage = "WebAPI.js::Get_API - " + message;
            handleException(request, ErrMessage, error);
        }
    });

}


function Add_API(component, object) {
    var APIType = "POST";
    var objectJSON = JSON.stringify(object);

    //console.log("AddJSON: " + objectJSON);

    $.ajax({
        url: API_URL + component,
        type: APIType,
        contentType: "application/json;charset=utf-8",
        data: objectJSON,
        success: function (object) {
            handleSuccess(component, "", APIType, object);
        },
        error: function (request, message, error) {
            message = "WebAPI.js::Add_API - " + message;
            handleException(request, message, error);
        }
    });

}

function Update_API(component, object, id) {
    var APIType = "PUT";
    var objectJSON = JSON.stringify(object);

    //console.log("UpdateJSON: " + objectJSON);

    $.ajax({
        url: API_URL + component + id,
        type: APIType,
        contentType: "application/json;charset=utf-8",
        data: objectJSON,
        success: function (object) {
            handleSuccess(component, "", APIType, object);
        },
        error: function (request, message, error) {
            message = "WebAPI.js::Update_API - " + message;
            handleException(request, message, error);
        }
    });

}

function Delete_API(component, id) {
    var APIType = "DELETE";
    var objectJSON = JSON.stringify(id);

    //console.log("DeleteJSON: " + objectJSON);

    $.ajax({
        url: API_URL + component + id,
        type: APIType,
        success: function (id) {
            handleSuccess(component, "", APIType, id);
        },
        error: function (request, message, error) {
            message = "WebAPI.js::Delete_API - " + message;
            handleException(request, message, error);
        }
    });
  
}



function handleSuccess(component, action, APIType, object) {

    var objectJSON = JSON.stringify(object);

    if (component == "case/") {
        switch (APIType) {
            case "GETAll":
                CaseListSuccess(action, object);
                break;
            case "GET":
                CaseRecordGetSuccess(action, object);
                break;
            case "POST":
                CaseRecordAddSuccess(object);
                break;
            case "PUT":
                CaseRecordUpdateSuccess(object);
                break;
            case "DELETE":
                CaseRecordDeleteSuccess(object);
                break;
        }
    }
    else if (component == "caseattribute/") {
        switch (APIType) {
            case "GET":
                CaseAttributeRecordGetSuccess(action, object);
                break;
                //case "PUT":
                //    CaseRecordUpdateSuccess(object);
                //    break;
        }
    }
    else {
        console.log("handleSuccess failed if/else: component: " + component);
        console.log("handleSuccess failed if/else: APIType: " + APIType);
    }

    //console.log("responseJSON: " + objectJSON);

}


function handleException(request, message, error) {
    var msg = "";
    msg += "Code: " + request.status + "\n";
    msg += "Text: " + request.statusText + "\n";

    if (request.responseJSON != null) {
        msg += "Message" + request.responseJSON.Message + "\n";
    }

    alert(msg);
}