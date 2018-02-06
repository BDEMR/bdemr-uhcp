
app.behaviors.commonComputes = 

  $equals: (left, right)-> left is right

  $if: (value, thenValue, elseValue)-> if value then thenValue else elseValue

  $iff: (value)-> value

  $sum: (a,b)-> a + b

  $and: (a,b)-> a and b

  $truncate: (string, maxCount)->
    return string if string.length <= maxCount
    return (string.substr 0, (maxCount - 3)) + '...'

  $mkDate: (date)-> lib.datetime.mkDate date

  $mkDateTime: (ms)->
    if typeof ms is 'undefined'
      return lib.datetime.now()
    else
      return lib.datetime.format((new Date ms), 'mmm d, yyyy h:MMTT')

  $mkTime: (ms)-> lib.datetime.format((new Date ms), 'HH-MM-ss')

  $in: (item, list...)->
    item in list

  $returnSerial: (index)->
    index+1

  $isEmptyArray: (data)->
    if data is 0
      return true
    else
      return false

  $getFullName:(data)->

    if typeof data is "object"
      honorifics = ''
      first = ''
      last = ''
      middle = ''

      if data.honorifics  
        honorifics = data.honorifics + ". "
      if data.first
        first = data.first
      if data.middle
        middle = " " + data.middle
      if data.last
        last = " " + data.last
        
      return honorifics + first + middle + last

    else return data