 


 define(['backbone'], function (Backbone) {  
    
    
    
  return pictureModel = Backbone.Model.extend({
    defaults: {
	
	path: "",
	urlBase: "", 
	alt: "",
	jit: "",
	relation: "",
	src: '',
	link: ''
		},
    initialize: function(opts) {
      this.fit = opts.fit || false;
      this.alt = (_.isUndefined(opts.alt))? "this_image_has_no_alt" : opts.alt;
      this.link = (_.isUndefined(opts.link)) ? "--_" : opts.link;
  
    }
  });
 });
