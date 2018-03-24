/**
 * @polymerBehavior
*/

if (!app.behaviors.local.visitUtilsMixin) {
  app.behaviors.local.visitUtilsMixin = {};
}
app.behaviors.local.visitUtilsMixin = {

  $of: function (a, b) {
    if (!(b in a)) {
      a[b] = null;
    }
    return a[b];
  },

  _isEmpty: function (data) {
    if (data === 0) {
      return true;
    } else {
      return false;
    }
  },

  _isEmptyArray: function (data) {
    if (data.length === 0) {
      return true;
    } else {
      return false;
    }
  },

  _isEmptyString: function (data) {
    if ((data === null) || (data === '') || (data === 'undefined')) {
      return true;
    } else {
      return false;
    }
  },

  _compareFn: function (left, op, right) {
    // lib.util.delay 5, ()=>
    if (op === '<') {
      return left < right;
    }
    if (op === '>') {
      return left > right;
    }
    if (op === '==') {
      return left === right;
    }
    if (op === '>=') {
      return left >= right;
    }
    if (op === '<=') {
      return left <= right;
    }
    if (op === '!=') {
      return left !== right;
    }
  },

  _sortByDate: function (a, b) {
    if (a.lastModifiedDatetimeStamp < b.lastModifiedDatetimeStamp) {
      return 1;
    }
    if (a.lastModifiedDatetimeStamp > b.lastModifiedDatetimeStamp) {
      return -1;
    }
  },

  _computeTotalDaysCount: function (endDate, startDate) {
    if (!endDate) { return (this.$TRANSLATE('As Needed', this.LANG)); }
    const oneDay = 1000 * 60 * 60 * 24;
    startDate = new Date(startDate);
    endDate = new Date(endDate);
    const diffMs = endDate - startDate;
    return this.$TRANSLATE((Math.round(diffMs / oneDay)), this.LANG);
  },

  _returnSerial: function (index) {
    return index + 1;
  },

  _computeAge: function (dateString) {
    const today = new Date();
    const birthDate = new Date(dateString);
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();

    if ((m < 0) || ((m === 0) && (today.getDate() < birthDate.getDate()))) {
      age--;
    }

    return age;
  },

  _formatDateTime(dateTime) {
    return lib.datetime.format((new Date(dateTime)), 'mmm d, yyyy h:MMTT');
  }

};