# import math.Vec2
class MathUtils

    @map: (num, min1, max1, min2, max2, round=false, constrainMin=true, constrainMax=true) ->
        if constrainMin and num < min1 then return min2
        if constrainMax and num > max1 then return max2

        num1 = (num - min1) / (max1 - min1)
        num2 = (num1 * (max2 - min2)) + min2
        if round then return Math.round(num2)
        return num2

    @lineIntersect: (line1, line2) ->
        onLine1 = false
        onLine2 = false
        result = {
            x: 0
            y: 0
        }

        denominator = ((line2.ey - line2.sy) * (line1.ex - line1.sx)) - ((line2.ex - line2.sx) * (line1.ey - line1.sy))

        if denominator is 0
            return false

        a = line1.sy - line2.sy
        b = line1.sx - line2.sx

        numerator1 = ((line2.ex - line2.sx) * a) - ((line2.ey - line2.sy) * b)
        numerator2 = ((line1.ex - line1.sx) * a) - ((line1.ey - line1.sy) * b)

        a = numerator1 / denominator
        b = numerator2 / denominator

        result.x = line1.sx + (a * (line1.ex - line1.sx))
        result.y = line1.sy + (a * (line1.ey - line1.sy))

        if a > 0 and a < 1
            onLine1 = true

        if b > 0 and b < 1
            onLine2 = true

        if onLine1 is true && onLine2 is true
            return result

        return false
