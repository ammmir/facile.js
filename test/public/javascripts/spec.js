(function() {

  describe('facile', function() {
    it('binds ids', function() {
      var data, result, template;
      template = '<div id="dog" />';
      data = {
        dog: 'woof'
      };
      result = facile(template, data);
      return expect(result).toBe('<div id="dog">woof</div>');
    });
    it('binds arrays', function() {
      var data, result, template;
      template = '<div class="dog" />';
      data = {
        dog: ['woof', 'bark']
      };
      result = facile(template, data);
      return expect(result).toBe('<div class="dog">woof</div><div class="dog">bark</div>');
    });
    it('binds nulls and removes element by id', function() {
      var data, result, template;
      template = '<div id="dog" />';
      data = {
        dog: null
      };
      result = facile(template, data);
      return expect(result).toBe('');
    });
    it('binds nulls and removes element by class', function() {
      var data, result, template;
      template = '<div class="dog" />';
      data = {
        dog: null
      };
      result = facile(template, data);
      return expect(result).toBe('');
    });
    it('binds objects', function() {
      var data, result, template;
      template = '<div id="dog" />';
      data = {
        dog: {
          value: 'woof',
          'data-age': 3
        }
      };
      result = facile(template, data);
      return expect(result).toBe('<div id="dog" data-age="3">woof</div>');
    });
    it('binds array of value objects', function() {
      var data, result, template;
      template = '<div class="dog" />';
      data = {
        dog: [
          {
            value: 'woof',
            'data-age': 3
          }, {
            value: 'bark',
            'data-peak': 27
          }
        ]
      };
      result = facile(template, data);
      return expect(result).toBe('<div class="dog" data-age="3">woof</div><div class="dog" data-peak="27">bark</div>');
    });
    it('looks for class if id does not exist', function() {
      var data, result, template;
      template = '<div class="dog" />';
      data = {
        dog: 'woof'
      };
      result = facile(template, data);
      return expect(result).toBe('<div class="dog">woof</div>');
    });
    it('binds arrays of binding objects', function() {
      var data, expectedHtml, result, template;
      template = '<div class="order"><div class="name" /></div>';
      data = {
        order: [
          {
            name: 'cool order'
          }, {
            name: 'lame order'
          }
        ]
      };
      result = facile(template, data);
      expectedHtml = '<div class="order"><div class="name">cool order</div></div><div class="order"><div class="name">lame order</div></div>';
      return expect(result).toBe(expectedHtml);
    });
    return it('binds to table rows', function() {
      var data, expectedHtml, result, template;
      template = '<table class="order"><thead><tr><td>Orders</td></tr></thead><tbody><tr><td class="name" /></tr></tbody></table>';
      data = {
        order: [
          {
            name: 'cool order'
          }, {
            name: 'lame order'
          }
        ]
      };
      result = facile(template, data);
      expectedHtml = '<table class="order"><thead><tr><td>Orders</td></tr></thead><tbody><tr><td class="name">cool order</td></tr><tr><td class="name">lame order</td></tr></tbody></table>';
      return expect(result).toBe(expectedHtml);
    });
  });

}).call(this);
