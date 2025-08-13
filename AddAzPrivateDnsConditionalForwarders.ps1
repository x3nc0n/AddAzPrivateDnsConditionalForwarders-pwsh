function Add-AzPrivateDnsConditionalForwarders {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$regionName,

        [Parameter()]
        [ValidateSet("Forest", "Domain")]
        [string]$ReplicationScope = "Forest"
    )

    $validRegions = @{
        "changeme" = "changeme"
        "australiacentral" = "acl"
        "australiacentral2" = "acl2"
        "australiaeast" = "ae"
        "australiasoutheast" = "ase"
        "brazilsoutheast" = "bse"
        "brazilsouth" = "brs"
        "canadacentral" = "cnc"
        "canadaeast" = "cne"
        "centralindia" = "inc"
        "centralus" = "cus"
        "centraluseuap" = "ccy"
        "chilecentral" = "clc"
        "eastasia" = "ea"
        "eastus" = "eus"
        "eastus2" = "eus2"
        "eastus2euap" = "ecy"
        "francecentral" = "frc"
        "francesouth" = "frs"
        "germanynorth" = "gn"
        "germanywestcentral" = "gwc"
        "israelcentral" = "ilc"
        "italynorth" = "itn"
        "japaneast" = "jpe"
        "japanwest" = "jpw"
        "koreacentral" = "krc"
        "koreasouth" = "krs"
        "malaysiasouth" = "mys"
        "malaysiawest" = "myw"
        "mexicocentral" = "mxc"
        "newzealandnorth" = "nzn"
        "northcentralus" = "ncus"
        "northeurope" = "ne"
        "norwayeast" = "nwe"
        "norwaywest" = "nww"
        "polandcentral" = "plc"
        "qatarcentral" = "qac"
        "southafricanorth" = "san"
        "southafricawest" = "saw"
        "southcentralus" = "scus"
        "southeastasia" = "sea"
        "southindia" = "ins"
        "spaincentral" = "spc"
        "swedencentral" = "sdc"
        "swedensouth" = "sds"
        "switzerlandnorth" = "szn"
        "switzerlandwest" = "szw"
        "taiwannorth" = "twn"
        "uaecentral" = "uac"
        "uaenorth" = "uan"
        "uksouth" = "uks"
        "ukwest" = "ukw"
        "westcentralus" = "wcus"
        "westeurope" = "we"
        "westindia" = "inw"
        "westus" = "wus"
        "westus2" = "wus2"
        "westus3" = "wus3"
    }

    if (-not $validRegions.ContainsKey($regionName)) {
        Write-Warning "Region '$regionName' is not valid. Skipping conditional forwarders for this region."
        return
    }

    $regionCode = $validRegions[$regionName]

    $dnsZones = @(
        "privatelink.azurecr.io"
        "{regionName}.data.privatelink.azurecr.io"
        "privatelink.azconfig.io"
        "privatelink.azurewebsites.net"
        "privatelink.guestconfiguration.azure.com"
        "privatelink.his.arc.azure.com"
        "privatelink.dp.kubernetesconfiguration.azure.com"
        "privatelink.siterecovery.windowsazure.com"
        "privatelink.azure-automation.net"
        "privatelink.batch.azure.com"
        "privatelink.directline.botframework.com"
        "privatelink.search.windows.net"
        "privatelink.cognitiveservices.azure.com"
        "privatelink.cassandra.cosmos.azure.com"
        "privatelink.gremlin.cosmos.azure.com"
        "privatelink.mongo.cosmos.azure.com"
        "privatelink.documents.azure.com"
        "privatelink.table.cosmos.azure.com"
        "privatelink.{regionName}.kusto.windows.net"
        "privatelink.adf.azure.com"
        "privatelink.datafactory.azure.net"
        "privatelink.azuredatabricks.net"
        "privatelink.blob.core.windows.net"
        "privatelink.eventgrid.azure.net"
        "privatelink.servicebus.windows.net"
        "privatelink.afs.azure.net"
        "privatelink.azurehdinsight.net"
        "privatelink.azureiotcentral.com"
        "privatelink.azure-devices.net"
        "privatelink.azure-devices-provisioning.net"
        "privatelink.vaultcore.azure.net"
        "privatelink.{regionName}.azmk8s.io"
        "privatelink.api.azureml.ms"
        "privatelink.notebooks.azure.net"
        "privatelink.grafana.azure.com"
        "privatelink.media.azure.net"
        "privatelink.prod.migration.windowsazure.com"
        "privatelink.monitor.azure.com"
        "privatelink.oms.opinsights.azure.com"
        "privatelink.ods.opinsights.azure.com"
        "privatelink.agentsvc.azure-automation.net"
        "privatelink.redis.cache.windows.net"
        "privatelink.service.signalr.net"
        "privatelink.{regionCode}.backup.windowsazure.com"
        "privatelink.queue.core.windows.net"
        "privatelink.dfs.core.windows.net"
        "privatelink.file.core.windows.net"
        "privatelink.web.core.windows.net"
        "privatelink.table.core.windows.net"
        "privatelink.dev.azuresynapse.net"
        "privatelink.sql.azuresynapse.net"
        "privatelink.wvd.microsoft.com"
        "privatelink.webpubsub.azure.com"
    )

    foreach ($zone in $dnsZones) {
        $zone = $zone -replace "{regionName}", $regionName
        $zone = $zone -replace "{regionCode}", $regionCode
        $domain = $zone -replace "^privatelink\\.", ""
        Add-DnsServerConditionalForwarderZone -Name $domain -MasterServers "168.63.129.16" -ReplicationScope $ReplicationScope
    }
}