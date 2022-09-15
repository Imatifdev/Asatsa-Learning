// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/model/area_dropdown_model.dart';
import 'package:qixer/model/country_dropdown_model.dart';
import 'package:qixer/model/states_dropdown_model.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

class CountryStatesService with ChangeNotifier {
  var countryDropdownList = [];
  var countryDropdownIndexList = [];
  var selectedCountry;
  var selectedCountryId;

  var statesDropdownList = [];
  var statesDropdownIndexList = [];
  // var oldStateDropdownList;
  // var oldStatesDropdownIndexList = [];
  var selectedState;
  var selectedStateId;

  var areaDropdownList = [];
  var areaDropdownIndexList = [];
  var selectedArea;
  var selectedAreaId;

  bool isLoading = false;

  // setStateAndAreaValueToDefault() {
  //   statesDropdownList = oldStateDropdownList;
  //   statesDropdownIndexList = oldStatesDropdownIndexList;
  //   notifyListeners();
  // }

  setCountryValue(value) {
    selectedCountry = value;
    notifyListeners();
  }

  setStatesValue(value) {
    selectedState = value;
    notifyListeners();
  }

  setAreaValue(value) {
    selectedArea = value;
    notifyListeners();
  }

  setSelectedCountryId(value) {
    selectedCountryId = value;
    print('selected country id $value');
    notifyListeners();
  }

  setSelectedStatesId(value) {
    selectedStateId = value;
    print('selected state id $value');
    notifyListeners();
  }

  setSelectedAreaId(value) {
    selectedAreaId = value;
    print('selected area id $value');
    notifyListeners();
  }

  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

//Set country based on user profile
//==============================>

  setCountryBasedOnUserProfile(BuildContext context) {
    selectedCountry = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .country
            .country ??
        'Select Country';
    selectedCountryId = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .countryId ??
        '0';

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

//Set state based on user profile
//==============================>
  setStateBasedOnUserProfile(BuildContext context) {
    selectedState = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .city
            .serviceCity ??
        'Select State';
    selectedStateId = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .city
            .id ??
        '0';
    print(statesDropdownList);
    print(statesDropdownIndexList);
    print('selected state $selectedState');
    print('selected state id $selectedStateId');
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   notifyListeners();
    // });
  }

  //Set area based on user profile
//==============================>
  setAreaBasedOnUserProfile(BuildContext context) {
    selectedArea = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .area
            .serviceArea ??
        'Select Area';
    selectedAreaId = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .area
            .id ??
        '0';
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   notifyListeners();
    // });
  }

  fetchCountries(BuildContext context) async {
    if (countryDropdownList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setLoadingTrue();
      });
      var response = await http.get(Uri.parse('$baseApi/country'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        var data = CountryDropdownModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < data.countries.length; i++) {
          countryDropdownList.add(data.countries[i].country);
          countryDropdownIndexList.add(data.countries[i].id);
        }

        setCountry(context, data: data);

        notifyListeners();
        fetchStates(selectedCountryId, context);
      } else {
        //error fetching data
        countryDropdownList.add('Select Country');
        countryDropdownIndexList.add('0');
        selectedCountry = 'Select State';
        selectedCountryId = '0';
        fetchStates(selectedCountryId, context);
        notifyListeners();
      }
    } else {
      //country list already loaded from api
      setCountry(context);
      fetchStates(selectedCountryId, context);
      // set_State(context);
      // setArea(context);
    }
  }

  fetchStates(countryId, BuildContext context) async {
    //make states list empty first
    statesDropdownList = [];
    statesDropdownIndexList = [];
    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });

    var response =
        await http.get(Uri.parse('$baseApi/country/service-city/$countryId'));
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = StatesDropdownModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.serviceCities.length; i++) {
        statesDropdownList.add(data.serviceCities[i].serviceCity);
        statesDropdownIndexList.add(data.serviceCities[i].id);
      }

      //keeping the data
      // oldStateDropdownList = statesDropdownList;
      // oldStatesDropdownIndexList = oldStatesDropdownIndexList;

      set_State(context, data: data);
      notifyListeners();
      fetchArea(countryId, selectedStateId, context);
    } else {
      fetchArea(countryId, selectedStateId, context);
      //error fetching data
      statesDropdownList.add('Select State');
      statesDropdownIndexList.add('0');
      selectedState = 'Select State';
      selectedStateId = '0';
      notifyListeners();
    }
  }

  fetchArea(countryId, stateId, BuildContext context) async {
    //make states list empty first
    areaDropdownList = [];
    areaDropdownIndexList = [];
    notifyListeners();

    var response = await http.get(Uri.parse(
        '$baseApi/country/service-city/service-area/$countryId/$stateId'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = AreaDropdownModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.serviceAreas.length; i++) {
        areaDropdownList.add(data.serviceAreas[i].serviceArea);
        areaDropdownIndexList.add(data.serviceAreas[i].id);
      }

      setArea(context, data: data);
      notifyListeners();
    } else {
      areaDropdownList.add('Select area');
      areaDropdownIndexList.add('0');
      selectedArea = 'Select area';
      selectedAreaId = '0';
      notifyListeners();
    }
  }

  setCountry(BuildContext context, {data}) {
    var profileData =
        Provider.of<ProfileService>(context, listen: false).profileDetails;
    //if profile of user loaded then show selected dropdown data based on the user profile
    if (profileData != null) {
      setCountryBasedOnUserProfile(context);
    } else {
      if (data != null) {
        selectedCountry = data.countries[0].country;
        selectedCountryId = data.countries[0].id;
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

//==============>
  set_State(BuildContext context, {data}) {
    var profileData =
        Provider.of<ProfileService>(context, listen: false).profileDetails;

    if (profileData != null) {
      var userCountryId = Provider.of<ProfileService>(context, listen: false)
          .profileDetails
          .userDetails
          .countryId;

      if (userCountryId == selectedCountryId) {
        //if user selected the country id which is save in his profile
        //only then show state/area based on that

        setStateBasedOnUserProfile(context);
      } else {
        if (data != null) {
          selectedState = data.serviceCities[0].serviceCity;
          selectedStateId = data.serviceCities[0].id;
        }
      }
    } else {
      if (data != null) {
        selectedState = data.serviceCities[0].serviceCity;
        selectedStateId = data.serviceCities[0].id;
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

// ==================>
  setArea(BuildContext context, {data}) {
    var profileData =
        Provider.of<ProfileService>(context, listen: false).profileDetails;

    if (profileData != null) {
      var userCountryId = Provider.of<ProfileService>(context, listen: false)
          .profileDetails
          .userDetails
          .countryId;
      if (userCountryId == selectedCountryId) {
        //if user selected the country id which is save in his profile
        //only then show state/area based on that

        setAreaBasedOnUserProfile(context);
      } else {
        if (data != null) {
          selectedArea = data.serviceAreas[0].serviceArea;
          selectedAreaId = data.serviceAreas[0].id;
        }
      }
    } else {
      if (data != null) {
        selectedArea = data.serviceAreas[0].serviceArea;
        selectedAreaId = data.serviceAreas[0].id;
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }
}
