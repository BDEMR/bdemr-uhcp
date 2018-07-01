
app.behaviors.commonComputes = 

  $equals: (left, right)-> left is right

  $if: (value, thenValue, elseValue)-> if value then thenValue else elseValue

  $iff: (value)-> value

  $sum: (a,b)-> a + b

  $and: (a,b)-> a and b

  $truncate: (string, maxCount)->
    return string if string.length <= maxCount
    return (string.substr 0, (maxCount - 3)) + '...'

  $mkDate: (date)-> 
    return '' unless date
    lib.datetime.mkDate date


  $compareFn: (left, op, right)->
    if (op=='<')
      return left < right
    if (op=='>')
      return left > right
    if (op=='==')
      return left == right
    if (op=='>=')
      return left >= right
    if (op=='<=')
      return left <= right

  $mkDateTime: ()-> Date.now()

  $mkTime: (ms)-> lib.datetime.format((new Date ms), 'HH-MM-ss')

  $formatDate: (date)->
    return '' unless date
    lib.datetime.format((new Date date), 'mmm d, yyyy')
  
  $formatDateTime: (dateTime)->
    return '' unless dateTime
    formatObj = { 
      timeZone: 'Asia/Dhaka' 
      day: 'numeric'
      month: 'short'
      year: 'numeric'
      hour: '2-digit'
      minute: '2-digit'
    }
    # lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')
    return new Date(dateTime).toLocaleString('en-GB', formatObj)

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


  $makeNameObject: (fullName)->

    if typeof fullName is 'string'

      fullName = fullName.trim()

      partArray = fullName.split('.')

      namePart = partArray.pop()

      if partArray.length is 0 
        honorifics = ''
      else
        honorifics = partArray.join('.').trim()

      partArray = (namePart.trim()).split(' ')

      nameObject = {}

      if (partArray.length <= 1)
        first = partArray[0]
      else
        first = partArray.shift()
        last = partArray.pop()
        middle = partArray.join(' ')

        if middle is ''
          middle = null
        
        if last is ''
          last = null

      if honorifics is ''
        honorifics = null

      nameObject.honorifics = honorifics
      nameObject.first = first
      nameObject.middle = middle
      nameObject.last = last
      return nameObject
    else
      return fullName


  $getProfileImage: (data)->
    if data
      return data
    else
      return 'images/avatar.png'

  $checkUserAccess: (accessId)->
    currentOrganization = @getCurrentOrganization()

    if accessId is 'none'
      return true
    else
      if currentOrganization

        if currentOrganization.isCurrentUserAnAdmin
          return true
        else if currentOrganization.isCurrentUserAMember
          if currentOrganization.userActiveRole
            privilegeList = currentOrganization.userActiveRole.privilegeList
            unless privilegeList.length is 0
              for privilege in privilegeList
                if privilege.serial is accessId
                  return true
          else
            return true

          return false
        else
          return false

      else
        # @navigateToPage "#/select-organization"
        return true

  $computeAge: (dateString)->
    return 'N/A' unless dateString
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()
    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    return age
      
