import 'package:flutter_test/flutter_test.dart';
import 'package:housekeeper_v1/commons.dart';

void main() {
  group("Testing User class", () {
    test(
      "Given that we instantiate a User instance"
          "When setting and getting user properties"
          "Then the User instance should have the correct properties",
          () {
        User user = User();
        user.setName("John");
        user.setSurname("Doe");
        user.setPassWord("securepassword");
        user.email = "john.doe@example.com";

        expect(user.getName(), "John");
        expect(user.surname, "Doe");
        expect(user.password, "securepassword");
        expect(user.getEmail(), "john.doe@example.com");
      },
    );



    test(
      "Given that we instantiate a User instance"
          "When converting the user instance to JSON"
          "Then the resulting JSON should have the correct structure",
          () {
        User user = User();
        user.email = "john.doe@example.com";
        user.setName("John");
        user.setSurname("Doe");
        user.setPassWord("securepassword");

        Map<String, dynamic> jsonResult = user.toJson();

        expect(jsonResult['email'], "john.doe@example.com");
        expect(jsonResult['name'], "John");
        expect(jsonResult['surname'], "Doe");
        expect(jsonResult['password'], "securepassword");
      },
    );

    test(
      "Given a JSON representation of a user"
          "When converting it to a User instance"
          "Then the resulting User instance should have the correct properties",
          () {
        Map<String, dynamic> jsonUser = {
          'email': 'john.doe@example.com',
          'name': 'John',
          'surname': 'Doe',
          'password': 'securepassword',
        };

        User user = User.fromJson(jsonUser);

        expect(user.email, "john.doe@example.com");
        expect(user.getName(), "John");
        expect(user.surname, "Doe");
        expect(user.password, "securepassword");
      },
    );
  });

  group("Testing Unit class", () {
    test(
      "Given that we instantiate a Unit instance"
          "When setting and getting unit properties"
          "Then the Unit instance should have the correct properties",
          () {
        Unit unit = Unit();
        unit.setName("Living Room");
        UnitType type = UnitType(name: 'Living Room Type');
        unit.setType(type);

        expect(unit.getName(), "Living Room");
        expect(unit.getType().name, 'Living Room Type');
      },
    );

    test(
      "Given that we instantiate a Unit instance"
          "When converting the unit instance to JSON"
          "Then the resulting JSON should have the correct structure",
          () {
        Unit unit = Unit();
        unit.setName("Kitchen");
        UnitType type = UnitType(name: 'Kitchen Type');
        unit.setType(type);

        Map<String, dynamic> jsonResult = unit.toJson();

        expect(jsonResult['name'], "Kitchen");
        expect(jsonResult['type']['name'], 'Kitchen Type');
      },
    );

    test(
      "Given a JSON representation of a unit"
          "When converting it to a Unit instance"
          "Then the resulting Unit instance should have the correct properties",
          () {
        Map<String, dynamic> jsonUnit = {
          'name': 'Bedroom',
          'type': {'name': 'Bedroom Type'},
        };

        Unit unit = Unit.fromJson(jsonUnit);

        expect(unit.getName(), 'Bedroom');
        expect(unit.getType().name, 'Bedroom Type');
      },
    );
  });


}

