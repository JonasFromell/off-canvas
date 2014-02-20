(function($) {
  var OffCanvas, getContainer, getMenu, hideMenus, toggle;
  toggle = "[data-toggle=off-canvas]";
  getMenu = function($this) {
    var $menu, selector;
    selector = $this.attr('data-target');
    $menu = selector && $(selector);
    if ($menu && $menu.length) {
      return $menu;
    } else {
      return $('.off-canvas-menu');
    }
  };
  getContainer = function($this) {
    var $container, selector;
    selector = $this.attr('data-push');
    $container = selector && $(selector);
    if ($container && $container.length) {
      return $container;
    } else {
      return $('.off-canvas-container');
    }
  };
  hideMenus = function(e) {
    return $(toggle).each(function() {
      var $container, $menu;
      $menu = getMenu($(this));
      $container = getContainer($(this));
      if (!$menu.hasClass('open')) {
        return;
      }
      $menu.trigger(e = $.Event('hide.offcanvas', $menu));
      $container.trigger($.Event('pull.offcanvas', $container));
      if (e.isDefaultPrevented()) {
        return;
      }
      $menu.removeClass('open').trigger('hidden.offcanvas', $menu);
      return $container.removeClass('push').trigger('pulled.offcanvas', $container);
    });
  };
  OffCanvas = function(element) {
    return $(element).on('click.offcanvas', this.toggle);
  };
  OffCanvas.prototype.toggle = function(e) {
    var $container, $menu, $this, isOpen;
    $this = $(this);
    $menu = getMenu($this);
    $container = getContainer($this);
    isOpen = $menu.hasClass('open');
    hideMenus();
    if (!isOpen) {
      $menu.trigger(e = $.Event('show.offcanvas', $menu));
      $container.trigger($.Event('push.offcanvas', $container));
      if (e.isDefaultPrevented()) {
        return;
      }
      $menu.toggleClass('open').trigger('shown.offcanvas', $menu);
      $container.toggleClass('push').trigger('pushed.offcanvas', $container);
    }
    return false;
  };
  $.fn.offcanvas = function(option) {
    return this.each(function() {
      var $this, data;
      $this = $(this);
      data = $this.data('offcanvas');
      if (!data) {
        $this.data('offcanvas', (data = new OffCanvas(this)));
      }
      if (typeof option === "string") {
        return data[option].call($this);
      }
    });
  };
  $.fn.offcanvas.Constructor = OffCanvas;
  return $(document).on('click.offcanvas.data-api', hideMenus).on('click.offcanvas.data-api', toggle, OffCanvas.prototype.toggle);
})($);
