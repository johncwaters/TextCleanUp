# Import module
Import-Module -Name C:\Repos\Powershell-Scripts\Modules\TextCleanUp

function CleanDateString {
    <#
.PARAMETER String
    Specifies the String of what will be adjusted, input: 'Tuesday, December 21, 2021 3:58:05 PM'
.EXAMPLE
    Remove-StringSpecialCharacter -String "Tuesday, December 21, 2021 3:58:05 PM"
    Returns "12/21/2021 3-58-05 PM"
#>
    [CmdletBinding()]

    param(
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Alias('Text')]
        [System.String[]]$String
    )

    PROCESS {
        try {
            #'Tuesday, December 21, 2021 3:58:05 PM'
            #$format = 'dddd mmmm dd yyyy hh:mm:ss tt'
            
            $newString = $String[0]
            $lengthTotal = $newString.Length

            #split string between date and time
            #"Tuesday, December 21, 2021"
            $newdate = $newString.Substring(0, $lengthTotal - 11)
            #"3:58:05 PM"
            $timesub = $newString.Substring($lengthTotal - 10, 10)
            #"3-58-05 PM"
            $time = $timesub -replace ":","-"

            # Trim day of the week - ex 'Tuesday December 21 2021'
            $dateNoChar = Remove-StringSpecialCharacter -String $newdate -SpecialCharacterToKeep " "

            # Create new datetime object to adjust format
            $dateObject = [Datetime]::ParseExact($dateNoChar, 'dddd MMMM dd yyyy', $null).ToString('MM/dd/yyyy')

            $String = $dateObject + " " + $time
			
			Return $String

            # trim receivedTime
            #$receivedTimeCut = $receivedTime.Substring(0, $receivedTime.Length - 9)
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
Export-ModuleMember -Function CleanDateString

