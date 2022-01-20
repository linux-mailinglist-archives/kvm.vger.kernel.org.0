Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FE9495239
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376956AbiATQS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:18:29 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:8800
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376922AbiATQS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 11:18:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL50P1jwwEz4AVjo9XN+0snfpCrwc3A8MSPhVnJCbXhsmsKuBlG/+LV5bFm7cgOnGhCiDH6oV2nMtiowjBjvGM4OPdhC/wDPlfKw+PqziCXd8t9z0oBGmJJtaGqHmDF6zZF45Uas4u7twW/FNXfENx33tlD1KJak4h9w6oPvVX1A5YAUvHnLg7J3Ya9Z+G7yrdKjZh1jgRUfbiSo4gS6EFBkkZCMm9V3R6aN0uZ6KxM/6EMTKlJEMmf9xqxgfvpxXRNAy5ATU36bSpSKgk+Y/QSVGJS7vesV9xW402CMHI9v3OzcJO2hUx7650Mvk7iXVdWxo+DdOznE/+AJ/h0aIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fNFmrWCfZSBQQSXsoeVuvcacyILkClpEmMP4oqTkUs=;
 b=FzaNYuDiwDcs9sNweHlPVdsq/SaHIkm7cQ5FRp4WKrHopWvDnMR9wPfd+y2iRjj55MDwJesvxw8GJ64w4YKM/AyTElQkpK8zDh1TP8z/0Da3blHmPOtOnswblbpoNu03UCkyX+C02YZ4F4e/1m6IhFF6oRr2nDRryNewjxfnxfxt5y5t+D8N6YE8DVlwcXWoR3wg6SHuThhBL+PQgdBvZjbkKyaB7ylHfJJk5WFKoggu6HJZh3uhpQfd7DBr/rJ9OF2mxA+o1JArCGagGkoUEIfnn9r5NjQ+x2eINibihcL8ArloBPhXQ29tPEaUne3P/NLQQp48jiE24NDlkIl1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fNFmrWCfZSBQQSXsoeVuvcacyILkClpEmMP4oqTkUs=;
 b=3KkydDJGB+/4kfYbcD9wRJVbgEbRJN7ypipI6zF5RSRbdlFY9H+H8ARisIcAvnSnzNJAD0laBqm9UKY3GvDvSSPNgQ0cACVBQkbbdru0t0+hBoyz5zUnYXUjVIGqW4k3q5tqnVYB2v7HiCUdC9k9YugCyhnY5NqDWXAVSMV9fCo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Thu, 20 Jan
 2022 16:18:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%7]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 16:18:24 +0000
To:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        jroedel@suse.de, bp@suse.de
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-2-varad.gautam@suse.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [kvm-unit-tests 01/13] x86/efi: Allow specifying AMD SEV/SEV-ES
 guest launch policy
