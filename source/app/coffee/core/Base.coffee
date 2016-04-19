# import AppData

# import data.Cookies
# import data.Analytics
# import data.Services
# import data.Session

# import math.Vec2
# import math.MathUtils

# import utils.Utils

Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

class Base

    constructor: ->
        # empty
