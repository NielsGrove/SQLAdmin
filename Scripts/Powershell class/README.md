# PowerShell Class structure

1. [Class vs Object](#Class-vs-Object)
1. [Define a PowerShell class](#Define-a-PowerShell-class)
1. [Class interface](#Class-interface)
1. [Create a object of a PowerShell class](#Create-a-object-of-a-PowerShell-class)
1. [Use objects of PowerShell classes](#Use-objects-of-PowerShell-classes)
1. [Static elements](#Static-elements)
1. [Reference](#Reference)

From the beginning af PowerShell we had the possibility to create custom objects, and after the object creation it was possible to add attributes and methods to the object. With PowerShell 5 we also have the possibility to create custom classes. This is a personal study on the subject so do not consider the text or the examples complete of perfect - or even correct.

A custom class is a class defined in PowerShell with the class structure as described in the standard documentation [about_Classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes). The custom class can be rather simple or extremely complex. In the last case you should consider to implement your functionality in C\#. In the most extreme case where you want to control every possible physical detail or have high requirements on performance you could consider to develop the entire solution in C++.

The documentation is not a tutorial - as this text is neither - and you should prepare yourself to spend some time on reading materials and experimenting with code.

## Class vs Object

A object is a instance of a class. There can be many objects of the same class, but any object can only be of one class. Values are stored in the object - except static values, more on this later.

## Define a PowerShell class

A PowerShell custom class is defined in a class structure in a script or module file.

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

Example on a simple class in [`SimpleClass.ps1`](https://github.com/NielsGrove/SQLAdmin/blob/master/Scripts/sandbox/Powershell%20class/SimpleClass.ps1).

Example on a class with full definition in [`FullClass.ps1`](https://github.com/NielsGrove/SQLAdmin/blob/master/Scripts/sandbox/Powershell%20class/FullClass.ps1).

### Inheritance

A simple example on association is in the script file `Association.ps1`. A very dynamic object model where each wheel on a vehicle can have individual diameter...

See more in the documentation [Inheritance in PowerShell classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.1&source=docs#inheritance-in-powershell-classes) where a more formal inheritance is used in the example.

Some consider inheritance as complex types.

Inheritance from a .NET class is also possible with a syntax similar to plain PowerShell class inheritance.

### Interface

(https://stackoverflow.com/questions/32065124/can-we-implement-net-interfaces-in-powershell-scripts)

### Definition in embedded C\#

With the CmdLet [`Add-Type`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type) you can add a .NET class to a PowerShell session. Or you can use the CmdLet to define a class with embedded C#. There is a nice example in the `Add-Type` documentation. But doing it this way does it very difficult to debug the script. On the other hand this solution could be usefull when you already have a class defined i C# and want a simple file structure without dll-file(s).

Another way is to put the C\# definition of the class in a PowerShell [here-string)[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.1#here-strings]. This makes it possible to use the more advanced class features of C\#

### Attribute

Class attributes hold object values. Attributes can be more complex like arrays or instances of other classes. Actually "types" like `int` or `string` are in really classes in .NET. You should read the documentation on "simple types" [Built-in types](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/built-in-types) in .NET / C# where you can learn a lot about the basic ideas behind .NET.

### Member Validation
Validation on attribute (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.1#example-using-validation-attributes)

**Read-Only Attribute** is relevant as a PowerShell class can not be defined with operators like `Set` and `Get`. By setting one attribute it can be relevant at the same time to change the value of another attribute. This could be one attribute `SizeB` that holds the size of a storage area in Bytes and another attribute `SizeGB` holds the size of the same storage area but in GigaBytes, so when updating `SizeB` the value of `SizeGB` should be updated in the same operation. And It should not be possible at all to change the value of `SizeGB` direct.

[PowerShell Classes with readonly properties](https://ocram85.com/2017-07-19-ReadOnly-Class-Properties/)

### $this (automatic variable)

The keyword `$this` is a reference to the given object in the class definition. Can be used in the definition of class methods.

### Method

Methods handle the functionality of the object. Default functionality like `ToString()` can be overloaded and given a custom implementation in the class.

There can not be defined a method with the same name as a attribute. This actually makes sense. Also a method should be named with a verb to keep things clear.

The only output from a method is from the return statement. `Write-Output` then gives nothing, but other CmdLets that does not give a direct output like `Write-Host`, `Write-Debug`, `Write-Warning` or `Write-Error` can give output to the console. The method signature can be regarded as a contract on the output. Only the output from the return statement will go into the execution pipeline.
(https://stackoverflow.com/questions/52757670/why-does-write-output-not-work-inside-a-powershell-class-method)

### Constructor

The class constructor can be the default constructor or a parametrized constructor or both. In any case the constructor is named like the class and has a structure like a method. The Constructor can be overloaded with parameters. If you want both a default constructor without parameters and a constructor with parameter they can both be defined in the class definition.

### Deconstructor

The deconstructor in a class is always named `Dispose()` and never takes parameters. A deconstructor can be used to close resources like database connections when a given object of the defined class is released from memory. Some litterature call this element a destructor, but that I think is not correct as the element reverse the construction of the given object.

Inheritance - complex types

### Class definition file

PowerShell does not have a structure to store a given class in a individual file like Java. You could place the class definition in a custom file and dot-include it in the script or module file. This would be a non-standard solution and maybe some kind of over-engineering.

This is not a default construction.

One example on this construction is in the class definition file `Example.class.ps1` and the script file `ExampleUsage.ps1` using the defined class to create three objects.

## Class interface

(TBD)

## Create a object of a PowerShell class

This is a very short collection of very personal thought on a creating a custom PowerShell object.

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

### Piping

The only output from a method is from the return statement. `Write-Output` then gives nothing, but other CmdLets that does not give a direct output like `Write-Host`, `Write-Debug`, `Write-Warning` or `Write-Error` can give output to the console. The method signature can be regarded as a contract on the output. Only the output from the return statement will go into the execution pipeline.

StackOverflow: [Why does Write-Output not work inside a PowerShell class method](https://stackoverflow.com/questions/52757670/why-does-write-output-not-work-inside-a-powershell-class-method).

Piping to a custom class object...

## Use objects of PowerShell classes

Piping to a object...

## Static elements

A static element in a class makes the class not thread safe. This is not a real problem in PowerShell as most activities are single-threaded. But if you plan to to use the PowerShell code as a prototype to a C# or another thread-friendly language then you should be aware of the dragon.

## Reference

Microsoft Docs: "[About_Classes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes)"

"[Functional PowerShell with Classes](https://medium.com/faun/functional-powershell-with-classes-820c8e9acd8f)"

"[Powershell Classes & Concepts](https://xainey.github.io/2016/powershell-classes-and-concepts/)"

[Introduction to PowerShell Classes](https://overpoweredshell.com/Introduction-to-PowerShell-Classes/)
