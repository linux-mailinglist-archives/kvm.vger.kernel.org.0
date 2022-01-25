Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA5349B530
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiAYNgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:36:37 -0500
Received: from mail-mw2nam12on2057.outbound.protection.outlook.com ([40.107.244.57]:22712
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1577518AbiAYNeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:34:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLFFolFZmcr3ILUgzdFEeAW5TMcAqbTihC3mmVg/Gge/PANuwAScPklcn5qU8fEogoyJ21pGR3tUsOQ1Hf9pMSLJiqg22l13ykj2+HY+Kthqzw7s/p3DTje9V02GhqN1gHzbyE5BanAbO60TC6DE2nOq4LZEAFj9Qn3ljJH3XxAIwsqkNefRQyxIHQjwzVUp3Ui70Sz2Cco+SOOFKsy6ABKw/9uS1n6y8quPBizO0vcHAUUy2rwqmVg39Twaf79QYsjRQTbd7APiK2AQFJk0XlP+WMWb2S6DhEaOSYJ47QkfsiJjj+7HZ5yIxs/KiAL/SyOrUNg5d3YIOrMUjcbtpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy3XKV6VRRIzvOqKjiNV9hpubTWnFWj6GxmFwd0sI+s=;
 b=iYjDFEX94rfEooE8HRej1QEt2uEalT3LDBb9vIJXPZllAQEPD6F0e3IeMBpExeoW5T4xxLa8nr1ApjQD4DcttUhPJ9TVzLcDMwJk8IakZ/9dbtildPZosOjiUVYwL6ng5cEA8J2QvhEIzToDYUY4Tnuoc1YYzN7fMNkyua9k2EOW365YqmIbJJjcbMU2JvwizlDFsMP3pEUQVxBmsUc4vrQtYj8vnyWw9aDi4XKtSvxPK6GVIh9/aannUg/lTPlyqbjtmMrK0c3otIwX2Ab9BZNdmJC2CCYgCxuTGIAKznwRLYhMoei8SwIunNFqes0emSq8DXjdZXS+0p3QD0TOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy3XKV6VRRIzvOqKjiNV9hpubTWnFWj6GxmFwd0sI+s=;
 b=TBgkaIDQojeyytY4greB3i8dHd2SmrM9aMUGvTz5nr/KZ2GZzntPnLpJ2MNEruj8H5K4QiPcKpZOe52a4DMKDWHGvEKUPU8EmkWg4d1vZiRv1mC07WD5ldmTcfX9FOBmhrJfBfdwIHvWGVh/XHGdN9ZZxTK1XgIxU8wq7hNoIY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DM5PR12MB1737.namprd12.prod.outlook.com (2603:10b6:3:10e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 13:34:09 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::b07d:3a18:d06d:cb0b]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::b07d:3a18:d06d:cb0b%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 13:34:09 +0000
Message-ID: <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
Date:   Tue, 25 Jan 2022 19:03:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Content-Language: en-US
To:     James Turner <linuxkernel.foss@dmarc-none.turner.link>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
 <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link>
 <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87ee4wprsx.fsf@turner.link>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <87ee4wprsx.fsf@turner.link>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::20)
 To BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcdca2e8-2026-4be6-a383-08d9e0075d4c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1737:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1737EC32FE004D1F4FE6B6A5975F9@DM5PR12MB1737.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EOvfatr5hRpZqc8Du7BmcuqJPIAfySbAv2eSl2hBHA994xGJSzNWcHlkcdUsYiPaqHXam6+ZIQkLS28hYttZ/3nNmv2u28Cg6jyfZXmZyVSbW0g8KAlolcHW+dVVl0+0Elr8aJNICxaJTK10TSb8/5biBapn1I8DGlbCjWL+Q8ziD7KDqNTVmuLXHSCIy4455HFO/ysklTAwoAl6QbeJ2eFuS3bF/Q7+Jwo9fYzB0+Wd0nr3+zNnx0Y/j86XXHIRopbdPvh2Y1PeVWndwk0D6NVOlilLY17hZLyncq1CqI/Vue721iyZQQQVip2nvnphdwNlU7x1HxuoodX363uc4NsC1uMv1P4Zwnv49cfLu+2OoxFG7A9+wPOG2/nbZyT+Z7AzuKIGML6bTrA19fEizFlM7b9PlXGhxP2X6Av7wjeNGucbm02U5Ote/dm0zD5ZNscUfwfYWOo5K3QacIWgNnkEawDXpwlrmZZzmI7yJN7E2YJYCIx4R5X7QeGzpxiMFn13huEw9g/UbRJmteQ9k1/vb19CD21UslKGPq+ICe+8v88DR9VW5fGxDQx0STSFwaSptLvCKkA7hfDUYoGj7mJorx40fy3APoB0vlcPkk+VM//YeCB4tMekbieP3hJUdiXBU9CKHMaer0cgQTdebSVlAONrY7XtXpTvSOdm7Hn6A3+mo4OeYq0iPXKTjuU8byZt2a/pq7Lr5LHQgrQ5EsMev9uzO207S12KPbsdnFn1lAJbIdzJShhnjGry9IXIo9tomFmBmklQOhxM8KFh+7+KkDyDa18UrGqL/sjhozc3Riv+DZc7gm7BazC3zSKD7MjlxrH0DnO7QNAenpC6o4dm2ePI8V0+nHdeslmhbnbCckf48H8/yqCFoGMXp8CCn2xVkLKMRVHswYEOrNIbFxedG4AT/RgFbTHIrraSndM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(316002)(86362001)(66476007)(8936002)(2616005)(66556008)(31686004)(6506007)(54906003)(36756003)(83380400001)(38100700002)(5660300002)(4326008)(66946007)(53546011)(186003)(6512007)(508600001)(6916009)(6666004)(966005)(26005)(6486002)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RW9JL0kzWXEvaDg3RE5CUnQ3Rmh1N1Nsa2R5NUVhTGRtR2VUV2htRExlc05G?=
 =?utf-8?B?VGxBbEFuSDNQdXArRHdsMmVrZGEzemNkQmxVdzlKZ0gwRGJzNzdhOFJ5TmVI?=
 =?utf-8?B?UlhOcUpiRXBXcXNWZEd5b3gxM3FqVUduUmJTTzlZbW9FNzBqbytNMlJKL1Q4?=
 =?utf-8?B?MENkQ09OWkxHN0xvM01VRzY5UnVWOTZyUkFhdXBqNGY4cDFOUVUxNzkzTnJZ?=
 =?utf-8?B?Y0lPbFhDYUF2Y3RJeXBUcjljNDBLUk1DM0ltZFdhd1Y1MGpZWUZ5Vm9pZ2pw?=
 =?utf-8?B?em9pLzgxM3NQSVBoeENDMWJNbUZwS3AwdlVDeEY5QU5FMlc3M2xjQ2NublRv?=
 =?utf-8?B?aXFBREN3UGFqZ0p0Ymc0Z2xtYi9wcFR4c25OUVlyNVhLY0FJa1VIVk5UYm1x?=
 =?utf-8?B?dHc5U0RwcFllMjUyMlpEL2E1dzRseitKSVh0NUhDcHhnNy90eUZDY2dnV3Yv?=
 =?utf-8?B?M0RRSUNVSGRCMEVBMm5PMkdkMWN0ZGMvY3pJL1k1UnFSdkRlMmhYc1dReS84?=
 =?utf-8?B?UTdsc2swY25YSXRJeWRlSXQxWkY1NjBhZW1OZ1ByME4wWURsQ0JQaldQQzZB?=
 =?utf-8?B?Tk52a1dBRjVJR3VHTDNjd2J5RjFIcmFnTDh6YXV4dFprbm9qVzJKWXl0a2pE?=
 =?utf-8?B?NlVyOG5VdWNOeWxEcFBQQTZUMjYrWlkzMnlSWDVSWnFyRnBTTVp3OFhYaEh0?=
 =?utf-8?B?dHpOMDFNVnJMcUlSMDcvTDZuMUtPeWN1TEYxemxHQ0tDNi8yZTJrWTJINmI2?=
 =?utf-8?B?T2hvdzJ1Q1JaLy84bDJ2VGt2UHYvNFRnRW1vQVJTN09xQk9hUy9jOTVsaVBP?=
 =?utf-8?B?Um55ZUJYTUc0UTEvcHA1bjR3RFN5Q0MrU3dtMm5pZjRJRERjZjBSOTZmODRm?=
 =?utf-8?B?NjVyNEFoL3BWR1VLU2VqUmFuQTY2Rm9QOUdlU1Z4aWVJYkxLVS9tcDBRREVu?=
 =?utf-8?B?ekFUTTJoQ0lCcHFqOWYrWTNVeUJLNHFEbzg4Q2dqSEdwdnNIY092dHZiUmJ1?=
 =?utf-8?B?ZTV2UkZOOENmczNzTkVCb2lhT0hrWGliN3BRcWlqeFAxdDE3akZMcTl3OHNl?=
 =?utf-8?B?WkVBM3VOOXN3Vi9lZFRHcGtHZzBlelJJb25xN2RlUFhpQ216VE5SR1pMdklH?=
 =?utf-8?B?NFU5V3NnZUdIcThPWDV2RUhqb1p6RndJRHFwbG41ZEx6VzFYUVcwNEFFelhB?=
 =?utf-8?B?eGhMekpoZVdYR3RLZTRGNUtWZ0tqNEJrbzhYN0E4K1VLRUlNdHZrU0c3anlU?=
 =?utf-8?B?d0loL1ljb3UwZ3VNUkJkaHNJKzIxM3BxTkNJRUw2YU5xVHBSbXFuTHVjVk5B?=
 =?utf-8?B?amFIRDVEaEF0SzFsY3JvV29tQ09mUVc5L0xOellnaVN5VDRFVzlqcXhBbU5N?=
 =?utf-8?B?UFVNeWxLTVRaU3ZmR2tiakFyV21QZGVNNm5ZS1NiK3FQeGNvR2NRczYvbzBn?=
 =?utf-8?B?b2daeGc2ZkNWWmRPdWRhR1BvR0NtdUI4TWpxSmwwam5oRnEzVUtFMDNIRzhp?=
 =?utf-8?B?K1RpcTN6MXVlZndzYlkyZGJ5NHl5YW1RME9VbGZ1eURSY0YzRFNGU3pscE9j?=
 =?utf-8?B?VnNJZWpMR2swbkM1NmZZcndKcHBqQnJvcnlIQ1h1K25qNGt2QURBVVJzRlVu?=
 =?utf-8?B?RkFaUUdQWkMzQ2hpRjdySU1uK0NUbCtoeHAyNXo1dzNJZHhja2VEL2xBdDFI?=
 =?utf-8?B?S202WGJLbDZETTVic0xPdDArZ2JzM293ZVk4eEVwWU5UWFVncjE5MnYyaVNJ?=
 =?utf-8?B?MjI1d2dtaVc0SHdVMFBBSkp0M3MvWE9Md1VtVzZySStZSXVtSmdHZVQyZmxP?=
 =?utf-8?B?OEV1YTQyaGdlalRiWm1nM0lYZFZVRjk4MHNuaUtpMllIWU5MTHZEZml3NFVC?=
 =?utf-8?B?MjhDSGdoOXhXUFFFUHFxWWgvbm02alNNV1lMRm51YXRTaThZZGoybFgxbzVT?=
 =?utf-8?B?cXNSeTI2TFhKU3oxenpGOU43T1RsRWJFOFN4TDl1a0MzZUR0UmRJdStTVGgy?=
 =?utf-8?B?ZjQvNDVHeUlnbk1iQjMreWRYNXRMY21SbW5HUERyckhaMnlFcWhoejh0QlRP?=
 =?utf-8?B?dGI2K1hGUkdQK2pQM3NIc1V3TVB1OEVKMVVxbE13T2lMb2owZ2pCRXhOcWtI?=
 =?utf-8?Q?9cSI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdca2e8-2026-4be6-a383-08d9e0075d4c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 13:34:08.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6AYg8pYkLtWa82/EQuKa6twuF33Gpg2WJmaY2Rn30kMx600QdA2r/v5viSJKILY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1737
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/25/2022 5:28 AM, James Turner wrote:
> Hi Lijo,
> 
>> Not able to relate to how it affects gfx/mem DPM alone. Unless Alex
>> has other ideas, would you be able to enable drm debug messages and
>> share the log?
> 
> Sure, I'm happy to provide drm debug messages. Enabling everything
> (0x1ff) generates *a lot* of log messages, though. Is there a smaller
> subset that would be useful? Fwiw, I don't see much in the full drm logs
> about the AMD GPU anyway; it's mostly about the Intel GPU.
> 
> All the messages in the system log containing "01:00" or "1002:6981" are
> identical between the two versions.
> 
> I've posted below the only places in the logs which contain "amd". The
> commit with the issue (f9b7f3703ff9) has a few drm log messages from
> amdgpu which are not present in the logs for f1688bd69ec4.
> 
> 
> # f1688bd69ec4 ("drm/amd/amdgpu:save psp ring wptr to avoid attack")
> 
> [drm] amdgpu kernel modesetting enabled.
> vga_switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
> ATPX version 1, functions 0x00000033
> amdgpu: CRAT table not found
> amdgpu: Virtual CRAT table created for CPU
> amdgpu: Topology: Add CPU node
> 
> 
> # f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")
> 
> [drm] amdgpu kernel modesetting enabled.
> vga_switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
> ATPX version 1, functions 0x00000033
> [drm:amdgpu_atif_pci_probe_handle.isra.0 [amdgpu]] Found ATIF handle \_SB_.PCI0.GFX0.ATIF
> [drm:amdgpu_atif_pci_probe_handle.isra.0 [amdgpu]] ATIF version 1
> [drm:amdgpu_acpi_detect [amdgpu]] SYSTEM_PARAMS: mask = 0x6, flags = 0x7
> [drm:amdgpu_acpi_detect [amdgpu]] Notification enabled, command code = 0xd9
> amdgpu: CRAT table not found
> amdgpu: Virtual CRAT table created for CPU
> amdgpu: Topology: Add CPU node
> 
> 

Hi James,

Specifically, I was looking for any events happening at these two places 
because of the patch-

https://elixir.bootlin.com/linux/v5.16/source/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c#L411

https://elixir.bootlin.com/linux/v5.16/source/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c#L653

The patch specifically affects these two. On/before starting VM, if 
there are invocations of these two functions on your system as a result 
of the patch, we could navigate from there and check what is the side 
effect.

Thanks,
Lijo

> Other things I'm willing to try if they'd be useful:
> 
> - I could update to the 21.Q4 Radeon Pro driver in the Windows VM. (The
>    21.Q3 driver is currently installed.)
> 
> - I could set up a Linux guest VM with PCI passthrough to compare to the
>    Windows VM and obtain more debugging information.
> 
> - I could build a kernel with a patch applied, e.g. to disable some of
>    the changes in f9b7f3703ff9.
> 
> James
> 
