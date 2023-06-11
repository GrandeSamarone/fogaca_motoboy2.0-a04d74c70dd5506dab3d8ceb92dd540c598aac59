
 abstract class ILocalStorage{
 Future readData(String key);
 Future deleteData(String key);
 Future saveData(String key,dynamic value);
}