$(document).ready(function () {
    var PageContentName = localStorage.getItem("pageToLoad")

    $('#SideBar').load('SideBar.html');
    $('#TopNav').load('TopNav.html');
    $('#Footer').load('Footer.html');

    if (PageContentName == 'CaseList') {

        CaseList(PageContentName); //CaseList.js

    }
    else if (PageContentName == 'FileImport') {
        //do something
    }
    else if (PageContentName == 'eCharts') {
        //do something
    }
    else {
        console.log('ERR: Invalid page called [' + PageContentName + ']');
    }


});


function setPageContent(PageContentName) {

    localStorage.setItem("pageToLoad", PageContentName);

}

function CustomHTMLStyle(style) {

    //Switchery
    if (style == 'Switchery') {

        if ($(".js-switch")[0]) {
            var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
            elems.forEach(function (html) {
                var switchery = new Switchery(html, {
                    color: '#26B99A'
                });
            });
        }
    }

    //Tooltip
    if (style == 'Tooltip') {
        $('[data-toggle="tooltip"]').tooltip({
            container: 'body'
        });
    }
}