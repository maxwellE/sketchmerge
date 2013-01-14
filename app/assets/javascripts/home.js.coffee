# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
    $(".ajax_checkbox").click ->
      console.log "Clicked Checkbox"
    $("#add_user_button").click ->
      $('#search_error').remove()
      username_text = $("input#username_search").val().trim()
      unless username_text  == ""
        $.post '/merges/create',
          to_username: username_text
          (response) ->
            if response.error
              console.log "ERROR"
              $("#warning_zone").html(
                """
                <div class="alert" id="search_error">
                  <button type="button" class="close" data-dismiss="alert">&times;</button>
                  <strong>Error!</strong> #{response.error}
                </div>
                """
              )
            else
              $("#merge_table").append(
                """
                    <tr>
                		<td><input type="checkbox" class="ajax_checkbox" name="merge" data-receiver="#{response.to_username}"></td>
                        <td>#{response.to_username}</td>
                        <td></td>
                  	</tr>
                """
              )
    tz = jstz.determine()
    timeZone = tz.name()
    eventResizer = (str, obj, collect) ->
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
                  ends:"#{click_date} #{next_time}", uid: data.uid,color:"blue",notes:"Avaliable"})
    )
    $('#calendar').disableSelection();