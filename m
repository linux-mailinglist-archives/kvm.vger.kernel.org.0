Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09B24A6C5C
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 08:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiBBHcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 02:32:21 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:54368
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229609AbiBBHcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 02:32:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgRJr3T9/BdkdSNFe6Ibt8Qdfbfog7vg2E7PERtMXwigXbgMxFsnpiHAtIIfhcPRgld8QHTBX1j1OFFfyYBRauP1E9iE8HksV425pL0/k9DoEcaiYtWufsEK3IPxm3jWNfCMYJl48WMVxKP81nyFGwH90GWU26MHx5t5I9Um+ObVCU6a087wJ7AXmQB8JEjCqTAxoPJU/jcHTwtD7kQ6UJin4WE8PN1bNUi9+k204zWf+70gSGqP1yIShKZc4lTkx5iza8L+hgX+bYR7DF7VZbog/0MI5lnKAo23s3+IQat5xf60CEFUwcxIh8/WwUNEyoaFLT6BxxQ4BdJGu7Ergw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmgGxzy6lZw2K1wnRHIyD+RrYsoLTsBPrLsCHmZvwhw=;
 b=NVIOynsa+jMzR8JDK32Kivhc192dSVRrRxPpx4+i9QMCXYaMjXDbEFSP0kBlTI5NlbOI5nNf4xyxBCGbgkGlsVBNVHjZKmXZkMlNS+WTOEvSy5yvwZsUxb2tLhldfzmSaNg/khM8r3SgYnH6yxnek7ss3CSdvImbGiLLkt+Q4hQzIZlOUnbPbmvuLla2/RjtIqU+9Bds79BqF1lVEO8hXQnwTtitujjUN1uSXUp02XH6lQ5I8dPWxyd5JJF8XKercGL3Mma5alGkNI8S9D8NZePz78lzGaKnxifiKYTSikNNCE6+435s84zkZmr75uiEznZOobfHPDXJZG4Xim6qdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmgGxzy6lZw2K1wnRHIyD+RrYsoLTsBPrLsCHmZvwhw=;
 b=vUFbQTpKVr9CpvPY38EqVUgP10FhtnEcj8+HPlKE2kYXllErjb3NQb8jcGriXNJdsVMj5oIa8p5DFKwFGVHOfkK7XTeF+HHE3b49DBdDrfF468Ubky9Dcdz1Q3y43jrHwCmnNriI1PUwAJCynLL3h5ZPaG8AO51EMKRWCs7Q90M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MWHPR1201MB0080.namprd12.prod.outlook.com (2603:10b6:301:54::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 07:32:13 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643%8]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 07:32:13 +0000
Message-ID: <9d2ca4ab-b945-6356-5e4b-265b1a474657@amd.com>
Date:   Wed, 2 Feb 2022 14:32:00 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com> <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
 <Yfms5evHbN8JVbVX@google.com>
