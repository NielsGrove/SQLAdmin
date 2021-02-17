# PowerShell Class structure

1. [Class vs Object](#Class-vs-Object)
1. [Define a PowerShell class](#Define-a-PowerShell-class)

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

### Definition in embedded C\#

With the CmdLet [`Add-Type`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type) you can add a .NET class to a PowerShell session. Or you can use the CmdLet to define a class with embedded C#. There is a nice example in the `Add-Type` documentation. But doing it this way does it very difficult to debug the script. On the other hand this solution could be usefull when you already have a class defined i C# and want a simple file structure without dll-file(s).

### Attribute

Class attributes hold object values. Attributes can be more complex like arrays or instances of other classes. Actually "types" like `int` or `string` are in really classes in .NET. You should read the documentation on "simple types" [Built-in types](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/built-in-types) in .NET / C# where you can learn a lot about the basic ideas behind .NET.

### $this (automatic variable)

The keyword `$this` is a reference the the given object in the class definition. Can be used in the definition of class methods

### Method

Methods handle the functionality of the object. Default functionality like `ToString()` can be overloaded and given a custom implementation in the class.

The only output from a method is from the return statement. `Write-Output` then gives nothing, but other CmdLets that does not give a direct output like `Write-Host`, `Write-Debug`, `Write-Warning` or `Write-Error` can give output to the console. The method signature can be regarded as a contract on the output. Only the output from the return statement will go into the execution pipeline.
(https://stackoverflow.com/questions/52757670/why-does-write-output-not-work-inside-a-powershell-class-method)

### Constructor

The class constructor can be the default constructor or a parametrized constructor or both. In any case the constructor is named like the class and has a structure like a method.

### Deconstructor

De deconstructor is always named `Dispose()` and never takes parameters.

Inheritance - complex types

### Class definition file

PowerShell does not have a structure to store a given class in a individual file like Java. You could place the class definition in a custom file and dot-include it in the script or module file. This would be a non-standard solution and maybe some kind of over-engineering.

This is not a default construction.

## Class interface

## Create a object of a PowerShell class

A object cal be created with the PowerShell CmdLet `New-Object` or by calling the implicit static method `New()`.

```powershell
$Person10 = New-Object Person
$Person11 = New-Object Person 'Alice', 'McDonald'

$Person20 = [Person]::New()
$Person21 = [Person]::New('Joe', 'McDonald')
```

Also you could cast a hash table on the default constructor. (Example...)

### New- CmdLet

You could create a `New-\<class\>` CmdLet wrapper by a advanced function to create a new instance of a custom class in a more PowerShell piping-friendly way. If the function return a custom object of the custom class the the CmdLet would behave like any other PowerShell `New-` CmdLet.

Also such a function in a PowerShell module will make it possible the create a object from a stript using the module.

## Use objects of PowerShell classes

Piping to a object...

## Static elements

A static element in a class makes the class not thread safe. This is not a real problem in PowerShell as most activities are single-threaded. But if you plan to to use the PowerShell code as a prototype to a C# or another thread-friendly language then you should be aware of the dragon.

## Reference

Microsoft Docs: "[About_Classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes)"

"[Functional PowerShell with Classes](https://medium.com/faun/functional-powershell-with-classes-820c8e9acd8f)"

"[Powershell Classes & Concepts](https://xainey.github.io/2016/powershell-classes-and-concepts/)"

[Introduction to PowerShell Classes](https://overpoweredshell.com/Introduction-to-PowerShell-Classes/)
