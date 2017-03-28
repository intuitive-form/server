/**
 * Created by Lena Lebedeva on 28.03.2017.
 */
function checkCompulsoryFields(page) {
    var children = $(page).find(".compulsoryField");
    var condition = true;
    for (var i = 0; i < children.length; i++){
        if (children[i].value == ""){
            $(children[i]).parent().addClass("has-error");
            if ($(children[i]).parent().find($(".alert")).length == 0) {
                $(children[i]).parent().append("<div class='alert alert-danger'>All compulsory fields should be filled</div>");
            }
            condition = false;
        }
        else {
            $(children[i]).parent().removeClass("has-error");
            $(children[i]).parent().find($(".alert")).remove();
        }
    }
    return condition;
}