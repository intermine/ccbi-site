{ blað } = require 'blad'

request = require 'request'
kronic = require 'kronic-node'
marked = require 'marked'
cheerio = require 'cheerio'
sax = require('sax').parser(true)

class exports.HomeDocument extends blað.Type

    render: (done) ->
        # Markdown?
        @body = marked @body if @body?

        today = (new Date()).toJSON()

        # Get us upcoming workshops.
        @workshops = [] ; @archive = false
        for page in @children 1 when page.type is 'WorkshopDocument' # not direct descendants
            # Is the workshop gone now?
            if (s = page.date) > today
                # Parse date.
                page.date =
                    'stamp': s
                    'day': [ 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' ][(new Date(s)).getDay()]
                    'month': [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec' ][(new Date(s)).getMonth()]
                    'date': (new Date(s)).getDate()

                @workshops.push page
            else
                @archive = true

        # Sort all workshops in place on the timestamp.
        @workshops.sort (a, b) ->
            if a.date.stamp < b.date.stamp then -1
            else
                if a.date.stamp is b.date.stamp then 0
                else 1

        # Check if data in store is old and we have a talks URL.
        if @talksURL and @store.isOld 'talks', 1, 'day'
            request @talksURL, (err, res, body) =>
                if err or res.statusCode isnt 200 then done @
                else
                    @parseTalks body, (talks) =>
                        # Save the new talks and render.
                        @store.save 'talks', talks, =>
                            @talks = talks
                            done @
        else
            @talks = @store.get 'talks'
            done @

    # Parse talks.cam RSS file format.
    parseTalks: (xml, cb) ->
        events = [] ; event = {} ; text = '' ;

        sax.onclosetag = (node) ->
            switch node
                # New item.
                when 'item' then events.push event = {}
                # Strip the time & date (get later)
                when 'title'
                    if (title = text.match /\: (.*)/) and title[1] then event.title = title[1][0...-1]
                # Straight copies.
                when 'link' then event[node] = text
                # Start time.
                when 'ev:startdate'
                    date = new Date(text)
                    event.date =
                        'stamp': date.getTime()
                        'day': [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ][date.getDay()]
                        'month': [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ][date.getMonth()]
                        'date': date.getDate()
                # Location.
                when 'ev:location' then event.location = text
                # Try to parse speaker from the mess using cheerio...
                when 'description'
                    if text
                        $ = cheerio.load text
                        speaker = $('.vevent ul li:nth-child(1)').text()
                        if speaker and speaker.length isnt 0
                            if (speaker = speaker.match /Speaker: (.*)/) and speaker[1] then event.speaker = speaker[1]

        # Save it for node to scoop up.
        sax.ontext = (txt) -> text = txt

        sax.onend = ->
            # Pop the last one as is empty?
            if (last = events.pop()).title then events.push last
            # Sort based on the timestamp.
            events = events.sort (a, b) -> a.date.stamp - b.date.stamp
            # We done.
            cb events

        sax.write(xml).close()