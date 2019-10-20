<#
.DESCRIPTION
  Simple VIXCOM solution to focus on get something working...  
#>

# (https://www.autoitscript.com/forum/topic/163266-vmware-automation-using-vixcomvixlib/)


Local $lib
Local $host
Local $job
Local $vm
Local $result

Global Const $VIX_API_VERSION = ????
Global Const $VIX_SERVICEPROVIDER_VMWARE_WORKSTATION = ???
Global Const $VIX_PROPERTY_JOB_RESULT_HANDLE = ???
Global Const $VIX_VMPOWEROP_LAUNCH_GUI = ???

$lib = ObjCreate("VixCOM.VixLib")

; Connect to the local installation of Workstation. This also initializes the VIX API.
$job = $lib.Connect($VIX_API_VERSION, $VIX_SERVICEPROVIDER_VMWARE_WORKSTATION, '', 0, '', '', 0, Null, Null)

; $results needs to be initialized before it's used, even if it's just going to be overwritten.
$results = Null

; Wait waits until the job started by an asynchronous function call has finished. It also
; can be used to get various properties from the $job. The first argument is an array
; of VIX property IDs that specify the properties requested. When Wait returns, the
; second argument will be $to an array that holds the values for those properties,
; one for each ID requested.
$err = $job.Wait(Array($VIX_PROPERTY_JOB_RESULT_HANDLE), $results)
If $lib.ErrorIndicatesFailure($err) Then
   ; Handle the $error...
EndIf

; The job result handle will be first element in the $results array.
$host = $results(0)

; Open the virtual machine with the given .vmx file.
$job = $host.OpenVM("c:\Virtual Machines\vm1\win2000.vmx", Null)
$err = $job.Wait(Array($VIX_PROPERTY_JOB_RESULT_HANDLE), $results)
If $lib.ErrorIndicatesFailure($err) Then
   ; Handle the $error...
EndIf

$vm = $results(0)

#; Power on the virtual machine we just opened. This will launch Workstation if it hasn't
#; already been started.
$job = $vm.PowerOn($VIX_VMPOWEROP_LAUNCH_GUI, Null, Null)
#; WaitWithoutResults is just like Wait, except it does not get any properties.
$err = $job.WaitWithoutResults()
If $lib.ErrorIndicatesFailure($err) Then
   #; Handle the $error...
EndIf

#; Wait until VMware Tools are running within the guest, with a 300 second timeout.
$job = $vm.WaitForToolsInGuest(300, Null)
$err = $job.WaitWithoutResults()
If $lib.ErrorIndicatesFailure($err) Then
   #; Handle the $error...
EndIf

$job = $vm.LoginInGuest("vixuser", "secret", 0, Null)
$err = $job.WaitWithoutResults()
If $lib.ErrorIndicatesFailure($err) Then
   #; Handle the $error...
EndIf

$job = $vm.RunProgramInGuest("c:\myProgram.exe", "/flag arg1 arg2", 0, Null, Null)
$err = $job.WaitWithoutResults()
If $lib.ErrorIndicatesFailure($err) Then
   #; Handle the $error...
EndIf

$results = Null
$job = Null
$vm = Null

$host.Disconnect()
