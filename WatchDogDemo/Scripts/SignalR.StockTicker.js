if (!String.prototype.supplant) {
    String.prototype.supplant = function (o) {
        return this.replace(/{([^{}]*)}/g,
            function (a, b) {
                var r = o[b];
                return typeof r === 'string' || typeof r === 'number' ? r : a;
            }
        );
    };
}

$(function () {
    var ticker = $.connection.stockTicker; // the generated client-side hub proxy
    var $stockTable = $('#stockTable');
    var $stockTableBody = $stockTable.find('tbody');
    var rowTemplate = '<tr id="{CODE}" data-symbol="{CODE}"><td class="code">{CODE}</td><td class="name">{NAME}</td><td class="price">{PRICE}</td></tr>';

    function formatStock(stock) {
        return $.extend(stock, {
            PRICE: stock.PRICE.toFixed(2)
        });
    }

    function init() {
        return ticker.server.getAllStocks().done(function (stocks) {
            $stockTableBody.empty();
            $.each(stocks, function () {
                this.CODE = $.trim(this.CODE);
                var stock = formatStock(this);
                $stockTableBody.append(rowTemplate.supplant(stock));
            });
        });
    }
    // Add client-side hub methods that the server will call
    $.extend(ticker.client, {
        onError: function (error) {
            console.log(error);
        },
        updateStockPrice: function (stock, changeType) {
            var displayStock = formatStock(stock);
            $row = $(rowTemplate.supplant(displayStock)),
                $stockTableBody.find('tr[data-symbol=' + $.trim(stock.CODE) + ']').replaceWith($row);
            let r = $stockTableBody.find('tr[data-symbol=' + $.trim(stock.CODE) + ']');
          
            switch (changeType) {
                case 1:
                    $('#lblNoti').text(stock.CODE + ' Delete at ' + moment().format('MMMM Do YYYY, h:mm:ss a'));
                    $('#stockTable').find('tr[id=' + $.trim(stock.CODE) + ']').remove();
                    $('.code').each(function () {
                        if ($(this).text() == stock.CODE) {
                            $(this).closest('tr').remove();
                            return false;
                        }
                    });
                    break;
                case 2:
                    $('#lblNoti').text(stock.CODE + ' Insert at ' + moment().format('MMMM Do YYYY, h:mm:ss a'));
                    $stockTableBody.append($row);
                    break;
                case 3:
                    $('#lblNoti').text(stock.CODE + ' Update at ' + moment().format('MMMM Do YYYY, h:mm:ss a'));
                    $('.code').each(function () {
                        if ($(this).text() == stock.CODE) {
                            $(this).next().text(stock.NAME);
                            $(this).next().next().text(stock.PRICE);
                            return false;
                        }
                    });
                  
                    break;
            }

        }
    });

    // Start the connection
    $.connection.hub.start().then(init);
});