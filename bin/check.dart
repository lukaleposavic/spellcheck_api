import 'dart:convert';
import 'dart:collection';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

String spellcheck(String textParam){
final Map<String,List> spell= HashMap();
 var errorList = [];
 var suggestionsList = [];
  final text = textParam;

  CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  final spellCheckerFactory = SpellCheckerFactory.createInstance();

  final supportedPtr = calloc<Int32>();
  final languageTagPtr = 'sr-Latn-ME'.toNativeUtf16();
  
  spellCheckerFactory.IsSupported(languageTagPtr, supportedPtr);
  

  if (supportedPtr.value == 1) {
    final spellCheckerPtr = calloc<COMObject>();
    spellCheckerFactory.CreateSpellChecker(
        languageTagPtr, spellCheckerPtr.cast());

    final spellChecker = ISpellChecker(spellCheckerPtr);

    final errorsPtr = calloc<COMObject>();
    final textPtr = text.toNativeUtf16();
    spellChecker.ComprehensiveCheck(textPtr, errorsPtr.cast());

    final errors = IEnumSpellingError(errorsPtr);
    final errorPtr = calloc<COMObject>();
    

    print('Input: "$text"');
    //print('Errors:');

    //var errorCount = 0;

    while (errors.Next(errorPtr.cast()) == S_OK) {
      //errorCount++;
suggestionsList=[];
      final error = ISpellingError(errorPtr);
      final word = text.substring(
        error.StartIndex,
        error.StartIndex + error.Length,
      );

     // stdout.write('$errorCount. $word');

      switch (error.CorrectiveAction) {
        case CORRECTIVE_ACTION.DELETE:
          print(' - delete');
          break;

        case CORRECTIVE_ACTION.NONE:
          print('\n');
          break;

        case CORRECTIVE_ACTION.REPLACE:
          final replacment = error.Replacement;
          print(' - replace with "${replacment.toDartString()}"');
          WindowsDeleteString(replacment.address);
          break;

        case CORRECTIVE_ACTION.GET_SUGGESTIONS:
          //print(' - suggestions:');

          final wordPtr = word.toNativeUtf16();
          final suggestionsPtr = calloc<COMObject>();
          spellChecker.Suggest(wordPtr, suggestionsPtr.cast());
          final suggestions = IEnumString(suggestionsPtr);

          final suggestionPtr = calloc<Pointer<Utf16>>();
          final suggestionResultPtr = calloc<Uint32>();

          while (
              suggestions.Next(1, suggestionPtr, suggestionResultPtr) == S_OK) {
       
            suggestionsList.add(suggestionPtr.value.toDartString());
            
           
            WindowsDeleteString(suggestionPtr.value.address);
          }
         
          break;
      }
     
      errorList.add(word.toString());
     
     spell.addAll({word.toString():suggestionsList});
      error.Release();
      
    }
print(spell);


    errors.Release();
    free(textPtr);
    spellChecker.Release();
  }

  free(supportedPtr);
  free(languageTagPtr);

  spellCheckerFactory.Release();

  CoUninitialize();
  var spellings = <String,Map>{
   'spelling':spell,
 };

 var result = <String,Map>{
   'suggestions':spellings,
 };
  return jsonEncode(result);

}