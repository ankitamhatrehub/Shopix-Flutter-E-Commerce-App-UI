void main(){
   //check whether number is even or odd
    int num = 42;
    if (num % 2 == 0) {
      print("Even NUmber");
    } else {
      print("Odd Number");
    }

//find largest number from the list
    List<int> numbers = [11, 82, 37, 42, 5];
    int largest = numbers[0];
    for (int num in numbers) {
      if (num > largest) {
        largest = num;
      }
    }
    print(largest);

    //find even numbers from the list
    List<int> evenNumbers = [2, 4, 88, 90, 45, 66];
    List<int> even = [];
    for (int num in evenNumbers) {
      if (num % 2 == 0) {
        even.add(num);
      }
    }
    print(even);


    //check whether "Madam" is palindrome or not
    String str = "jamaj";
    String text = "";
    for (int i = str.length - 1; i >= 0; i--) {
      text = text + str[i];
    }
    if (str == text) {
      print("Palindrome");
    } else {
      print("Not Palindrome");
    }

    // remove duplicate numbers
    List<int> num1 = [1, 2, 3, 4, 5, 90, 6, 7, 8, 9, 1, 2, 3, 4];
    List<int> unique = num1.toSet().toList();
    print(unique);

    // find factorial number of 5
    int number = 4;
    int fac = 1;
    for (int i = 1; i <= number; i++) {
      fac = fac *= i;
    }
    print(fac);

    //count vowels in a string
    String str1 = "ankita shelke";
    int count = 0;
    for (int i = 0; i < str1.length; i++) {
      if (("aeiou").contains(str1[i].toLowerCase())) {
        count++;
      }
    }
    print(count);



// find second largest number from the list
    List<int> numbers1 = [11, 82, 37, 42,5];
    List<int> lar = numbers1.toSet().toList();
    lar.sort();
    print(lar[lar.length - 2]);

 String name = "ankita shelke";
  String result = "";
  for (int i = name.length - 1; i >= 0; i--) {
    result = result + name[i];
  }

  print(result);
  reverseString("Tanuj");
}
//reverse string using split and join method
String reverseString(String name) {
  String str = name.split("").reversed.join();
  print(str);
  return str;
}