Content-Language: en-US
In-Reply-To: <Yfms5evHbN8JVbVX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:820:c::8) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94bdc03c-72f2-489e-ad5a-08d9e61e20ed
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0080:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00800D75EDA5EEF88E2AFC48F3279@MWHPR1201MB0080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCvtDoIj0blZSmWhahTRPDBJpT+KAvTXb43jQZNWCIcuZ4izXADqG0Ctc8UNmUF49WkpCkn1JVFyAiQqgslj6O8xdd8o2/eozh+38IGwL3X/iKoV1D2dmHYUfOJPN8olgJDwkuK/jyD97IAhVKjOeVU72WBF6kgbMhWhgArD+wGIWnKSkzkj7mGhc2zM9L5U1COkBt7mdI/9X0Kq6s5RxuojS2pMn6tUtZnZc2GI1bCDM/ycIAtblGEIbLe03zqJxjqNPY+2LP9NA5JUC+FW//daU51fkvJ0f6ZJOet6vi3prhZB/X0qdLQq9FuiIrswObmApb0wzBMkW2wXFCDApINoHA1Z9mM8fogRgkpgyuRgfGLRfb0K5GKX0e0d0b1DO2pd7UwS9cZ3ebTBzUfdQ72Fpgl2H3v9bFMP57y5l7+7tGWiKFqB/pk8zTCFAnsQymDO2wbiq6MPh+nqixzXm2suvPat6sQqEdzqoDOavKQrPFbDdiXQHMjymgc1etrQf71qfnD22uEKaBgs93pUG4p0FFMgEZuxKDHNKoF+CUhkpyjQRHGDwCet1pfZzYwfWlVfxFYqJexvL/cjp0ERhMUW2jAh9Lw9tToTVc6+3UM6qdow2xg2mf7W6dqSl9eZ3ZN1eXyf9mmmgIHhj5cAMh+CBOi5IOVtPvZD+XEIXPnJ/4/4KDB2AA/vXccjCrF44cTUcAH0C1iRPl8pADDDS61ipbT9EQsocllWLiYeZjnXkX+i5zjhC3QdluOOM8CU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6486002)(31686004)(83380400001)(186003)(31696002)(6916009)(6666004)(6512007)(6506007)(38100700002)(508600001)(316002)(8676002)(2906002)(5660300002)(36756003)(53546011)(66556008)(66946007)(66476007)(4326008)(26005)(2616005)(8936002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWpra0ptVGtzd0xnbHNNRThHRkg2d0pFTnVJSmg1MFlKM3BjKzdvNXVRT1NB?=
 =?utf-8?B?UlA4T3J3THgxUzQ5T1Byd3RXeE5wQW8vSks4ZFVDTFhsOWNmWHBsSEtQVkFl?=
 =?utf-8?B?QytBRTJkZlVMWkNnRnh5MVY4QTljZ0s1TXdFUXlYd09teUI4RkUvRmFWTU9a?=
 =?utf-8?B?ekJNeFlvNVNtVm5naGpkdFVjQ0dCaWRETFloMmg2bjZKNkl5M3kxYkxZU3BE?=
 =?utf-8?B?QlgzZW1CZzlZWlpPWmptbDE0c0tzSTJYRGNKSm0wS3VIck9nU0g2VU1wSDlD?=
 =?utf-8?B?WnR1TERJNUN6eVlta1o3UlNQU3IwcDNHckVheituZFplOU9QZ1BZL0xqcndL?=
 =?utf-8?B?ZnI4YXFwMkthUnZKYXM4R1l5K01QKzFkcXoyNDFJTW5KUE1JVTgyS0Z3U1lP?=
 =?utf-8?B?TERXdUgxTVdFeWtkTjhWaGpsQm41LzJwUDJUUUkxMFdWci8zY1dZdnM2c21X?=
 =?utf-8?B?WWpzQndKbGFDQXBVQ3BXSE1qVVpjUTVoU0RmdVRIZWFDdUtqZ1IrVFdXbjJx?=
 =?utf-8?B?cnQ0QXVEaEgwVmMwY28vMGUxV29TRHpla1NLVU5PYi83Sjd4OHNvOFFXa1FD?=
 =?utf-8?B?YUdBcTBMbVVVOGNVNmMvcjY3c2FubEdzcDYzYXN0R1pQOG5teUhJbXZnRGpN?=
 =?utf-8?B?VFBsdE95ZDlicUdYMHBMWStaOXZIMDdXUDZ2V3FKQjRDTS9mVFJqUm1RSjVE?=
 =?utf-8?B?c2MrbjlxT1lKYzhKTUxKblRvZUw0OUd0Qm1XM1djcXJqazFxaXF3dmRTTDF6?=
 =?utf-8?B?UitmQlZZMVYySWNtU0oyTTRQelR3c0J0NEhucXlzVGxsY3FYQ1BGY2hqckNP?=
 =?utf-8?B?SlljK2o3akJNWmhuMTFXZWdPby9wcWFQNGgxMTgraUVZQnVkdXNYTzRlMisx?=
 =?utf-8?B?bklaVVByUHpORVVyd1FOdlFsOEJMU2hOVEREcnpLdmhrdjhvb2pPdGh3VWUx?=
 =?utf-8?B?Rlk5SkVqUXhsSVFsb0pBdDhJSis4RHNFVHRWVW95WnFTemRMdVEzdVVocFc2?=
 =?utf-8?B?aXpCb0FQYUhpL1hjRmdkek1NZnJnQWxyVFQxaVpSOHpHRnp5MWdiR2NKNThM?=
 =?utf-8?B?MmdmMTFsc1VUbW9sR2NhaEtwT0piVkFXZllxRFJ3bDd3NkVFd21vbnZ2c25n?=
 =?utf-8?B?d0F3TDJOV1dtKzdib3o5c2ZYYWo5dXNBOGFCR01NQVVhVGFPL1pHclpRMVpR?=
 =?utf-8?B?ZUVreExIOEt2bjV6UmRoa3hsUEJLSnQ4ZHoySEpBOXd1Szgwb0luclRpNDUz?=
 =?utf-8?B?YXhiTHk0NFFJaXRJU29rTEFzMzFvVWJNTFFkMndLdzNQQU85Y0k2Smkwd0VF?=
 =?utf-8?B?Y0VrSFhCbU5kMFJSODZkNjdCT0NvNFZsSXppeUZLbUFYVGdWdUJrWSt5WWxF?=
 =?utf-8?B?WDNNdTA5Y1R5SHorN205N3hMU1N2cHNZUHNqSWgvdnB1MDBqTjRPWWIzQUNV?=
 =?utf-8?B?UkxXMTdOTm5ya2ZCeUxYRDZjTS9EMklXck81U2Q1UHR1NkFtOGF2VGhxRGEz?=
 =?utf-8?B?Zk9ZT3hVVzNBSlM0M2Jybkg2S010QWVENWdma0xJREJ6VGRLTzZnak5aeGVM?=
 =?utf-8?B?c3B4dlhzdUUrTkg5dDFHOGxsdTJGaVJPVThtcU5uWnJveFcwb1d5MzZ3UWw4?=
 =?utf-8?B?dTRoU2JTV1JGR0wzOUJ0RVR1R1lNeGFUeVlRNE04OWlrSUFFaUR2UEJuUjhB?=
 =?utf-8?B?eTZETkNYaTcwczZrWFBrZWFZclpzS1hvZnZSSWkwMENtbEdzNXAxTEs2T1lU?=
 =?utf-8?B?U1VlZ3A3bzUwQmFuL3JsaVEwVWQ0VDF3TmpUV0h3VXZSaHV3ZlJlS01YZVhX?=
 =?utf-8?B?eml3VmQzMkRGZm12REFiVlRsQ1lVRmQ1b3d3OGdSSHlSbjhoNkZRcTVIV00r?=
 =?utf-8?B?SXNJa0s4YkxsRzRRYWR2QU9RRVdoU3NDdEU5aXIzTWxERHdXS0U1NmN4Vk9L?=
 =?utf-8?B?OTBqWlIwYnVyL1VsNlVzbGsrWTY3UjhwcU5oS1dWQVFzYXVXSXhtUnZqM1dY?=
 =?utf-8?B?TS9ZQUczRDQvYVl5M2FQMHVvTUcwSGtqUG43VURLbnk5aGx4Z0RDdHNYQnFo?=
 =?utf-8?B?RFVhTURkemtzTFVoUnlQNkEyS1NWdFpaQXVkcklOaUI3ZnpmV0ZHcmZQcmFx?=
 =?utf-8?B?R1J6UzVTc3ovZ1N0VS90K0FmNUhZc0E4UXNVVmpOY05kUjZNNjhzYng3Q01D?=
 =?utf-8?Q?OsUEryo6Y4QUpx45eUc8nDA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94bdc03c-72f2-489e-ad5a-08d9e61e20ed
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 07:32:12.9865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6C9EHWhBlXiiYriRhvsCL6l+KZy0bEfvbVimYx2q5dZqYv2rtgsCwEHziivG7vhriDtwfcLnJfH2Xck9GtbCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On 2/2/2022 4:57 AM, Sean Christopherson wrote:
> On Tue, Feb 01, 2022, Suthikulpanit, Suravee wrote:
>>> That implies that an APIC ID > 255 on older hardware what ignores bits 11:8 even
>>> in x2APIC will silently fail, and the whole point of this mask is to avoid exactly
>>> that.
>>
>> On current AMD system w/ x2APIC and 256 cpus (e.g. max APIC ID is 255), it would only
>> need 8 bits in the physical APIC ID table entry, and the bit 11:9 are reserved.
>> For newer system, it could take upto 12 bits to represent APIC ID.
> 
> But x2APIC IDs are 32-bit values that, from the APM, are model specific:
> 
>    The x2APIC_ID is a concatenation of several fields such as socket ID, core ID
>    and thread ID.
> 
>    Because the number of sockets, cores and threads may differ for each SOC, the
>    format of x2APIC ID is model-dependent.
> 
> In other words, there's nothing that _architecturally_ guarantees 8 bits are
> sufficient to hold the x2APIC ID.

