$(function () {
    $('form').submit(function () {
        let STOCK = {
            CODE : $('#txtCode').val(),
            NAME : $('#txtName').val(),
            PRICE : $('#txtPrice').val()
        };
        if (STOCK.CODE) {
            $.ajax({
                url: 'WebService.asmx/Insert',
                data: JSON.stringify({ STOCK: STOCK }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    if (rs > 0) {
                        console.log(status);
                        $('form')[0].reset();
                    }
                    return false;
                },
                error: function (xhr, status, error) {
                    alert("Error!" + xhr.status);
                }
            });
        }
        return false;
    });
    $('#btnUpdate').click(function () {
        let STOCK = {
            CODE: $('#txtCode').val(),
            NAME: $('#txtName').val(),
            PRICE: $('#txtPrice').val()
        };
        if (STOCK.CODE) {
            $.ajax({
                url: 'WebService.asmx/Update',
                data: JSON.stringify({ STOCK: STOCK }),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    if (rs > 0) {
                        console.log(status);
                    }
                   
                    return false;
                },
                error: function (xhr, status, error) {
                    alert("Error!" + xhr.status);
                }
            });
        }
        return false;
    });
    $('#btnDelete').click(function () {
        let STOCK = {
            CODE: $('#txtCode').val(),
            NAME: $('#txtName').val(),
            PRICE: $('#txtPrice').val()
        };
        let cfm = confirm('Are you sure you want to delete?');
        if (STOCK.CODE && cfm) {
            $.ajax({
                url: 'WebService.asmx/Remove',
                data: JSON.stringify({ STOCK: STOCK}),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                crossBrowser: true,
                success: function (data, status) {
                    var rs = data.d;
                    if (rs > 0) {
                        console.log(status);
                        $('form')[0].reset();
                    }
                    return false;
                },
                error: function (xhr, status, error) {
                    alert("Error!" + xhr.status);
                }
            });
        }
        return false;
    });
    $('#stockTable').on('click', '.code', function () {
        $('#txtCode').val($.trim($(this).text()));
        $('#txtName').val($.trim($(this).closest('tr').find('.name').text()));
        $('#txtPrice').val($.trim($(this).closest('tr').find('.price').text()));
    });
});