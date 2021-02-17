# PowerShell Class structure

From the beginning af PowerShell we had the possibility to create custom objects, and after the object creation it was possible to add attributes and methods to the object. With PowerShell 5 we also have the possibility to create custom classes. This is a personal study on the subject so do not consider the text or the examples complete of perfect - or even correct.

A custom class is a class defined in PowerShell with the class structure as described in the standard documentation [about_Classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes). The custom class can be rather simple or extremely complex. In the last case you should consider to implement your functionality in C#. In the most extreme case where you want to control every physical detail or have high requirements on performance you could consider to code the entire solution in C++.

The documentation is not a tutorial - as this text is neither - and you should prepare yourself to spend some time on reading materials and experimenting with code.

## Class vs Object

A object is a instance of a class. There can be many objects of the same class, but any object can only be of one class. Values are stored in the object - except static values, more on this later.

## Define a PowerShell class

A PowerShell class is defined in a class structure in a script or module file.

The general structure of a simple class is like this

```powershell
class Person {
  [string]$FirstName
  [string]$LastName
  [int]$BirthYear

  Person() {}
  Person([string]$TheFirstName, [string]$TheLastName) {
    $this.FirstName = $TheFirstName
    $this.LastNAme = $TheLastName
  }

  [int]Age() {
    return [System.DateTime]::Now.Year - $this.BirthYear
  }
}
```

### Attribute

Class attributes hold object values. Attributes can be more complex like arrays or instances of other classes. Actually "types" like `int` or `string` are in really classes in .NET. You should read the documentation on "simple types" in .NET where you can learn a lot about the basic ideas behind .NET.

### $this (automatic variable)

The keyword `$this` is a reference the the given object in the class definition. Can be used in the definition of class methods

### Method

Methods handle the functionality of the object. Default functionality like `ToString()` can be overloaded and given a custom implementation in the class.

### Constructor

### Deconstructor

Inheritance - complex types

### Class definition file

PowerShell does not have a structure to store a given class in a individual file like Java. You could place the class definition in a custom file and dot-include it in the script or module file. This would be a non-standard solution and maybe some kind of over-engineering.

This is not a default construction.

## Create a object of a PowerShell class

### New- CmdLet

You could create a `New-\<class\>` CmdLet wrapper to create a new instance of a custom class in a more PowerShell piping-friendly way. If the function return a custom object of the custom class the the CmdLet would behave like any other PowerShell New-CmdLet.

## Use objects of PowerShell classes

## Static elements

A static element in a class makes the class not thread safe. This is not a real problem in PowerShell as most activities are single-threaded. But if you plan to to use the PowerShell code as a prototype to a C# or another thread-friendly language then you should be aware of the dragon.

## Reference

Microsoft Docs: "[About_Classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes)"

"[Functional PowerShell with Classes](https://medium.com/faun/functional-powershell-with-classes-820c8e9acd8f)"

"[Powershell Classes & Concepts](https://xainey.github.io/2016/powershell-classes-and-concepts/)"

[Introduction to PowerShell Classes](https://overpoweredshell.com/Introduction-to-PowerShell-Classes/)