Agree that there is nothing architecturally guarantee. Let's discuss this below....

>>> But at least one APM blurb appears to have been wrong (or the architecture is broken)
>>> prior to the larger AVIC width:
>>>
>>>     Since a destination of FFh is used to specify a broadcast, physical APIC ID FFh
>>>     is reserved.
>>>
>>> We have Rome systems with 256 CPUs and thus an x2APIC ID for a CPU of FFh.  So
>>> either the APM is wrong or AVIC is broken on older large systems.
>>
>> Actually, the statement is referred to the guest physical APIC ID, which is used to
>> index the per-vm physical APIC table in the host. So, it should be correct in the case
>> of AVIC, which only support APIC mode in the guest.
> 
> Ah.  If you have the ear of the APM writers, can you ask that they insert a "guest",
> e.g. so that it reads:
> 
>    Since a destination of FFh is used to specify a broadcast, guest physical APIC ID FFh is reserved.

I'll let them know :)

>>> Anyways, for the new larger mask, IMO dynamically computing the mask based on what
>>> APIC IDs were enumerated to the kernel is pointless.  If the AVIC doesn't support
>>> using bits 11:0 to address APIC IDs then KVM is silently hosed no matter what if
>>> any APIC ID is >255.
>>
>> The reason for dynamic mask is to protect the reserved bits, which varies between
>> the current platform (i.e 11:8) vs. newer platform (i.e. 11:10), in which
>> there is no good way to tell except to check the max_physical_apicid (see below).
> 
> ...
> 
>>> Ideally, there would be a feature flag enumerating the larger AVIC support so we
>>> could do:
>>>
>>> 	if (!x2apic_mode || !boot_cpu_has(X86_FEATURE_FANCY_NEW_AVIC))
>>> 		avic_host_physical_id_mask = GENMASK(7:0);
>>> 	else
>>> 		avic_host_physical_id_mask = GENMASK(11:0);
>>>
>>> but since it sounds like that's not the case, and presumably hardware is smart
>>> enough not to assign APIC IDs it can't address, this can simply be
>>>
>>> 	if (!x2apic_mode)
>>> 		avic_host_physical_id_mask = GENMASK(7:0);
>>> 	else
>>> 		avic_host_physical_id_mask = GENMASK(11:0);
>>>
>>> and patch 01 to add+export apic_get_max_phys_apicid() goes away.
>>
>> Unfortunately, we do not have the "X86_FEATURE_FANCY_NEW_AVIC" CPUID bit :(
>>
>> Also, based on the previous comment, we can't use the x2APIC mode in the host
>> to determine such condition. Hence, the need for dynamic mask based on
>> the max_physical_apicid.
> 
> I don't get this.  The APM literally says bits 11:8 are:
> 
>    Reserved/SBZ for legacy APIC; extension of Host Physical APIC ID when
>    x2APIC is enabled.
> 
> so we absolutely should be able to key off x2APIC mode. IMO, defining the mask
> based on apic_get_max_phys_apicid() is pointless and misleading.  The only thing
> it really protects is passing in a completely bogus value, e.g. -1.  If for some
> reason bits 11:8 are ignored/reserved by older CPUs even in x2APIC, and the CPU
> assigns an x2APIC ID with bits 11:8!=0, then KVM is hosed no matter what as the
> dynamic calculation will also allow the "bad" ID.

.... here

As I mentioned, the APM will be corrected to remove the word "x2APIC".
Essentially, it will be changed to:

  * 7:0  - For systems w/ max APIC ID upto 255 (a.k.a old system)
  * 11:8 - For systems w/ max APIC ID 256 and above (a.k.a new system). Otherwise, reserved and should be zero.

As for the required number of bits, there is no good way to tell what's the max
APIC ID would be on a particular system. Hence, we utilize the apic_get_max_phys_apicid()
to figure out how to properly program the table (which is leaving the reserved field
alone when making change to the table).

The avic_host_physical_id_mask is not just for protecting APIC ID larger than
the allowed fields. It is also currently used for clearing the old physical APIC ID table entry
before programing it with the new APIC ID.

So, What if we use the following logic:

+	u32 count = get_count_order(apic_get_max_phys_apicid());
+
+	/*
+	 * Depending on the maximum host physical APIC ID available
+	 * on the system, AVIC can support upto 8-bit or 12-bit host
+	 * physical APIC ID.
+	 */
+	if (count <= 8)
+		avic_host_physical_id_mask = GENMASK(7, 0);
+	else if (count <= 12)
+		avic_host_physical_id_mask = GENMASK(11, 0);
+	else
+		/* Warn and Disable AVIC here due to unable to satisfy APIC ID requirement */

Regards,
Suravee
