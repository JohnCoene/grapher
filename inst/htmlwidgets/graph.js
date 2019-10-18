HTMLWidgets.widget({

  name: 'graph',

  type: 'output',

  factory: function(el, width, height) {

    var g;

    return {

      renderValue: function(x) {

        g = createGraph();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});