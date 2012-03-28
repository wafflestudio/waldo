$(function(){
	$(document).on('click', '.waldorize-button' ,waldorize);
});


function waldorize(){
	var $inputField = $('#waldorize-field');
	var inputText = $inputField.val();
	var $outputField = $('#waldorized-field');

	$.ajax({
		url: '/phrases/waldorize',
		dataType: 'json',
		type: 'get',
		data: {input_text: inputText},
		success: function(res){
			if(res.success){
				$outputField.text(res.waldorized);
			} else {
				console.log(res);

				alert("너는 실패했다. 왈도에!");
			}
		},
		error: function(e){
			alert('왈도 서버는 중금!');
		}
	});
}



$(function(){
	$(document).on('click', '.deshift-button', deshift);
});


function deshift(){
	var $inputField = $('#waldorize-field');
	var inputText=  $inputField.val();
	var $outputField = $('#waldorized-field');

	$.ajax({
		url: '/phrases/deshift',
		dataType: 'json',
		type: 'get',
		data: {input_text: inputText},
		success: function(res){
			if(res.success){
				$outputField.text(res.deshifted);
			} else {
				alert("쒸프트키까 꼐쏚 안 빠쪄요!");
			}
		},
		error: function(e){
			alert('쥬금');
		}
	});
}
