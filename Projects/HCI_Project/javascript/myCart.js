jQuery(document).ready(function(){
    // This button will increment the value
    $('.qtyplus').click(function(e){
        // Stop acting like a button
        e.preventDefault();
        // Get the field name
        fieldName = $(this).attr('field');
        // Get its current value
        var currentVal = parseInt($('input[name='+fieldName+']').val());
        var price = parseInt($('input[name='+fieldName+'price]').val());
        var cartCost = Number(document.getElementById('cartcost').innerHTML);
        document.getElementById('cartcost').innerHTML = cartCost + price; 
        // If is not undefined
        if (!isNaN(currentVal)) {
            // Increment
            $('input[name='+fieldName+']').val(currentVal + 1);
            document.getElementById(fieldName+'ID').style.color="black";
        } else {
            // Otherwise put a 0 there
            $('input[name='+fieldName+']').val(0);
        }
        document.getElementById('totalcost').innerHTML = document.getElementById('cartcost').innerHTML
    });
    // This button will decrement the value till 0
    $(".qtyminus").click(function(e) {
        // Stop acting like a button
        e.preventDefault();
        // Get the field name
        fieldName = $(this).attr('field');
        // Get its current value
        var currentVal = parseInt($('input[name='+fieldName+']').val());
        var price = parseInt($('input[name='+fieldName+'price]').val());
        var cartCost = Number(document.getElementById('cartcost').innerHTML);
        // If it isn't undefined or its greater than 0
        if (!isNaN(currentVal) && currentVal > 0) {
            // Decrement one
            document.getElementById('cartcost').innerHTML = cartCost - price;
            $('input[name='+fieldName+']').val(currentVal - 1);
        } else {
            // Otherwise put a 0 there
            //document.getElementById(fieldName+'ID').style.color="lightgray";
            $('input[name='+fieldName+']').val(0);
        }
        
        if (currentVal == 1 || currentVal == 0) {
            document.getElementById(fieldName+'ID').style.color="lightgray";
        } else {
            document.getElementById(fieldName+'ID').style.color="black";
        }
        document.getElementById('totalcost').innerHTML = document.getElementById('cartcost').innerHTML
    });
});