Message-ID: <1a79ea5b-71dd-2782-feba-0d733f8c2fbf@amd.com>
Date:   Thu, 20 Jan 2022 10:18:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20220120125122.4633-2-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0065.namprd05.prod.outlook.com
 (2603:10b6:803:41::42) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95e8c324-8788-4ea5-647e-08d9dc307bba
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2687E0EEAEB07D914F205FE9EC5A9@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /THJtnXWQDdqCV+0yEjKuBgGTGS+8sTcBBlInH8GeVeThUe6TxiQBH1nr5vfpRWLqOQhebrJ1CljVuYyRASvAgmGWJeKTyoc7FqE3eAWZsJxAR09tNOuZ0qEALonh3o8GdBE+ZUOIyIxfZ5s8pELri93vpBqrgjcH065zmYWDjY75thw2prHni86167B40CiTcHR4CFQX3yZHRQGEs5U447tA0x4OYErTZ7h4N76KUxvUGtangqtUnpKMvMOSZ6QdlGdT5zoZAFKKa51iILym7YUjpdjjkjPcAdYYDv/VCoIQheyjfkmUztJUfTSjSMfPaHEnKoVI7jFsNDWpHC/A0GPg65xjSGiDDU2T7VhlpKpU2YtaReqRzLwjiMjcfpOBnMFX+6XAdpQv4ZVynhdZGKSIs9vjqKJWbsuhjzqYw6HvjA6D3b37sknIwuvJg6jWIn7LF4cnQH3qvumMEkKOfl09k03vWUpD39DYadShD7ISSjLo2EHVm2rpNcM7LQrKiHpROTl+aRwcPqCtQiWI+pOugbgei3Z05V78wSx+xTcwdmtAXqRRhcr4scvXl5LkTBc5rWNa8KOv9VyMJ+/Hr7SjQ3EjdLLhasHvP0hNrziOEltyQXeNZigti5btHaki6LkQQ19BaFKkyYywYNQbiD/h8lG5Gs3enSEYwzZHo6ewIIYDhLMXmGzFMgtGVR+uXm8cVOclon5rjgrRMZf8XbRk24nmopTD//Jwu0sKmmh6cwbr6uLS3UKrry/ezCj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(2616005)(7416002)(2906002)(5660300002)(31696002)(38100700002)(186003)(36756003)(4326008)(66946007)(508600001)(6486002)(66556008)(66476007)(6506007)(8936002)(6512007)(86362001)(8676002)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3BYRldUaC9SejEyNDlJak4yZTdQZjRXOWUzOVNRcC9FTTFueitEOU12VGty?=
 =?utf-8?B?M3RxUW1GVDZLck10VDVVbHRReE9mUVVha2pXM2NsbVF0OURwZXl0TjVxYTFJ?=
 =?utf-8?B?UVA1eVk1bnpHb2VFSTJGdElsR0wrS3ppWkFLUWM3VmNUY3RhaVo0dHFpbXc3?=
 =?utf-8?B?cTI3YmhERUVnQmJCc0VaUmhsUWsyUVE1MG1pRE1yUGhYanJSc2M2M3YyUFAw?=
 =?utf-8?B?bzRhcWc0NC9iaTBTOUFpL1pERTJjT2ZnbFZ1Q0dkQUlhM3FNVVdTcGN5amtl?=
 =?utf-8?B?ZGxHclluVnk4OFVZc3JUbnNzRkhJM0JubEI0OWtxeVh5cjNnUWlMSENrVjMy?=
 =?utf-8?B?TTFSdEpGZDVGZXdkN0RIN3JGSGlOQmplVDVheUtEQkZsdjVzRXZpTGw2Tndo?=
 =?utf-8?B?Vm5kZG9Bc00xMmxoRllIU0ozdWtmVjNCbFJXQ3E3RnYvV0VxVitZRjlQTEUv?=
 =?utf-8?B?dkpqQzd6V0lQb0NDbmlpZTJUOEVGeVdNYlNGMVFVaUo4Qk1ydGp1SWk1d0hi?=
 =?utf-8?B?d2JuRFNtM2FFTkJDUkx0R2kxYXppeHMwaHNLY0hLZFArZGFUdmNwR3lUWmo2?=
 =?utf-8?B?S3NNSXFlbzQzT09OeU5kNVdyenhrZXphSU16emNTSFo4M2x6dFFFUmJ6L1Iv?=
 =?utf-8?B?QStIL2lhZDQ1VjR4VDJlRGtFMUtaQkJoZDduci9kWVBzTlkxL2ltYjJlUmlV?=
 =?utf-8?B?L0NPNHZoOUpSNjZLbEZmUmdEQ2J1aTRYOHJ5ME1pTFF4L0tWbG5ibW9PY2N0?=
 =?utf-8?B?YVJuUEFPZzQxWTlYUzF2dHNRWVhaY2lyZmlKNGFkdGorYzRObEtIRjRZbVV5?=
 =?utf-8?B?L1VJb2x5Rm1hbUQ2Mk9DenR2d3NudDYxY3Y5ckNmYjNDK3pvQlpQU05Ualkr?=
 =?utf-8?B?U0xJVXhhby9lRFlJbElDR1kxUVlhRWFiWWlpT3BVVGlMRTR3SFNJbWxaNE9w?=
 =?utf-8?B?L3JQYU9rcnVXSTE1Ymk1RjRlb3JQcGpiQjhjMUhVc0grVVRCWG0wTlJ5dmV3?=
 =?utf-8?B?QjY4VjVPSVdrMDRuZDUzMk5CRk92UlYrYmJOUlJUOTlJczczRGI0VVBvcC9o?=
 =?utf-8?B?RXhsZHZEb0taZjk0VXhNZlhYK0d3bTZiU08rYWJra3kwcms1cXlDdTAxcTla?=
 =?utf-8?B?cUpYUjdqRmNuS0R2V0ZMZFRkK3lnZGVQOXVpK3I5ZFJ3TTlSS1o2RC9YOFJt?=
 =?utf-8?B?UFEyaWExRmM0QkZkSmV3d1FOa0pOQXVDc3MxSkl1SHFaV2FOaHpScjAvbmtP?=
 =?utf-8?B?M1JqbnRFNUMvdTNjbDIzUCt2ZHJXcGZaZkhTMnRJUmFIdGFhWEhOaFQ0cTRi?=
 =?utf-8?B?NDVkZlBwUzIzc3k0cXZJWHF4ZDlhMEt2OGthRjlBbVhEa2c4ZElVK0pLVG9u?=
 =?utf-8?B?UGFlQ2ZmRThicy9Xem03SGJQVUd2cnlPWkVEZUNoaDl0Mzhjbys0UmdlQjNU?=
 =?utf-8?B?RVBKNjFQVGJCeGVpZ1lzbkxkcEhEZjRqa0pEOS9VcURSOUlDQkNXdGYrUjNK?=
 =?utf-8?B?RnYwVlJlS0dRTXVTU0tOVG41S0paMHBDWUF2MUtMb3BDZVhqU2RiRXcxdHp2?=
 =?utf-8?B?M3pod2pNQ0xvY1RjL1JVK0kvU3ZXVm5KQjZCWFk2cFlQOFZ0aWxTdFRQVUlU?=
 =?utf-8?B?ZjIvVVBYTmZLdzN3Vm5SU0ttbmpHbUljZ01ndVVwQTVrRmZRaFZ3dnlWVnIz?=
 =?utf-8?B?WHo3aXprcUg2V0M3Y3BEekc1MFhCRWpQN2xWWGlHR2xrL3BaRXJiRUtRQldm?=
 =?utf-8?B?djIzdFVFMElMcDU0Q2tiTG8yVnN0Y3VVL3kvUHBNM2s2NCtRSkdwNHIxRzhQ?=
 =?utf-8?B?QlFNUWlOMTdGWFFBV01qNWpEZFVXL0dyM3h5WFF0L0o1cEpSUnYwekhhYlRj?=
 =?utf-8?B?SDZrQ211RVpoY3R0elZ2bWEvOHJ3ZUpTVmpHOWkySVhmZEhKa3hUbmdVWGMw?=
 =?utf-8?B?VjlDWE81eHNSWVdBczdtVnEwMXJBTzY4U0w0M1YrT1h3YjVJY2l0aGNwSkQw?=
 =?utf-8?B?MVJhWUprT2VlVHoxVk9DSjZwUVh1bUh2SVltRHAxRWFFYWNDVmhzS0hzblla?=
 =?utf-8?B?VExoUU5ZdFpnc0hYS0JXaDNhaHlGdzFWTlJ3QWtoRTZxT0ZoY2JoZ1FDOFJ6?=
 =?utf-8?B?WThiUHNvUjFCRXBmRm0xWnErejFLWk1oSlRnL1h4MWo4Ky8vWkd1M2VyWmxz?=
 =?utf-8?Q?mJ/Admcn+rMkFK1NyfYKWCQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e8c324-8788-4ea5-647e-08d9dc307bba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:18:24.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgLT+23y0cSjdW5HDSUnV85/z1TxKCqAY5qytXSEc0d1XJmT0/JL+05LeWHoLrnDkKS0pKVIrm+wGJlrwqA3Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 6:51 AM, Varad Gautam wrote:
