Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BD27C6329
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 05:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347040AbjJLDAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 23:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjJLDA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 23:00:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE36A4;
        Wed, 11 Oct 2023 20:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka81iNLa9xl/zkiOE6UUb2ug66uDGgL0vVKE5KB8AcqUGBXz3OY2tLcPVmJa4kfpuZwPdOPZ1nafBvdArAJxO8bOT6Ea+dmgDhAqikxSFlhMe9d8DfAJClICNQ75sI5zlmLCyhxVHHexs7lF3JqdOGExa4QTe32GA8k4XPEMaboy6VK+skrDOola3TIX/P5ayn4fP/XLAfL+f7ZhF8i/OveGkffCrW2K91lIY7OdZJscsOvnEl3j8qWFi+Gop1159l+W4IZRAIAmd804IHHQB9Evbs8d0xcGvNz1ddmPNjGsCVi2rwwbNNP2dSuRCmAQengxQ8fY9zyJG7V9Qh3qLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e13qO/xuQU475O4hp1XmngZbhrxnXOen17X7uQqkiuQ=;
 b=SwDjpMSfX+YWld090Q+sBEstD7gLAw7ENx4qo9WYuqvOaKdvNAM8JDtaS4cz7VtYjG8daF8tUslCchenYQJ3kxI/HzCjxBs8mDz83Gh6BdgcLRkTsZnRwqajkj2N4liOk8v+wci6pMoGa+AxHhqDovnXzWUywPMlI02cRrhvlAIz8ai5SlmIyzFNnPNvc8xSL3vpw62oRiAHPjFaee2KxosEgw60tLkW4rEc5xs822Caa2JAajMd5zRqLO69y2XLdUoKW4pXxzQ/MOOEOS0FQGVyqIxiBHVv2nDxzAJjVwnivKGplJGpECflkFSgpCjzzU3sFFnyJ8JxW97vZkafLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e13qO/xuQU475O4hp1XmngZbhrxnXOen17X7uQqkiuQ=;
 b=GKLHvZN+P2lMQxiePH5Px3BX9qMwzZSE54lCmHESyWcS19M4YItdBkOmHFksjJTWpiQZ7Na4tvPnXp4iGoT84/YhPjOwakF+fW+28lTM1Za3LQsodWXhOT1IZxNluTJXtnRdjUyf7ypeH7TOrD/m4wVY6dw5cyrNMcZ0qMJpW8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Thu, 12 Oct
 2023 03:00:22 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Thu, 12 Oct 2023
 03:00:22 +0000
