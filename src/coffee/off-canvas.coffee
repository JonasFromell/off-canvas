do ($) ->
  toggle 		= "[data-toggle=off-canvas]"

  getMenu = ($this) ->
    # Get the selector
    selector = $this.attr('data-target')

    # Is the selector an element?
    $menu = selector and $(selector)

    # Return the element or the default element
    (if $menu and $menu.length then $menu else $('.off-canvas-menu'))

  getContainer = ($this) ->
    # Get the selector
    selector = $this.attr('data-push')

    # Is the selector an element?
    $container = selector and $(selector)

    # Return the element or the default element
    if $container and $container.length
      $container
    else
      $('.off-canvas-container')

  hideMenus = (e) ->
    $(toggle).each ->
      $menu      = getMenu($(this))
      $container = getContainer($(this))

      return unless $menu.hasClass('open')

      $menu.trigger(e = $.Event('hide.offcanvas', $menu))
      $container.trigger($.Event('pull.offcanvas', $container))

      return if e.isDefaultPrevented()

      $menu.removeClass('open').trigger('hidden.offcanvas', $menu)
      $container.removeClass('push').trigger('pulled.offcanvas', $container)

  # Kick of the plugin
  OffCanvas = (element) ->
    $(element).on('click.offcanvas', @toggle)

  OffCanvas.prototype.toggle = (e) ->
    $this = $(this)

    # Find the menu to toggle
    $menu = getMenu($this)

    # Find the container
    $container = getContainer($this)

    # Is it open?
    isOpen = $menu.hasClass('open')

    # Hide all other menus
    hideMenus()

    # If the menu is not open, open it
    unless isOpen
      # Trigger show event
      $menu.trigger(e = $.Event('show.offcanvas', $menu))

      # Trigger push event
      $container.trigger($.Event('push.offcanvas', $container))

      # Return if event is prevented
      return if e.isDefaultPrevented()

      # Toggle the open class on the menu
      $menu
        .toggleClass('open')
        .trigger('shown.offcanvas', $menu)

      # We also need to toggle the push class on the container
      $container
        .toggleClass('push')
        .trigger('pushed.offcanvas', $container)
    
    false

  $.fn.offcanvas = (option) ->
    this.each ->
      $this = $(this)
      data  = $this.data('offcanvas')

      $this.data('offcanvas', (data = new OffCanvas(this))) unless data
      data[option].call($this) if typeof option is "string"

  $.fn.offcanvas.Constructor = OffCanvas

  $(document)
    .on('click.offcanvas.data-api', hideMenus)
    .on('click.offcanvas.data-api', toggle, OffCanvas.prototype.toggle)