> Make x86/efi/run check for AMDSEV envvar and set SEV/SEV-ES parameters
> on the qemu cmdline.
> 
> AMDSEV can be set to `sev` or `sev-es`.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>   x86/efi/README.md |  5 +++++
>   x86/efi/run       | 16 ++++++++++++++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/x86/efi/README.md b/x86/efi/README.md
> index a39f509..1222b30 100644
> --- a/x86/efi/README.md
> +++ b/x86/efi/README.md
> @@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
>   
>       EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
>   
> +To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
> +`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
> +
> +    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
> +
>   ## Code structure
>   
>   ### Code from GNU-EFI
> diff --git a/x86/efi/run b/x86/efi/run
> index ac368a5..b48f626 100755
> --- a/x86/efi/run
> +++ b/x86/efi/run
> @@ -43,6 +43,21 @@ fi
>   mkdir -p "$EFI_CASE_DIR"
>   cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>   
> +amdsev_opts=
> +if [ -n "$AMDSEV" ]; then
> +	policy=
> +	if [ "$AMDSEV" = "sev" ]; then
> +		policy="0x1"
> +	elif [ "$AMDSEV" = "sev-es" ]; then
> +		policy="0x5"
> +	else
> +		echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
> +		exit 2
> +	fi
> +
> +	amdsev_opts="-object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,policy=$policy -machine memory-encryption=sev0"

This won't work on Naples or Rome systems because the cbitpos is 47 on
those machines. You'll need to use CPUID to obtain the proper position for
the system on which you are running.

You can use the cpuid command to get Fn8000001F_EBX[5:0] or I've used
the following to find it from a bash script if you don't want to rely on
the cpuid command being present:

EBX=$(dd if=/dev/cpu/0/cpuid ibs=16 count=32 skip=134217728 | tail -c 16 | od -An -t u4 -j 4 -N 4 | sed -re 's|^ *||')
CBITPOS=$((EBX & 0x3f))

   where 134217728 == 0x80000000

(I'm sure there's probably an easier way, but this works for me, but
does rely on CONFIG_X86_CPUID)

Thanks,
Tom

> +fi
> +
>   # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
>   # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
>   # memory region is ~42MiB. Although this is sufficient for many test cases to
> @@ -61,4 +76,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>   	-nographic \
>   	-m 256 \
>   	"$@" \
> +	$amdsev_opts \
>   	-smp "$EFI_SMP"
> 
