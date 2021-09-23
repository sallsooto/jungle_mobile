class DateConverter{
    static String dateToString(DateTime date){
      String maDate=date.toString().substring(0,10);
    return maDate;
    }

    static String timeStampToJson(DateTime date){
      String heure=(date.hour>9?date.hour.toString():"0"+date.hour.toString());
      String minutes=(date.minute>9?date.minute.toString():"0"+date.minute.toString());
      String secondes=(date.second>9?date.second.toString():"0"+date.second.toString());
      String maDate=date.toString().substring(0,10)+"T"+heure+":"+minutes+":"+secondes+"Z";
      print(maDate);
      return maDate;
    }

    static DateTime stringToDate(String formattedString){
      try{
        return DateTime.parse(formattedString);
      }catch(e){
        print('erreur de conversion stringToDate');
      }
      return null;
    }

}