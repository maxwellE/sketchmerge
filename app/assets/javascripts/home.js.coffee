# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
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
    $(".ajax_checkbox").click ->
      merging_users = []
      for box in $(".ajax_checkbox")
          if box.checked
              merging_users.push box.dataset.receiver
      if merging_users.length
        $("#times_alert").remove()
        $.get '/merges/find_time',
          to_users: merging_users
          (times)->
              if times.error?
                dust.render "merge_choice_error",
                  message: times.error
                  (err,out) ->
                    $("#possible_times").html(out)
              else
                handleTimeResponse(times)
      else
        dust.render "merge_choice_error",
          message: "No merges selected, no possible times exist."
          (err,out) ->
              $("#possible_times").html(out)
    $("#add_user_button").click ->
      $('#search_error').remove()
      username_text = $("input#username_search").val().trim()
      unless username_text  == ""
        $.post '/merges/create',
          to_username: username_text
          (response) ->
            if response.error
              dust.render "add_user_error",
                error: response.error
                (err, out) ->
                  $("#warning_zone").html(out)
            else
              dust.render "add_user",
                username: response.to_username
                (err, out) ->
                  $("#merge_table").append(out)
    tz = jstz.determine()
    timeZone = tz.name()
    eventResizer = (str, obj, collect) ->
      uncheckBoxes()
      $.post '/events/update',
        event_id : obj.uid
        new_start_time : obj.begins
        new_end_time : obj.ends
        timezone : timeZone
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
    calendar = $('#calendar').cal(
        startdate     : gon.start_date
        daystodisplay : 7
        maskeventlabel : 'g:i A'
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
            $('div.ui-cal-time').click (e) ->
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
                timezone : timeZone
                (data)->
                  $('#calendar').cal('add',{begins: "#{click_date} #{click_time}", 
                  ends:"#{click_date} #{next_time}", uid: data.uid,color:"blue",notes:"Available"})
    )
    $('#calendar').disableSelection();
    $('h1').disableSelection();
    uncheckBoxes = ()->
        for box in $(".ajax_checkbox")
          box.checked = false
        dust.render "merge_choice_error",
          message: "No merges selected, no possible times exist."
          (err,out) ->
            $("#possible_times").html(out)