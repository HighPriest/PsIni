﻿function Out-Keys {
    param(
        [Parameter()]
        [Switch]
        $Append,

        [Parameter( Mandatory )]
        [Char]
        $CommentChar,

        [Parameter( Mandatory )]
        [String]
        $Delimiter,

        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]
        $InputObject,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Encoding = "UTF8",

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $IgnoreComments,

        [Parameter()]
        [Switch]
        $SkipTrailingEqualSign
    )

    begin {
        $outputLines = @()
    }

    process {
        if (-not ($InputObject.Keys)) {
            Write-Verbose "$($MyInvocation.MyCommand.Name):: No data found in '$InputObject'."
            return
        }

        foreach ($key in $InputObject.Keys) {
            if ($key -like "Comment*") {
                if ($IgnoreComments) {
                    Write-Verbose "$($MyInvocation.MyCommand.Name):: Skipping comment: $key"
                }
                else {
                    Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing comment: $key"
                    $outputLines += "$CommentChar$($InputObject[$key])"
                }
            }
            elseif (-not $InputObject[$key]) {
                Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing key: $key without value"
                $keyToWrite = if ($SkipTrailingEqualSign) { "$key" } else { "$key$delimiter" }
                $outputLines += $keyToWrite
            }
            else {
                foreach ($entry in $InputObject[$key]) {
                    Write-Verbose "$($MyInvocation.MyCommand.Name):: Writing key: $key"
                    $outputLines += "$key$delimiter$entry"
                }
            }
        }
    }

    end {
        return $outputLines
    }
}
