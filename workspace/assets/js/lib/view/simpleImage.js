 
 define(['backbone'], function (Backbone) {  
 
 return Backbone.View.extend({
  
  class: '',
  hash: '',
  fit: '',
  isRenderd: '',
  canvas: '',
  el: '',
  regex: '',
  availableWidths: '',
  img: '',
  tplStr: '',
  jit: '',
 
  
  initialize: function(opts) {
    var self = this;
    this.class = opts.class || "fit";
    this.isRenderd = false;
    this.fit =  opts.fit || false;
    this.$el.addClass(this.class);
    this.model = opts.model;
    
    this.regex  = opts.regex || /\/image\/(\d)\/(\d+)\/(\d+)\/?(\d)?\/?([0-9a-fA-F]{3,6})?\/?(.+)$/i;
    this.availableWidths = opts.availableWidths  || [80,  150, 300, 600, 900, 1200]; 

    /* jit an url are objects :-( url has only num keys */
    
   if (_.isObject(this.model.get('resp'))){
     
     if (this.model.get('resp').jit) {
       this.jit = true;
       this.model.set('src',  this.model.get('resp').urlBase + this.model.get('resp').jit + this.model.get('resp').path); 
     }else{
       this.availableWidths = _.keys(this.model.get('resp'));
       if(! this.model.get('src')){
	  var mw = this.availableWidths[0];
	  this.model.set('src', this.model.get('resp')[mw]);
       }
      }
   }

   
   
    this.canvas = {width: 0, height: 0};
        
    this.tplStr = (opts.tplStr)? opts.tplStr : '<img alt={{ alt }} src={{ urlBase }}{{ jit }}{{ path }} />';
   // needed for xslt I think  and for handlebars ?
    _.templateSettings = {
	  interpolate: /\{\{(.+?)\}\}/g
    };
//      console.debug(this.tplStr);
  },
  
  onLoad: function() {
    var self = this;
    if (this.img.complete && this.img.height !== 0){
       this.check();
     }else{
        window.setTimeout(function(){self.onLoad();}, 100);
    }
  },
  //  using templates here 
  template: function(){ 
    return _.template(this.tplStr); 
  },

  deterimeWidth: function () {
   
    var i    = this.availableWidths.length;
    var selectedWidth = this.availableWidths[i-1];
      while (i--) { 
      
        if (this.img.width <= this.availableWidths[i]) {
               selectedWidth = this.availableWidths[i];
	  }
       }
    return selectedWidth;
  },
  
  
  
  /* must be rewritten use an array instead */
  
  checkSrc: function(){
     
      var src = this.img.src;	
      // switch
      
      if (!this.model) console.debug(this);
      
      
      if (_.isString(this.model.get('resp'))) return this.model.get('resp');
	
	  
	  
      var string ;	  
      var selectedWidth = this.deterimeWidth();
  
   
    /* check is if is objec(jit/not jit)t  or string  */

	if(_.isObject(this.model.get('resp'))) {    
	  
	    if (!this.jit) return this.model.get('resp')[selectedWidth];  // not jit
	    
	  
	string =  src.replace (this.regex, function (match, mode, width, height, crop, bg, path, offset, whole){
    switch (mode) {
                case "0":
		  if(true) {
                    return '/image/0/' + path;
		  }
                    break;
		  
                case "1":
                case "4":
		  if(true){
                    return  '/image/' + mode + '/' + selectedWidth + '/0/' + path;
		  }
		    break;
                case "2":
                case "3":
                    var newHeight = Math.ceil((selectedWidth / width) * parseInt(height, 10));
                    var newsrc = '/image/' + mode + '/' + selectedWidth + '/' + newHeight + '/' + crop + '/';
                    if (bg !== undefined) {
                        newsrc += bg + '/';
                    }
                    if (true) {
		      return newsrc + path;
		    }
		    break;
            }
        });
	}
     return string;	

  },
 
  
  setSize: function() {

     var canvas = this.canvas;
     var image = this.img;
    
     var relation = (image.width / image.height); 

    if (this.canvas.height === 0){
         image.width = canvas.width;
         image.height = canvas.width / relation;
      }else{
         canvas.relation = (canvas.width / canvas.height);
	 if ((canvas.relation) < relation) {
  		  image.width = canvas.width;
		  image.height = canvas.width /  relation; 
	 }else{
		  image.height = canvas.height;  
		  image.width = canvas.height * relation;
	 }
    }

   return this;	
  },
  
  
  checkCanvas: function() {
    if (this.fit === false) {
      return this;      
    }
    var canvas = this.canvas;
//     var size = this.el.getBoundingClientRect();
    
//     console.debug(size);

    
//     canvas.width = size.width;
//     canvas.height = size.height;
    
       if (canvas.relation || canvas.width === 0) {
 	canvas.height =  Number( this.$el.height() ||  this.$el.innerHeight()|| this.el.offsetWidth || this.$el.css('height').replace(/px$/, ""));
       }
      
       canvas.width = this.$el.width() || this.$el.innerWidth() || parseInt(this.$el.css('width'));
      if ( canvas.width === 0) {
	
      }
    return this;
   }, 

  fitImg: function() {
       this.setSize();
       var newsrc = this.checkSrc();
       if (this.img.src !== newsrc){
	 // may load before changing ?
	// console.log(this.img.src + ' changed to ' + newsrc);
	 this.img.src = newsrc;
       }
       this.render();
    },
  check: function() {
    this.checkCanvas();
    this.fitImg();
    return this;
  },

  // resetting view 
  removeNode: function(){
    this.remove();
    this.unbind();
    this.$el.remove();
  },
  render: function(){

      var self = this;
  
      if (this.isRenderd === false) { 
	 this.checkCanvas();  

	var t = _.template(this.tplStr);
	this.$el.html( t(this.model.attributes));
	this.img =  this.$('img')[0];
	
	 if (!this.img){

	}
	// done every image is onload new :-(
	this.$('img').on('load', _.bind(self.onLoad, self));
 	$(window).on('resize', _.debounce(function() {
		  self.check();}, 200 ));
      }else{
	if (this.el.parentElement.dataset.masonryOption  ){
	self.model.collection.trigger('isLoad', self.el);
	}
      }
      this.isRenderd = true; 
      return this;
  }
});



});
 
