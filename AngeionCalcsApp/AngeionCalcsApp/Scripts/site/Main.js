$(document).ready(function () {
    var PageContentName = localStorage.getItem("pageToLoad")
    var PageToLoad = PageContentName + '.html';

    $('#PageContent').load(PageToLoad);

    if (PageContentName == 'CaseList')
    {
        
        CaseList(); //CaseList.js

    }
    else if (PageContentName == 'FileImport')
    {
        //do something
    }
    else if (PageContentName == 'eCharts') {
        //do something
    }
    else
    {
        console.log('ERR: Invalid page called [' + PageContentName + ']');
    }
    
});

function setPageContent(PageContentName) {

    localStorage.setItem("pageToLoad", PageContentName);

}

