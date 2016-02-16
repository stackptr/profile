$(function(){
  var events = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend';

  var animCallback = function(el, cb){
    el.on(events, function(e){
  		if (e.target === e.currentTarget){
  			cb();
        el.off(events);
  		}
  	});
  };


  var $avatar = $('.avatar'),
      $header = $('header'),
      $body = $('article');

  window.setTimeout(function(){
    animCallback($avatar, function(){
      animCallback($header, function(){
        $body.removeClass('initial');
      });
      $header.removeClass('initial');
    });
    $avatar.removeClass('initial');
  }, 300);

});
