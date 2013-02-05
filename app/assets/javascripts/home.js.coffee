$ ->
  # Bootstrap alert call
  $(".alert").alert()
  
  # Ajax destroy a merge
  $(document).on 'click',".merge_delete", ->
    clicked_element = $(@)
    merge_destroy = $.post '/merges/destroy',
      merge_id: this.dataset.merge
    merge_destroy.success (data) ->
      clicked_element.popover("destroy")
      clicked_element.parent().parent().fadeOut () ->
        clicked_element.parent().parent().remove()
    merge_destroy.success (data) ->
      clicked_element.addClass("disabled")
      clicked_element.popover
        title: "Delete Error!"
        content: "There was an issue removing this merge. Please try again soon."
        trigger: "click"
      hide_popover_and_enable_button = () ->
        clicked_element.popover("hide")
        clicked_element.removeClass("disabled")
      setTimeout hide_popover_and_enable_button,4000
  
  # render all times
  handleTimeResponse = (result_times) ->
    $("#possible_times").html(
        """
        <table class="table" id="times_table">
          <tr><th>Day of the Week</th><th>Availability</th></tr>
        </table>
        """
      )
      handleDay("Sunday",result_times)
      handleDay("Monday",result_times)
      handleDay("Tuesday",result_times)
      handleDay("Wednesday",result_times)
      handleDay("Thursday",result_times)
      handleDay("Friday",result_times)
      handleDay("Saturday",result_times)
  
  # Render a single day's times
  handleDay = (day_name,result_times) ->
    if result_times[day_name]?
      for day in result_times[day_name]
        $("#times_table").append(
          """
            <tr>
              <td>#{day_name}</td>
              <td>#{day[0]} <i class="icon-chevron-right"></i> #{day[1]}</td>
            </tr>
          """
        )
  # Ajax merge selection
  $(document).on "click",".ajax_checkbox", ->
    merging_users = []
    for box in $(".ajax_checkbox")
      if box.checked
        merging_users.push box.dataset.receiver
    if merging_users.length > 0
      $("#times_alert").remove()
      $.get '/merges/find_time',
        to_users: merging_users
        (times)->
          if times.error?
            $("#possible_times").html(
              JST["templates/merge_choice_error"]
                message: times.error)
          else
            handleTimeResponse(times)
    else
      $("#possible_times").html(
        JST["templates/merge_choice_error"]
          message: "No merges selected, no possible times exist.")

  # Ajax merge add
  $(document).on "click","#add_user_button", ->
    $('#search_error').remove()
    username_text = $("input#username_search").val().trim()
    unless username_text  == ""
      $.post '/merges/create',
        to_username: username_text
        (response) ->
          if response.error
            $("#warning_zone").html(
              JST["templates/add_user_error"]
                error: response.error)
          else
            $("#merge_table").append(JST['templates/add_user'] 
              username: response.to_username 
              merge_id: response.merge_id)

  # Calendar event callback handlers
  eventResizer = (str, obj, collect) ->
    uncheckBoxes()
    $.post '/events/update',
      event_id : obj.uid
      new_start_time : obj.begins
      new_end_time : obj.ends
      success: ->
        return true
      error: ->
        return false
  eventDestroy = (str,obj,collect) ->
    uncheckBoxes()
    $.post '/events/destroy',
         event_id : obj.uid
         success: ->
           return true
         error: ->
           return false
           
  # calendar setup
  calendar = $('#calendar').cal(
    startdate     : gon.start_date
    daystodisplay : 7
    maskeventlabel : 'g:i A'
    maskeventlabeldelimiter:'-'
    maskeventlabelend :'g:i A'
    gridincrement: '15 mins'
    events : gon.jbuilder
    allowresize :true
    allowmove :true
    allowremove:true
    allowselect: false
    minwidth: 20
    eventresize : eventResizer
    eventmove: eventResizer
    eventremove: eventDestroy
    onload: ->
      $(document).on 'click','div.ui-cal-time', ->
        uncheckBoxes()
        click_time = $(@).attr "time"
        click_date = @.parentElement.getAttribute "date"
        if click_time == "23:45:00"
          next_time = "24:00:00"
        else
          next_time = @.nextSibling.getAttribute "time"
        $.post '/events/create',
          eventTime : click_time
          eventDate : click_date
          (data)->
            $('#calendar').cal('add',
               begins: "#{click_date} #{click_time}",
               ends:"#{click_date} #{next_time}",
               uid: data.uid,color:"blue",notes:"Available")
  )
  
  #prevent selection during drag
  $('#calendar').disableSelection()
  $('h1').disableSelection()
  
  # Uncheck all merge boxes
  uncheckBoxes = ()->
    for box in $(".ajax_checkbox")
      box.checked = false
    $("#possible_times").html(
      JST["templates/merge_choice_error"]
        message: "No merges selected, no possible times exist.")