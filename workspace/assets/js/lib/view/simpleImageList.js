
define(['backbone', 'masonry', 'lib/view/simpleImage'], function (Backbone, Masonry, view) { 
  
   /* found: 
 http://stackoverflow.com/questions/7616461/generate-a-hash-from-string-in-javascript-jquery
 */
 var hashCode = function(s){
  return s.split("").reduce(function(a,b){a=((a<<5)-a)+b.charCodeAt(0);return a&a},0);              
}
  
  
  return Backbone.View.extend({
  
   tagName: '',  
   
   el: '',  
   thumbs: '',
   entries : '',
   hash: '',
 
   layout: '',
   initialize: function(opts) {
     
     
     
     var self = this;
     this.layout = opts.layout || {};
     
   // childopts can't be funny that way 
     this.childopts = opts.childopts || {};
     _(this).bindAll('add', 'remove');
     if (this.layout.masonry){
/*       
           var msry = this.$el.masonry(
 	     this.layout.masonry
 	 );
*/
	   this.collection.on('isLoad', function(self){ ;
//   	    pictureLoad.on('isLoad', function(self){
	     if ($self.canvas.height == 0) {
	       
	        
		  window.setTimeout(function(){
		      
		      self.model.collection.trigger('isLoad', self.el)}, 
		100);
	     }
	      if ( $(self).hasClass(this.layout.masonry.itemSelector.substring(1,this.layout.masonry.itemSelector.length))) return;
	      // may use dataset masonry ?
	      $(self).addClass(this.layout.masonry.itemSelector.substring(1,this.layout.masonry.itemSelector.length));	
	      this.$el.masonry( 'appended', self);
	      
          },this);
     }
 
    this.collection.each(function(model){
      self.add(model);
    });
    this.collection.bind('add', function() { self.add(self.collection.last())}); 
    return this;
   },    

  add: function(m) {

     var elm = new view({model: m, class: this.childopts.class, fit: true, tplStr: this.childopts.tpl });
     // so must se6t source on initilize 
     var hash =    hashCode(m.get('src'));
     m.set('hash', hash);
     elm.render();
     this.el.appendChild(elm.el);
  
 },

   render: function() {
        
        return this;
    }
   
  
   });  

});
