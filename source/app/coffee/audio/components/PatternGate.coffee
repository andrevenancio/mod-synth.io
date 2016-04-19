# import audio.components.Component
class PatternGate extends Component

    constructor: (data) ->
        super data

        @parameters.bypass = data.settings.bypass
        @parameters.pattern =  data.settings.pattern

        App.SETTINGS_CHANGE.add @onSettingsChange

        @current16thNote
        @lookahead = 25.0
        @scheduleAheadTime = 0.1
        @nextNoteTime = 0.0

        @last16thNoteDrawn = -1
        @notesInQueue = []

        @timerWorker = new Worker 'workers/timeworker.js'
        @timerWorker.onmessage = (e) =>
            if e.data is 'tick'
                @scheduler()
            null
        @timerWorker.postMessage { 'interval': @lookahead }

        @aux.gain.value = 0.0;
        @play()

    destroy: ->
        @stop()
        null

    nextNote: ->
        secondsPerBeat = 60.0 / Session.BPM
        @nextNoteTime += 0.25 * secondsPerBeat
        @current16thNote++
        if @current16thNote is 16
            @current16thNote = 0
        null

    scheduleNote: (beatNumber, time) ->
        @notesInQueue.push { note: beatNumber, time: time }

        if @parameters.pattern[beatNumber] is true and Session.SETTINGS[@component_session_uid].settings.bypass is false
            @aux.gain.setValueAtTime(1.0, time)
            @aux.gain.linearRampToValueAtTime(0.001, time + 0.1)
            @aux.gain.linearRampToValueAtTime(1.0, time + 0.11)

        App.PATTERN_GATE.dispatch beatNumber
        null

    scheduler: ->
        while @nextNoteTime < Audio.CONTEXT.currentTime + @scheduleAheadTime
            @scheduleNote @current16thNote, @nextNoteTime
            @nextNote()
        null

    play: ->
        @current16thNote = 0
        @nextNoteTime = Audio.CONTEXT.currentTime
        @timerWorker.postMessage 'start'
        @doUpdate = true
        @update()
        null

    stop: ->
        @timerWorker.postMessage 'stop'
        @doUpdate = false
        null

    update: =>
        if @doUpdate
            requestAnimationFrame @update

        currentNote = @last16thNoteDrawn
        currentTime = Audio.CONTEXT.currentTime

        while @notesInQueue.length and @notesInQueue[0].time < currentTime
            currentNote = @notesInQueue[0].note
            @notesInQueue.splice 0, 1

            if @last16thNoteDrawn isnt currentNote
                @last16thNoteDrawn = currentNote
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @pattern = Session.SETTINGS[@component_session_uid].settings.pattern
        null

    @property 'pattern',
        get: ->
            return @parameters.pattern
        set: (value) ->
            return @parameters.pattern if @parameters.pattern is value
            @parameters.pattern = value
            return @parameters.pattern
