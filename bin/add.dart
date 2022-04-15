import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void add(String word){
  
  final text = word;

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

  spellChecker.Add(text.toNativeUtf16());
print(text);
  spellChecker.Release();
  }
    free(supportedPtr);
  free(languageTagPtr);

  spellCheckerFactory.Release();

  CoUninitialize();

  }

void main(List<String> args) {

  add("spojzis");
  
}