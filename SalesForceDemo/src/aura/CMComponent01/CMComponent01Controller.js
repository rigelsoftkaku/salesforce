({
	handleSelect : function(cmp, event, helper) {
		var selectedMenuItemValue = event.getParam("value");
		if ('Edit' == selectedMenuItemValue) {
			alert("名刺の編集を行う");
		} else {
			alert("名刺の削除を行う");
		}
	}
})