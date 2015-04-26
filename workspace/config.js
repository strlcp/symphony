/**
 * Require config
 */
 require.config({
    baseUrl: "./",
    paths: {
/*
	  path to namespacce     
*/	  'namespace' : 'bower_components/requirejs-namespace-plugin/namespace',
/*   vendors */
         'jquery': 'bower_components/jquery/dist/jquery.min',
	 'underscore': 'bower_components/underscore/underscore',
	 'backbone': 'bower_components/backbone/backbone',
	// handelbars: 'vendor/handlebars.runtime-v1.3.0',

/* used for masonry further */
	 'jbridget' : 'bower_components/jquery-bridget/jquery.bridget',
	 'get-style-property': 'bower_components/get-style-property',
	 'doc-ready': 'bower_components/doc-ready',
// 	 'masonry' : 'bower_components/masonry/masonry',
// 	 'eventie' : 'bower_components/eventie',
//       'eventEmitter':  'bower_components/eventEmitter',
	 'matches-selector' : 'bower_components/matches-selector',
/* Foundation */
	'foundation.core':  'bower_components/foundation/js/foundation/foundation',
        'foundation.abide': 'bower_components/foundation/js/foundation/foundation.abide',
        'foundation.accordion': 'bower_components/foundation/js/foundation/foundation.accordion',
        'foundation.alert': 'bower_components/foundation/js/foundation/foundation.alert',
        'foundation.clearing': 'bower_components/foundation/js/foundation/foundation.clearing',
        'foundation.dropdown': 'bower_components/foundation/js/foundation/foundation.dropdown',
        'foundation.equalizer': 'bower_components/foundation/js/foundation/foundation.equalizer',
        'foundation.interchange': 'bower_components/foundation/js/foundation/foundation.interchange',
        'foundation.joyride': 'bower_components/foundation/js/foundation/foundation.joyride',
        'foundation.magellan': 'bower_components/foundation/js/foundation/foundation.magellan',
        'foundation.offcanvas': 'bower_components/foundation/js/foundation/foundation.offcanvas',
        'foundation.orbit': 'bower_components/foundation/js/foundation/foundation.orbit',
        'foundation.reveal': 'bower_components/foundation/js/foundation/foundation.reveal',
        'foundation.tab': 'bower_components/foundation/js/foundation/foundation.tab',
        'foundation.tooltip': 'bower_components/foundation/js/foundation/foundation.tooltip',
        'foundation.topbar': 'bower_components/foundation/js/foundation/foundation.topbar',

        /* Vendor Scripts */
        'jquery.cookie': 'bower_components/jquery.cookie/jquery.cookie',
        'fastclick': 'bower_components/fastclick/lib/fastclick',
        'modernizr': 'bower_components/modernizr/modernizr',
        'placeholder': 'bower_components/placeholder/placeholder',
	'get-size' : 'bower_components/get-size',
	'outlayer': 'bower_components/outlayer'
    },
    shim: {        
      'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },
        'underscore': {
            exports: '_'
        },
	jbridget : [ 'jquery' ],
                
/*        masonry : {
	    deps: [ 'jquery', 'jbridget'],
	    exports: 'Masonry'
	}
,*/   
        /* Foundation */
        'foundation.core': {
            deps: [
            'jquery',
            'modernizr'
            ],
            exports: 'Foundation'
        },
        'foundation.abide': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.accordion': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.alert': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.clearing': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.dropdown': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.equalizer': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.interchange': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.joyride': {
            deps: [
            'foundation.core',
            'jquery.cookie'
            ]
        },
        'foundation.magellan': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.offcanvas': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.orbit': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.reveal': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.tab': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.tooltip': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.topbar': {
            deps: [
            'foundation.core'
            ]
        },

        /* Vendor Scripts */
        'jquery.cookie': {
            deps: [
            'jquery'
            ]
        },
        'fastclick': {
            exports: 'FastClick'
        },
        'modernizr': {
            exports: 'Modernizr'
        },
        'placeholder': {
            exports: 'Placeholders'
        }
	
    },
    /*
     * 	namespace modul for requirejs https://github.com/atesgoral/requirejs-namespace-plugin
     */
     config:{
       namespace: {
            'assets/js/lib/collections': '',
	    'assets/js/lib/views': '/**
 * Require config
 */
 require.config({
    baseUrl: "./",
    paths: {
/*
	  path to namespacce     
*/	  'namespace' : 'bower_components/requirejs-namespace-plugin/namespace',
/*   vendors */
         'jquery': 'bower_components/jquery/dist/jquery.min',
	 'underscore': 'bower_components/underscore/underscore',
	 'backbone': 'bower_components/backbone/backbone',
	// handelbars: 'vendor/handlebars.runtime-v1.3.0',

/* used for masonry further */
	 'jbridget' : 'bower_components/jquery-bridget/jquery.bridget',
	 'get-style-property': 'bower_components/get-style-property',
	 'doc-ready': 'bower_components/doc-ready',
// 	 'masonry' : 'bower_components/masonry/masonry',
// 	 'eventie' : 'bower_components/eventie',
//       'eventEmitter':  'bower_components/eventEmitter',
	 'matches-selector' : 'bower_components/matches-selector',
/* Foundation */
	'foundation.core':  'bower_components/foundation/js/foundation/foundation',
        'foundation.abide': 'bower_components/foundation/js/foundation/foundation.abide',
        'foundation.accordion': 'bower_components/foundation/js/foundation/foundation.accordion',
        'foundation.alert': 'bower_components/foundation/js/foundation/foundation.alert',
        'foundation.clearing': 'bower_components/foundation/js/foundation/foundation.clearing',
        'foundation.dropdown': 'bower_components/foundation/js/foundation/foundation.dropdown',
        'foundation.equalizer': 'bower_components/foundation/js/foundation/foundation.equalizer',
        'foundation.interchange': 'bower_components/foundation/js/foundation/foundation.interchange',
        'foundation.joyride': 'bower_components/foundation/js/foundation/foundation.joyride',
        'foundation.magellan': 'bower_components/foundation/js/foundation/foundation.magellan',
        'foundation.offcanvas': 'bower_components/foundation/js/foundation/foundation.offcanvas',
        'foundation.orbit': 'bower_components/foundation/js/foundation/foundation.orbit',
        'foundation.reveal': 'bower_components/foundation/js/foundation/foundation.reveal',
        'foundation.tab': 'bower_components/foundation/js/foundation/foundation.tab',
        'foundation.tooltip': 'bower_components/foundation/js/foundation/foundation.tooltip',
        'foundation.topbar': 'bower_components/foundation/js/foundation/foundation.topbar',

        /* Vendor Scripts */
        'jquery.cookie': 'bower_components/jquery.cookie/jquery.cookie',
        'fastclick': 'bower_components/fastclick/lib/fastclick',
        'modernizr': 'bower_components/modernizr/modernizr',
        'placeholder': 'bower_components/placeholder/placeholder',
	'get-size' : 'bower_components/get-size',
	'outlayer': 'bower_components/outlayer'
    },
    shim: {        
      'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },
        'underscore': {
            exports: '_'
        },
	jbridget : [ 'jquery' ],
                
/*        masonry : {
	    deps: [ 'jquery', 'jbridget'],
	    exports: 'Masonry'
	}
,*/   
        /* Foundation */
        'foundation.core': {
            deps: [
            'jquery',
            'modernizr'
            ],
            exports: 'Foundation'
        },
        'foundation.abide': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.accordion': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.alert': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.clearing': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.dropdown': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.equalizer': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.interchange': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.joyride': {
            deps: [
            'foundation.core',
            'jquery.cookie'
            ]
        },
        'foundation.magellan': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.offcanvas': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.orbit': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.reveal': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.tab': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.tooltip': {
            deps: [
            'foundation.core'
            ]
        },
        'foundation.topbar': {
            deps: [
            'foundation.core'
            ]
        },

        /* Vendor Scripts */
        'jquery.cookie': {
            deps: [
            'jquery'
            ]
        },
        'fastclick': {
            exports: 'FastClick'
        },
        'modernizr': {
            exports: 'Modernizr'
        },
        'placeholder': {
            exports: 'Placeholders'
        }
	
    },
    /*
     * 	namespace modul for requirejs https://github.com/atesgoral/requirejs-namespace-plugin
     */
     config:{
       namespace: {
            'assets/js/lib/collections': 'simpleImage',
	    'assets/js/lib/views': 'simpleImage, simpleImageList',
	    'assets/js/lib/models': 'simpleImage'
     }
  
    } 
         

});

/** kickoff app*/
 
 
define([ 'namespace!.assets/js/lib/models' ], function (models) {
  var app = {
    model: models
  };
  console.debug(app.model);
});

