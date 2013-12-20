$(document).ready(function(){
	$('#hideSidebar').click(function(){
		$('#sidebar, #sidebar_bg').animate({right: '-300px'},'fast').fadeOut(0);
		$('#content').animate({paddingRight: '0px'},'fast');
		$('#phone, #contacts').animate({right: '40px'},'fast');
		$('#showSidebar').fadeIn('fast');
	});
	$('#showSidebar').click(function(){
		$('#sidebar, #sidebar_bg').fadeIn(0).animate({right: '0px'},'fast');
		$('#content').animate({paddingRight: '300px'},'fast');
		$('#phone, #contacts').animate({right: '340px'},'fast');
		$('#showSidebar').fadeOut('fast');
	});
});