Message-ID: <95d87143-43a1-4140-af08-b4e9ea09b32a@amd.com>
Date:   Thu, 12 Oct 2023 14:00:00 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] PCI device authentication
Content-Language: en-US
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de> <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
 <20231010081913.GA24050@wunner.de>
 <2a21b730-9ad4-4585-b636-9aa139266f94@amd.com>
 <20231011175746.00003d57@Huawei.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231011175746.00003d57@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYAPR01CA0010.ausprd01.prod.outlook.com (2603:10c6:1::22)
 To CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: b50da1f8-de5f-4afe-1333-08dbcacf5fa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZ3FVCpVGOY8O4Sv+CaPVjCCNR4oc4Kstmi69Rqwol3wtCGliceKei1nuGGCdby78Zq5nMBlR0u5Bh1aM22+UOlSICefsfnNwUf4dAt/wqRFXeMdUKvGT0WzDGX0cTlz57YNzDGcRdR2PV6c4O4gKwywIyJc07qWFwNAjOv4cUkgSDvzYsn1eC+sntgRUUtWFkxMDpf8AcHvZRwE/cWR9RCNV8DwQKaq+4uz7gLf1aR3L8lgEEA7oQKGkH3iI95wGtVQMTAP8D3eDB+Owczcw1BK6YeVVUr0wVSGZD0CgT//uQl8tPnNlTNSStB7khfOnsH61/jq1P4Jmv4Ggcdi/vMi43+029pPY6byhWj6WK+RMdcII9xb0MT6eXxSXqo7UfpU4vS1TpCaKA1AnQMluPjeaGfhTIgvwQ7WeaXHhJZX/afIC8A0k5CzkoXxnl6Y2mRC850CU34K1WxeOXBkDO1cBTbR6byC6cNmpfGR9qVrjR2IMbeXv6SWF01n7DCx8u9VpQaXd3LfHrV3QA0uJEjybmlSU5RpPdpSjzrnlAaYMIdboI2kTbtfskx7IFc20JIGmaBzDGHZn/M6gwrfreq9/7Wy2xZkC2UmUK7prTYCgxBxvay7vo7lgTu0sb0YEqmgNHZo4mk3MIpfcumxHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(396003)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(4326008)(8676002)(8936002)(2906002)(6486002)(31686004)(5660300002)(478600001)(6666004)(6506007)(31696002)(53546011)(6512007)(7416002)(41300700001)(36756003)(38100700002)(316002)(83380400001)(6916009)(66946007)(26005)(54906003)(66556008)(66476007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODVNK2ZSM1RCQml5dGQ4RTdXUzYrRmV4cVV2ZUFZZ2YrbnZHbGJ4UmdYV1lK?=
 =?utf-8?B?RDVPbStKckhrYnhHQTh1Y1pWZVgvTHFTbmRKNk1hK3I4SjE4clhWaHBTTWox?=
 =?utf-8?B?TXhLUXpGMHcvZGU2dU9ML2t1eEl3ckZqSG9LdzV3YjhNMkQ5SDVaYTdqV2Ja?=
 =?utf-8?B?QmdXOE1BdmoxUGpRVk5KT2xSRndJUFlpMFNVWGxsTThhejhTOE9iNXRqenQ3?=
 =?utf-8?B?UFpqNCtlcUNWT3B1d3BwMDZGR2pvN1lhUm1DY2ZhbkNqTXZ5aEtyVjYwMG4r?=
 =?utf-8?B?WXJEQ1h0U1NhWVBGU2xvY3poSVBDT200SXhSMjRBNWxiQUZyenBWSUwxRHV2?=
 =?utf-8?B?Y0Q4dFZCRkZnUGl0QTdxQ2Rjd1lRZjVkeTJEZ2I5NURQRUhOcEpzRTF5WXBK?=
 =?utf-8?B?UDRvVGNCczU1K3RNaVdkQ2lnbTZPTEpBcnVEeE45UGlwVEhXMGpiOVhua0Zv?=
 =?utf-8?B?SHI3N29mcFJIeWtoYzluQjVEYUl2cmk1dXVETFQ3bTlKV29tZzVwU2oyRlU2?=
 =?utf-8?B?bHBmZmgyZEVkditObWpVVDg4RnRDWTdNZ2lMaDYxemlMZjVSbDNRanBlOU8x?=
 =?utf-8?B?cUlIU1F3SkNiSjc3YVVCelBSNlZkNXdOaWRaeWNkUVRZZy9TQTd4MVV0eWhz?=
 =?utf-8?B?czQxMk5MK0tKcTFJVU53VG40ZjQ0bWF2a1p6Q1U0enJac3IyNlNSK2xqNGtL?=
 =?utf-8?B?K29yaFZwaC9JaFpBYWRhQnNDNk5XYldCcUp4YVFoamE5cFplaG1TQkx6Q0JH?=
 =?utf-8?B?T2dDRUlOZGJEcGg0VGdrdkF5alhqN3JzdzVvTlhnWkJ1bFYzR2tWa1NaOWZx?=
 =?utf-8?B?WlVWbDVVMkxaRWMvU3ZWSGFTNFN1WUlQUXI1RHlPSWROdjhsa0N3b2J6aVNO?=
 =?utf-8?B?blBySXE2YnlBZUVCc1ZieFVCclNRd3lEK1QwNjNkVGYzSlV3Q0UrN2VvYTBX?=
 =?utf-8?B?a01iOW9JYnUySHpldkdZZ044cjZTbXdQZWVabFhYU0RxdjFRcnhQRTRJckR2?=
 =?utf-8?B?SnBjMGEzeVYyc0NpemU2UXFjeFEwVTB6TDNRSy9LRXhGdWVxbGxrOGFSQ1p4?=
 =?utf-8?B?dTIvYWJPYmE2QWFoeVFSd0krMUR6dFA1MjREVlRXZXpIVnhtMFhEQngxckdq?=
 =?utf-8?B?cEErcnJyTkI3eDJyWEozRVVDSnZJczRES3NPSld3Wnhuc2hGTG5MVWp6NDFJ?=
 =?utf-8?B?QlJpSDFROGdSeVo0MWx5RlpoWXdQbzdValAyQ1JCeGdrM2MzQmZQL1RZdDZT?=
 =?utf-8?B?ZWhmMTlmSGUyT1JVR1Y2amFON1B1U3JjYVFWTXV4QkY4SndXRTlHb3JSZGZr?=
 =?utf-8?B?ei84cTd2Wkw5elh3SFR5MnpnWUJKdmpQT3ZKdER5WTBUeVBBdXg0dlliWTQ3?=
 =?utf-8?B?QWJvdnJOcEdpWTFiNkdNbFkxeDE3SyswOWYrOGpBZ0lOMGxWSnhrMG5FNXg2?=
 =?utf-8?B?MDFlaXdSZmtRUkhtTzFuYWFPRFZTZnZkVFNzRzRHempObjlTV1pTUTVRR3hW?=
 =?utf-8?B?cWJnbmltZytVcHNVMERKMHlDQmV3cG10eUxhOUY4TVBrMkROZnJpbHJoUVhr?=
 =?utf-8?B?SVBEdlRUWVoyNHNCUEkrYnRqRUdsZlUyRUQycGkxc2h1aW9yNHhIeEZwRmtL?=
 =?utf-8?B?YnpkdSsxc2t5R3hIL2JtemxLekNwb2hZV09PMVRPclA0aEFXeEdhWnQxWGl5?=
 =?utf-8?B?MkVKRitwZWFwOS9GUXJmUUdwUWFsakdQNSthcVhFbTRJTFFIdGNrakEycDQ1?=
 =?utf-8?B?MGNoKzBpR1dnMm80WDJGNXUrRlNhRENzNjVDYTRYK0ZleFJUNUxSeW5WSVVF?=
 =?utf-8?B?b29RaFFyNlBXbTNiUUh1RWFjaUNmMEV3SzBuZHJaUWtIazFPdzNpWHlsWVg2?=
 =?utf-8?B?VHVOdWJsQ1YwK09mQ2l6dzMrVUxWVjJWTTdBaysraUpRcWI4RXQ4ZFdQQkVB?=
 =?utf-8?B?aEdrQmRxQ1dKb2VwUDdvS2NkT1hvK082d3NUZytncmw3c3NGWDlCYUlYL2pG?=
 =?utf-8?B?cUprYmhMZnFsOHBMbUVzZmxGNmxZK1FsUVpVUUZxaEg5b3JlQkdSb2pZRjVQ?=
 =?utf-8?B?bWFvQjRwVWVmcFBiSURZVGdFTjhkS1JKVnNqdU5HRVllQjByUHVsa01CNXJ2?=
 =?utf-8?Q?Bkw1ZKD0Qa73jne/w+Cj3645w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50da1f8-de5f-4afe-1333-08dbcacf5fa7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 03:00:21.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dmPHPNcL0fB0z6bbcrH2PzZjUp/E826mw3GfEsUPl5t1nufuFWLJhCc8ggMVl9wufL4x5k3DOL6iS49uiGKGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/10/23 03:57, Jonathan Cameron wrote:
