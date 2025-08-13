# Add-AzPrivateDnsConditionalFowarders

This is a PowerShell cmdlet script to quickly add your Azure Private DNS Zones as Conditional Forwarders on a Windows DNS server. Use the same region as your Azure Enterprise Scale Landing Zone deployment.

Some resource types have region-specific domains that might be outside your ESLZ deployment region if you have workloads elsewhere. This script will not add those.