Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C04674ED6A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjGKL5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 07:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjGKL5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 07:57:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2128.outbound.protection.outlook.com [40.107.93.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A8CE79
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 04:57:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5T+/CP41Lx2/8Pkh1o8s59Ukm1E8ftzZJsFClw/xO0/Mh0WsOw8zDArnIwP3v4gaAHfooGfm9Y0gxELcL6SJxmJtM2bXhKpFx7VJTqBJirTdNgdcEkVuGNRNpJAHn9XhWANB8sAt1/9MDYxJAVf9vxIpkBtH0OTwYv3e7UXLvMeZlJ1l7O5htJthWKLNAQZo+K/8zt2cCPSMvdqjXtMpsJrG1aV6Xl3i0BFmBrxah80C5vZpxOzx7ZO8PzrWB/qFu2bC3rfKVVJpEpXkALjtqam9OYe9TOSt45CG0clD9grUiPdjWdPPqBPj+gAuGJ6PEyJ0BPtpyEoAiPH5CHyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8daHo4h1llf9urTsC+TckQauv4J/zVjBZ2RAOE+zuY=;
 b=TmrvQM9NIap6lCBbifbW23UtU48mMpP5Sf9U/p6VynxBtf2qIccxDCEkRnk8pzVyj+bmhbLEltuaH5LrTCJ+rFixwRcIFK5sDqTG6TqqMy/hTZCsK8q9rgxXe5munCZq5ARrA1KgjsgMbbQK8yBmBDKe8SJZIucFXL1NB03oCAwoSn1EUfVa5/JVmYTUNGHqeil1DmzE1ok+sfwiJY04o7JaFv/1uk+rWMGzEQXLBy7XLa6U2QKf5TcQ/Ynb7baW2enW9s8aZYbBTkTQoMK9FixeJhhVaoP7iljaLjXXIz3elvX6AOtZewmDyOcyjHzmi5eUGYvJN0633+YDQXMmgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8daHo4h1llf9urTsC+TckQauv4J/zVjBZ2RAOE+zuY=;
 b=DieFeE6S4OW3y8+bfcrQoo1E9WG8GQU2d7oPRqqg3TZJxBkN1C1ncpO5/ptKcCIQr1Zg1+0TFSeqisi4ZMgBD1yfGVwMdnkySUGH628K6sQNbmUx3nyqsL0krpRtzumuPbyY8TT+3DjTj6uHac8c8NxXWie096p6ZI9nHsoQeeE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 CH0PR01MB7124.prod.exchangelabs.com (2603:10b6:610:f3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.32; Tue, 11 Jul 2023 11:57:02 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::1eac:52b3:462b:f59e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::1eac:52b3:462b:f59e%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 11:56:59 +0000
Message-ID: <853a5f76-74fe-a38d-f2cd-785963177c8a@os.amperecomputing.com>
Date:   Tue, 11 Jul 2023 17:26:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     Marc Zyngier <maz@kernel.org>,
        Miguel Luis <miguel.luis@oracle.com>,
        Eric Auger <eauger@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <f19bb506-3e21-2bd6-7463-9aea8ab912f5@os.amperecomputing.com>
 <877crmzr5j.wl-maz@kernel.org>
 <a62dba1a-86b7-45ab-f6a8-f88b224af402@os.amperecomputing.com>
 <04ec8efb-33ff-153e-3be5-5c84a01bff2a@os.amperecomputing.com>
Content-Language: en-US
In-Reply-To: <04ec8efb-33ff-153e-3be5-5c84a01bff2a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0445.namprd03.prod.outlook.com
 (2603:10b6:610:10e::31) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|CH0PR01MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 943976be-c436-484c-f18f-08db8205ee7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpvtJYd4f42oyu29REhNlu4z2iPO2qeMeUk1meMzJIoTfy5EqXyGBBFkBXjs6yb+1UySbZdjB2fOzFv+1OHrYAbAQQTZSp/8fxOQhN20iwfdHjHF8kUlF7FxTn96PqdWudzMNuPj3ynPO9O7met+ghtQumrQENHvtFqj0/qVuUce9wv4lvS/zt4fQygEETZiR0if71/4BejxciQCV0CpYgjGQCqahQFDokezeCNx9XGgmDTo5Y/xHSCUrshgs+Kw/F8NRHoF8n98Ea2/z2/RJ1RKktqDx2E9mmBPpibgYGeUQbxBm5YOCTrnFCELhrFrDBnxZ9zNTHfTuHdjOgeAokSlFtJ8hriQjDgMMOj8c6VsxzVlqmq69EVygLtgLwP0OdjYPhWtfVa6hesffN0gzfTwL7cejbA5vVnpJSfyqiShI4ib/a2G2SqM8jY6Rr7Di9X1hhQLwQhVLtPg9f33cPbNdQGPDq1q4fpn7q1UTs3TkfL2xtgsWWPwYo/nUgBvr6u0ijIGAhXTwXWK2wukdhkTJNa4oeB9bPkWiufQWrHtNeeyBajxDV6BujR4TwsHwZGGsDx4wQEA/ASELid0qL5hRXn/pvfnnaDDYkyqY99zintc8NjvKiAFx6cUH3uY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39850400004)(136003)(376002)(366004)(396003)(451199021)(31696002)(53546011)(6506007)(41300700001)(26005)(6512007)(31686004)(186003)(2616005)(478600001)(110136005)(54906003)(6486002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(316002)(7416002)(8936002)(86362001)(8676002)(5660300002)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1NpeG9tUWZ0bDc3SHNCNWI0bncxaFZpUW5ER2RVMXM0bHFBcmR6bm83V2NY?=
 =?utf-8?B?NTRVM2hNYzhpQXNuUWtYV3NqOWNzUXpoOUNRY2t3NmxONy9tVHlCRkR2Y0Ni?=
 =?utf-8?B?ZEJJOG5mN1ZCaitnM3JYL1h1Q0IwZVRreWRyMGM1aTRveTRVL0xmQytxMnBa?=
 =?utf-8?B?NFYvZ0lQS3dTYkcvMDJ3VWRVUms0S3JoNVp5ekNDYkZKNE41VWhHQjdWRDZG?=
 =?utf-8?B?cTc3TmttRGxiNXFYcnJNSEtqcllhNzdjYlFGZ3dGYUZwTDYyNnU3c1ZqV0lY?=
 =?utf-8?B?c1JwTDRsa09kT2lucWhvRmhZQ25vY0dBRGVGM3J2YTRPZ2lrMnZGZ2xHRWFv?=
 =?utf-8?B?ZTQrWSt2ajVMQVh6TlhmUEE4cU13N0RPdExQcFB1S3Z1SkxmQjNGdVBBWVRC?=
 =?utf-8?B?STdibEFLZjcrcTRKcWdLSkdTRm9tYWtQLzdPZFZ3YmlMR2FWS3FoUzZBUEdv?=
 =?utf-8?B?elM3R0dJMG1GNVUxOTRIcjNqeWt6azJjRmgvZmJSMUhqRE5HeEdiTUdEVHc4?=
 =?utf-8?B?QjJDZVNGd2w1cUNJR1k5TS93VG0rUlkzUGZIMWQ4c3hobGxHbDlQalhuTW9E?=
 =?utf-8?B?c25CK3ZDcnVZREVzQ2ZxMGtYRm5McHRVWE54c0FBTVp3Yi9uRkppcWg1dHNv?=
 =?utf-8?B?TlQ1T0FNblBnKzQweThxTHBrQ2NYN2FsaStRNzBqSDYrVlFVbWFwNDRheEpC?=
 =?utf-8?B?Z0ozbU16bkM0UHVTbE1Qa0Y5NTZqTVRUY3hSWEdja0NKRS9pNUxqSFA5cXRq?=
 =?utf-8?B?bmtaaEwwN2ovWkdhejhKUDM2akExVXVWbndSakVMMXBvbUdvSXdTM3d0V3lC?=
 =?utf-8?B?LzB0ZDNlTXpXL1ZBUTU5VTdIY0crcmZCOTNnd1VLUmRqbFhqMkdGTGZuMkk2?=
 =?utf-8?B?QldGSVROYXNrWDhva2xpMXJ0cFkrN3FCc3BTNGZpUFBFbnVoUm1MdFpXcTFG?=
 =?utf-8?B?Qzd1ZUp5OTdnQmpTdE8xdk1OZzJJSnF0MFhnOUE1S09jWHBvOWoyalUzRU9V?=
 =?utf-8?B?Unh1VWtpczh6aUZjaTNWZGttbElYVVVXemJYNGNqbjhzM1ZBTHlFQWVtcWRu?=
 =?utf-8?B?NjNvNFlqaWRmM2xrZCtyVlNjMHBRdFNMazZKVVpCNmE1NXF4cGFYTDFjWmhC?=
 =?utf-8?B?UiswSGtMZVNBZ2tOTnZyQWl2Z0NNeUI3NVMzaU9ZalRSemNsTzNaaTVTK2Zk?=
 =?utf-8?B?ZnFaUDFCK3VMd21HYXk2aTFwbHFld25Kc0MwRE5BVlhZS3dGVkZPRXRrUUNX?=
 =?utf-8?B?SDRPMU1FbUlFbWRSTlVFb1FtNERYVXRCaXQySlBWOXNrM1A2em5YWjhqVnZp?=
 =?utf-8?B?RVl2bEVCaDQ4UStJWENUaVNxcUpQUlJkTklJT3VrZE1kVEdOM0VLVFJ4S241?=
 =?utf-8?B?S3M1SUUrM2hrUDFFNENMUTdCV1UveXZLN2tZNm9PTzRYWWs3emtKNVU2NE44?=
 =?utf-8?B?MGU3R1BkNk9CeU1IZ2V5dHlVd1B5LzBHYUc2K0g1bFFhNVZIVVQ1ZmVVckwr?=
 =?utf-8?B?VFlEMkJ2ekh5VFZybEU0ZStsVUNGZzdPVlNVWVQ5VUpzN2pYcG4yR2Izbmsz?=
 =?utf-8?B?YVhETkwyUi9rUExTaEN6VTlEQkphbFdtUU4wYWE1eVNZTFMydFg2cmJGd3gv?=
 =?utf-8?B?YzJIWmFneEZmT0FpdHR3VDdTZ25tS2FsYVFlVDhWejBNSzVqVERwUlMwRmJo?=
 =?utf-8?B?Tk8vNkE1MW1FcHBLb2haazBaRUN4WVZYSVRPdWNtN2dqczQwNzZ6VTdCRW9O?=
 =?utf-8?B?RzBxdzhJdER6RW4vbzJkSG91U0hxMVM5Wlp4TkVBblBwVFpORmxuV3Bqazla?=
 =?utf-8?B?aEJGOGV0MTQ4TGx6TVBBUk1iWmJMZE5rQ2pBclJacms0Z3p5Ymlrc2FMT3dh?=
 =?utf-8?B?VDFXSnkrdXRLVlFPd3FEZVN4dHNqNnRsOVJ3cUI5L2lHdWxMMURsNUNXTjJm?=
 =?utf-8?B?VXlPejRYYmtZRzFoeTRwNnR4aERJWnNQVkRlaUJyZk0wNURYSExnOGlpVlkr?=
 =?utf-8?B?cjNxUGlHUkZydVQwYlFPRHEvSGZvUGVJOUtJZ20zcit2YWFyRWIvK3IxU1JD?=
 =?utf-8?B?azdldnJDQjBmbU03ODM2RDk1QlNOMi92ZFd0WElGMUdUUmM5cjFLMk0wY0ZF?=
 =?utf-8?B?UC91ajRVR0Y4MmZzd3hFSzVlTEJXNGQ3RDM5Q1ljdCswYTdvZy8zZU94dWps?=
 =?utf-8?Q?iffKNYrHtN7heMZaeVafiOI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943976be-c436-484c-f18f-08db8205ee7b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 11:56:59.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSbEAtVswEoi2K6iK7Qx7M04In07KgTPoPViAE/RzQ6XMmdW3RbWJgIGAUAaraZSa9aHldVvI3P1qPl2cEVVSMocGSj0goW4P0k7MUMR4NypBPu0w1xWMpUhuPas1ncg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07-07-2023 03:16 pm, Ganapatrao Kulkarni wrote:
> 
> 
> On 04-07-2023 06:01 pm, Ganapatrao Kulkarni wrote:
>>
>> Hi Marc,
>>
>> On 29-06-2023 12:33 pm, Marc Zyngier wrote:
>>> Hi Ganapatrao,
>>>
>>> On Wed, 28 Jun 2023 07:45:55 +0100,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>>
>>>> On 15-05-2023 11:00 pm, Marc Zyngier wrote:
>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - New framework to track system register traps that are reinjected in
>>>>>     guest EL2. It is expected to replace the discrete handling we have
>>>>>     enjoyed so far, which didn't scale at all. This has already 
>>>>> fixed a
>>>>>     number of bugs that were hidden (a bunch of traps were never
>>>>>     forwarded...). Still a work in progress, but this is going in the
>>>>>     right direction.
>>>>>
>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>     the L0 IPA space. This fixes a number of subtle issues, 
>>>>> depending on
>>>>>     how the initial guest was created.
>>>>>
>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>     hopefully some of it is easier to review...
>>>>>
>>>>
>>>> I am facing issue in booting NestedVM with V9 as well with 10 patchset.
>>>>
>>>> I have tried V9/V10 on Ampere platform using kvmtool and I could boot
>>>> Guest-Hypervisor and then NestedVM without any issue.
>>>> However when I try to boot using QEMU(not using EDK2/EFI),
>>>> Guest-Hypervisor is booted with Fedora 37 using virtio disk. From
>>>> Guest-Hypervisor console(or ssh shell), If I try to boot NestedVM,
>>>> boot hangs very early stage of the boot.
>>>>
>>>> I did some debug using ftrace and it seems the Guest-Hypervisor is
>>>> getting very high rate of arch-timer interrupts,
>>>> due to that all CPU time is going on in serving the Guest-Hypervisor
>>>> and it is never going back to NestedVM.
>>>>
>>>> I am using QEMU vanilla version v7.2.0 with top-up patches for NV [1]
>>>
>>> So I went ahead and gave QEMU a go. On my systems, *nothing* works (I
>>> cannot even boot a L1 with 'virtualization=on" (the guest is stuck at
>>> the point where virtio gets probed and waits for its first interrupt).
>>>
>>> Worse, booting a hVHE guest results in QEMU generating an assert as it
>>> tries to inject an interrupt using the QEMU GICv3 model, something
>>> that should *NEVER* be in use with KVM.
>>>
>>> With help from Eric, I got to a point where the hVHE guest could boot
>>> as long as I kept injecting console interrupts, which is again a
>>> symptom of the vGIC not being used.
>>>
>>> So something is *majorly* wrong with the QEMU patches. I don't know
>>> what makes it possible for you to even boot the L1 - if the GIC is
>>> external, injecting an interrupt in the L2 is simply impossible.
>>>
>>> Miguel, can you please investigate this?
>>>
>>> In the meantime, I'll add some code to the kernel side to refuse the
>>> external interrupt controller configuration with NV. Hopefully that
>>> will lead to some clues about what is going on.
>>
>> Continued debugging of the issue and it seems the endless ptimer 
>> interrupts on Ampere platform is due to some mess up of CVAL of 
>> ptimer, resulting in interrupt triggered always when it is enabled.
>>
>> I see function "timer_set_offset" called from kvm_arm_timer_set_reg in 
>> QEMU case but there is no such calls in kvmtool boot.
>>
>> If I comment the timer_set_offset calls in kvm_arm_timer_set_reg 
>> function, then I could boot the Guest-Hypervisor then NestedVM from 
>> GH/L1.
>>
>> I also observed in QEMU case, kvm_arm_timer_set_reg is called to set 
>> CNT, CVAL and CTL of both vtimer and ptimer.
>> Not sure why QEMU is setting these registers explicitly? need to dig.
>>
> 
> I don't see any direct ioctl calls to change any timer registers. Looks 
> like it is happening from the emulation code(target/arm/helper.c)?

function "write_list_to_kvmstate(target/arm/kvm.c)" is issuing ioctl to 
write timer registers. PTIMER_CNT and TIMER_CNT writes from this 
function is resulting in offsets change.

> 
>>>
>>> Thanks,
>>>
>>>     M.
>>>
>>
>> Thanks,
>> Ganapat
>>
> 
> Thanks,
> Ganapat

Thanks,
Ganapat
