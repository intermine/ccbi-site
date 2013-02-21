{ blað } = require 'blad'

class exports.WorkshopArchiveHolderDocument extends blað.Type

    render: (done) ->
        # Get the workshops.
        @siblings (pages) =>
            today = (new Date()).toJSON()

            @workshops = []
            for page in pages when page.type is 'WorkshopDocument'
                # Is it in the past?
                if (s = page.date) < today
                    # Parse date.
                    page.date =
                        'stamp': s
                        'day': [ 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' ][(new Date(s)).getDay()]
                        'month': [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec' ][(new Date(s)).getMonth()]
                        'date': (new Date(s)).getDate()

                    @workshops.push page

            done @