> On Tue, 10 Oct 2023 23:53:16 +1100
> Alexey Kardashevskiy <aik@amd.com> wrote:
> 
>> On 10/10/23 19:19, Lukas Wunner wrote:
>>> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
>>>> On 10/10/23 00:49, Lukas Wunner wrote:
>>>>> PCI Firmware Spec would seem to be appropriate.  However this can't
>>>>> be solved by the kernel community.
>>>>
>>>> How so? It is up to the user to decide whether it is SPDM/CMA in the kernel
>>>> or   the firmware + coco, both are quite possible (it is IDE which is not
>>>> possible without the firmware on AMD but we are not there yet).
>>>
>>> The user can control ownership of CMA-SPDM e.g. through a BIOS knob.
>>> And that BIOS knob then influences the outcome of the _OSC negotiation
>>> between platform and OS.
>>>
>>>    
>>>> But the way SPDM is done now is that if the user (as myself) wants to let
>>>> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
>>>> as CMA is not a (un)loadable module or built-in (with some "blacklist"
>>>> parameters), and does not provide a sysfs knob to control its tentacles.
>>>
>>> The problem is every single vendor thinks they can come up with
>>> their own idea of who owns the SPDM session:
>>>
>>> I've looked at the Nvidia driver and they've hacked libspdm into it,
>>> so their idea is that the device driver owns the SPDM session.
>>   >
>>> AMD wants the host to proxy DOE but not own the SPDM session.
>>   >
>>> We have *standards* for a reason.  So that products are interoperable.
>>
>> There is no "standard PCI ethernet device", somehow we survive ;)
>>
>>> If the kernel tries to accommodate to every vendor's idea of SPDM ownership
>>> we'll end up with an unmaintainable mess of quirks, plus sysfs knobs
>>> which were once intended as a stopgap but can never be removed because
>>> they're userspace ABI.
>>
>> The host kernel needs to accommodate the idea that it is not trusted,
>> and neither is the BIOS.
>>
>>> This needs to be solved in the *specification*.
>>   >
>>> And the existing solution for who owns a particular PCI feature is _OSC.
>>> Hence this needs to be taken up with the Firmware Working Group at the
>>> PCISIG.
>>
>> I do like the general idea of specifying things, etc but this place does
>> not sound right. The firmware you are talking about has full access to
>> PCI, the PSP firmware does not have any (besides the IDE keys
>> programming), is there any example of such firmware in the PCI Firmware
>> spec? From the BIOS standpoint, the host OS owns DOE and whatever is
>> sent over it (on AMD SEV TIO). The host OS chooses not to compose these
>> SPDM packets itself (while it could) in order to be able to run guests
>> without having them to trust the host OS.
> 
> As a minimum I'd like to see something saying - "keep away from discovery
> protocol on this DOE instance".  An ACPI _OSC or _DSM or similar could do that.
> It won't be needed for every approach, but it might for some.

I am relying on the existing DOE code to do the discovery. No APCI in 
the SEV TIO picture.

> Then either firmwware knows what to do, or a specific driver does.
> 
> If your proxy comes up late enough that we've already done (and cached) discovery
> protocols results then this might not be a problem for this particular
> approach as we have no reason to rerun discovery (other than hotplug in which
> case there is lots of other stuff to do anyway).
> 
> For your case we need some hooks for the PSP to be able to drive the SPDM session
> but that should be easy to allow. 

This is just a couple of calls:
doe_md = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG, 
PCI_DOE_PROTOCOL_SECURED_CMA_SPDM);
and
pci_doe(doe_mb, PCI_VENDOR_ID_PCI_SIG, 
PCI_DOE_PROTOCOL_SECURED_CMA_SPDM, ...)


> I don't think precludes the hypervisor also
> verifying the hardware is trusted by it along the way (though not used for IDE).
> So if you are relying on a host OS proxy I don't thing you need to disable CONFIG_CMA
> (maybe something around resets?)

If I do the above 2 calls, then pdev->spdm_state will be out of sync.

> Potentially the host OS tries first (maybe succeeds - that doesn't matter though
> nothing wrong with defense in depth) and then the PSP via a proxy does it all over
> again which is fine.  All we need to do is guarantee ordering and I think we are
> fine for that.

Only trusted bits go all over again, untrusted stuff such as discovery 
is still done by the host OS and PSP is not rerunning it.


> Far too many possible models here but such is life I guess.

True. When I joined the x86 world (quite recently), I was surprised how 
different AMD and Intel are in everything besides the userspace :)


>>>> Note, this PSP firmware is not BIOS (which runs on the same core and has
>>>> same access to PCI as the host OS), it is a separate platform processor
>>>> which only programs IDE keys to the PCI RC (via some some internal bus
>>>> mechanism) but does not do anything on the bus itself and relies on the host
>>>> OS proxying DOE, and there is no APCI between the core and the psp.
>>>
>>> Somewhat tangentially, would it be possible in your architecture
>>> that the host or guest asks PSP to program IDE keys into the Root Port?
>>
>> Sure it is possible to implement. But this does not help our primary use
>> case which is confidential VMs where the host OS is not trusted with the
>> keys.
>>
>>> Or alternatively, access the key registers directly without PSP involvement?
>>
>> No afaik, for the reason above.


-- 
Alexey


