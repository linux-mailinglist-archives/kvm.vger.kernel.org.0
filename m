Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD94752ED2
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 03:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbjGNBmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 21:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjGNBmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 21:42:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10olkn2082a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139DA358C;
        Thu, 13 Jul 2023 18:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5x5Gn1XqRM9Q8+S+DmSibtsL4WqGnvqk/Sa649PYtX+YaiV8+UAVXir+iGfqCkbCvYrKMp/Zg6neeXEq9NI2PwY+szgSb7RXOQuQXHg/CcmkQVGOOJ4zL+401HD+RUN/TQUvGZdaoefaLAGJ2nP8xTXf/heFUoImTY3j8OgX5OuGnx/WZGcTvTcana1PMrIZW4zdser9RTbf9I1jWG3OVgDx8GdnkDxlY+BY1PPOIxFwHVYA7s42hryQLnP9LWFVMc7x4ttDWpcFEM/57u03F07BjQ0Dkzb0fzHqKCddzrPGKMXV9uAe/EB2dk/PooDWGzGd5Af/rqAcut2Efr/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=549VIlEgZpa5VmDBMpEes7fKRIZ/EodVqGMMx64Uj3w=;
 b=R1oQBWVL2QknabffUXLw3jC1VFzy3q+r+RxHlhQjEGRH2Ufd7A8ezBOVluuuVkaASAS6XSmwXW8Wre/rjoGbURbcmPmGMK7XXgRBm2DyQ+oqWSjqfX/8DtG+W9Uuwf1rrwa3cN9gZFPZeFOKV6H4UKWxb7Hj531It4+BobJBVRKpP8gkTFB1GC+MTQmA2zR6CpUhaq2ZCfo16XBGle4J2vhOvI5TSwSVON6wtwaLcsVal0qmznruSW8w3wcHq+ZFEZ1V6yME0plPNiWfwDNOCoOx4RJnBcifKCGVQvaxSKUpB+uGbTj9z4bFiDO0g8SffF/YqWX55N5kO1q+CuiQHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=549VIlEgZpa5VmDBMpEes7fKRIZ/EodVqGMMx64Uj3w=;
 b=UAtSm3fgZbUqaFkbVi6wd/SIBMsOphXrTeusu4hz2jwzBZKatBoU2f6PuKm+nQk/1zbEdpb5/yP4aJ4kZyaxZgdMP505eHFahVAMNWrfA4zdWnb1DR9Nsq3Bbu8gGE889S+DnfclDXCKm9nvIQWD0Ta6+s1zhIl2s3dv5tYATgLY7MIhpPDaoRE8RhtVgcdN7o4Q0AOZaXL/EibJh9bpLVzz1Me5jIIdCJ0IXibRjm0QTvhs3PXDM+Ga1gf3GKvbN5XHZslVw+TdhnR2VgotAZ9QXQI2FknrwGNHoicDLTUdmkZ1dndTuJRYc7ZlEA/dcO6Xx1dFSaQCeIs+ddKw+Q==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 PH0PR03MB6509.namprd03.prod.outlook.com (2603:10b6:510:b5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.32; Fri, 14 Jul 2023 01:40:34 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::b184:f2e2:b60a:2526]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::b184:f2e2:b60a:2526%4]) with mapi id 15.20.6588.017; Fri, 14 Jul 2023
 01:40:33 +0000
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
From:   Wang Jianchao <jianchwa@outlook.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
 <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
 <a6fd8266-54a8-bb4b-f3d2-643a94e27e9e@intel.com>
 <0d8324a2-6297-c3b8-f258-3f2bbc161801@outlook.com>
Message-ID: <DM6PR03MB4140281E3B4CDA724238D11CCD34A@DM6PR03MB4140.namprd03.prod.outlook.com>
Date:   Fri, 14 Jul 2023 09:40:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0d8324a2-6297-c3b8-f258-3f2bbc161801@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TMN:  [noL88Wwu5mLLPtn3KYcY2lXPap23Gm+LW3vxEttNge8=]
X-ClientProxiedBy: SG2PR01CA0190.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::11) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <fa7eaf6a-965a-53a6-5f02-ac33cb36bacb@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|PH0PR03MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: fee2b55a-b0fb-484a-526d-08db840b50bb
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnpRiBCNjHstdiVGgGTicbc/URsj4WL/Ezt7SfX+Foq4/SV/O0p/yJw9VxVdEDxx8ckf3GrEsd7pVuiSLSxg0ZvSqrm3scrM4Q1UkXl4qM2e8Ijj8q8ZP1b4AxWnE273fb/VyQxzcPgL/U4Qso1XiWwJ3jqfSpv/piJ6cSWA48wtQd5xGsf3aGCjK/N8HRLX1ZxXl9WELEvhXJ0sMQwnwoUOzwC4p5qLfFVBNATbukMn3aebvcEojUS5TWWaXbj3pxDLlRzpNo3jLCqMNJBDtbDyskW3ZZ/MrFjljcH6Y36Bri952N5aoV7DR1W9H5QkkxBHj3mo/Ajoch3/gUCkXlE+3h7/u1FL1ysXsTgzicVpZWxqLl5NiWt83qhhAnwHzm97TU5A/dMQcFZyCvxlBIRIFQ2ApXKdiZIsT/vedZ66dq04KuT2bfzoHVjv2VVVYAmla5vCymaTm4nmRi9vD5ll1c0G50HaWIK1VhWB17o3gRS+DPjs9j9Tpz2fTM09Yf+zHh3qNmMCG8tN64IoQ5NTifhV9Ew+F4/dyLNTeiR6vPdddMUgyNN2i+8jCHJKsETRL85O7ut3C8HqPmWWiCyjTsrlpTL/dIV95scHh8fxL8pOcGYNLXz0E5M9YcdQ8tpOq/B5gbpV7qh8v8H1T94dtpHg1nhhfafA2pKyVir40Jv24+wD6wM+UbnsleFuyGUAzAPYpnUcfgYOvMjJSwqh/2uzpaPwlbAum+198jDbRPxvADguaGpJ2Fp5tDiLKdc=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHVoIy0qm76nAKrfcxj9mFEOzIRBd/2WT75dogP+2WFayL8Tz2V/5PIB3/mHr37kAImbPR2qY6XCxy+xyN8biryCe9PM3PFG16rhNMnhW4Sby+gXzFj5pCGau93Xrq3rMZMO6nfzcCcQk6AVjZAU+zGW5HQxFUsQjH18F5inynxt4aPtY0XmwNz4JwCJjX/izRcFKR267VN29djhmpd1rhcnMl1C3vJHTxk2U5HPerlPqDWyEqz2Ed4hwao+IQWKN8/rmUD2tHcI6igDhfn0YI2j3IjPvUqDmaoIwHx1wln6p3KAm22ZKcfd3piNSGoga2uJcr0FWOEznMg+yRCdn3tOUV9pVpoJgkFLffNQuMhVZxdMUuMRn/x003LZVaVpuohkzLB7ifFZDTIu6i6fxnhacHU0xEnsAq4t7siWAELu3vrqCpjH3Sl5Vh92dWEfSi2xrcwOOoZpCRI41Qf7mq4eZ7zxyxNI0S+g8x/6tJSYiM0J0Xq1FHKPfYgKTVDGq3tIPDEltYX79IFwUx2llEZUsaaL+BO98u0hg7TY52yKCaKPwsLmnHiZwTOEuieN
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFBBZnUxUWJBWDN1WWlSbjRWQk9xQ1ZUaWY1Um9oZ2JTeXJEOXlHVmpUMkVx?=
 =?utf-8?B?UGxoWmRGSVVPc3JhMzNUZDZUNmxacXRhejlVZHhUU3dhK1NoNFhucXN1dkZH?=
 =?utf-8?B?NmVlcFZXL1p2ZldwRVIrdC9YTWJ2cDBoWDg4K3d5QTVpek9Halh5RnpsdU1X?=
 =?utf-8?B?ekJYaWFTYWJFRkJxdTFqb1NSRWtDOXFaZ043Qmh2V29pSXE1ZFBJcFhDZS9h?=
 =?utf-8?B?YnJwSHhZWHhaMHZXZyt2Z2ZUbmFVdEZVQUprdGp0TldzQzlOSVVBVlVtd1Br?=
 =?utf-8?B?VGtYMVFsTGRGNlVFcTVUamVkSDBJTk1hVmdwM0dBUWhCY1pEdGRsZUhySUtI?=
 =?utf-8?B?cTBrZm1uLy9XNkhhYVlCSTRhOVlTQmVjaFlVRkpRVXpwSkJsVEo0M0p6RFpM?=
 =?utf-8?B?QXlHK1BsYXVoUVVUUzJHaWNPSEtyeXNkNnpnVVdVeUMwdW51Mk5lT2lWM3lk?=
 =?utf-8?B?RnJRSEtuVlpNeGxnZ1hOeW5wNkxnaFRJYmJ4Q0o2M1NhRHFtTHZobFNqWWxp?=
 =?utf-8?B?bVpXaW44Nk8xZnJQbGo1dlJlazE4c2gvRmgvMHptVEZ5TUtmcnQyaXBsTjdI?=
 =?utf-8?B?ait5VnFyc3diZVNjWnRQVlMxQVB6V0VMbHBjYldzTEtSMXhZd0JKWmxPTnZk?=
 =?utf-8?B?akJudDR6RytIaVhkcjZ5azluS0U5RlI4ZDl4MFNNQnAwNTg1OTRKTFlwOU1v?=
 =?utf-8?B?disyL0JTU2VnZnM3cWw5aFc3MUtjdFlhR0g1aDhOT2pxd3RkZHEwbVdlZ2dh?=
 =?utf-8?B?S2djcmwxWC9nUkdyN2dXRnZZRlRtcmlOdEdzQkExTmVIajlDY2VBZFpzbW5U?=
 =?utf-8?B?RlRBNTV0a0NxcW9oVmJHZXJLeFVzL2Y1RHBXN3d4L1VubTI4Q1dSV29UejNL?=
 =?utf-8?B?akdXWjI0Q0VQSW0wVlV4NC9VT2lSRWJMcm16N0E5cXlUdkR4WTA1SWhjZnEy?=
 =?utf-8?B?VmdZVVQzU0dwN3A1dnpxWGE3eElFZVUvbHhodml5Sms4KzRLcEZCd0FzZHFn?=
 =?utf-8?B?WnhYN1FROThDK3pVRnUzeWcrSE5rUUJDSHBTRU9lNVRqMU44WFVkZEROZUYr?=
 =?utf-8?B?dFJyL09QWVlPVVY3c3JibllTSkpTS1IrYVc1Yng1NFA0OHFSWE9rVHhLcE95?=
 =?utf-8?B?UFVZaFRObkxEYnRManRYTFltR1hiT3VGR3hBWFVlOUJCcUlocmI2UXhDN25r?=
 =?utf-8?B?SXpqc1ZkR2k5TUJnbVU5djN2Rm9hNEE4c3hFWTZwTjZUVUF3cWw1RG03TWd5?=
 =?utf-8?B?ZzdzclZWNUlUbjZtSW9qSkNLTC8zd0hXajJXR0YrTXN5ZDNiZ3JzZVNtRFIx?=
 =?utf-8?B?WFNtQmUzTk41cmtVWTdpaXYzY2RkdXZOY1R2T05KZmlqMHFiaVdPQ1FpUFl6?=
 =?utf-8?B?M0NDMWttb1VrTXNhaDd3bHNwZ0kzY3VVT1k2bDNMQnR0YVdzMHFtL2puOEVp?=
 =?utf-8?B?Qk9UZ2lIMTA2WFFzR2dWV3luNnczWTRXVEdZRnVPTEVCZStCQWRFcHFiaHZR?=
 =?utf-8?B?MXVQTFdvZ3hSUzNEU0k4RlVUbFpXMFJHZG1VTXpyRlBGaHFrYkFmQ2hER2dZ?=
 =?utf-8?B?L0Qxak1tR1ZmbVpnMDZDMXB3KzBpMVNRMTZwQlV2S1RIclJFRm5VeG9UNGgx?=
 =?utf-8?Q?KjCbPkUh+uC/Y1OWE4adqGAdnCbDT1+C53Jsr8VL5K94=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee2b55a-b0fb-484a-526d-08db840b50bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 01:40:33.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6509
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023.07.14 09:29, Wang Jianchao wrote:
> 
> 
> On 2023.07.13 21:32, Xiaoyao Li wrote:
>> On 7/13/2023 10:50 AM, Wang Jianchao wrote:
>>>
>>>
>>> On 2023.07.13 02:14, Zhi Wang wrote:
>>>> On Fri,  7 Jul 2023 14:17:58 +0800
>>>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>>>
>>>>> Hi
>>>>>
>>>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>>>> because the timer is often over-written before it expires.
>>>>>
>>>>> v : write to msr of tsc deadline
>>>>> | : timer armed by tsc deadline
>>>>>
>>>>>           v v v v v        | | | | |
>>>>> --------------------------------------->  Time
>>>>>
>>>>> The timer armed by msr write is over-written before expires and the
>>>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>>>
>>>>>           v v v v v        |       |
>>>>> --------------------------------------->  Time
>>>>>                            '- arm -'
>>>>>
>>>>
>>>> Interesting patch.
>>>>
>>>> I am a little bit confused of the chart above. It seems the write of MSR,
>>>> which is said to cause VM exit, is not reduced in the chart of lazy
>>>> tscdeadline, only the times of arm are getting less. And the benefit of
>>>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>>>> to imporve the chart a little bit to help people jump into the idea
>>>> easily?
>>>
>>> Thanks so much for you comment and sorry for my poor chart.
>>>
>>> Let me try to rework the chart.
>>>
>>> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
>>> a vm-exit occurs and host arms a hv or sw timer for it.
>>>
>>>
>>> w: write msr
>>> x: vm-exit
>>> t: hv or sw timer
>>>
>>>
>>> Guest
>>>           w
>>> --------------------------------------->  Time
>>> Host     x              t
>>>  
>>> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
>>> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
>>>
>>>
>>> 1. write to msr with t0
>>>
>>> Guest
>>>           w0
>>> ---------------------------------------->  Time
>>> Host     x0             t0
>>>
>>>   2. write to msr with t1
>>> Guest
>>>               w1
>>> ------------------------------------------>  Time
>>> Host         x1          t0->t1
>>>
>>>
>>> 2. write to msr with t2
>>> Guest
>>>                  w2
>>> ------------------------------------------>  Time
>>> Host            x2          t1->t2
>>>  
>>> 3. write to msr with t3
>>> Guest
>>>                      w3
>>> ------------------------------------------>  Time
>>> Host                x3           t2->t3
>>>
>>>
>>>
>>> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
>>>
>>>
>>> Firstly, we have two fields shared between guest and host as other pv features, saying,
>>>   - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>>>   - pending, the next value of tscdeadline, only updated by __guest__ side
>>>
>>>
>>> 1. write to msr with t0
>>>
>>>               armed   : t0
>>>               pending : t0
>>> Guest
>>>           w0
>>> ---------------------------------------->  Time
>>> Host     x0             t0
>>>
>>> vm-exit occurs and arms a timer for t0 in host side
>>
>> What's the initial value of @armed and @pending?
> 
> Both of them are zero.
> 
> @armed is only updated by host
> @pending is updated by guest
> 
> Guest side will check @armed, it it is zero, jumps to wrmsrl
> 
>>
>>>   2. write to msr with t1
>>>
>>>               armed   : t0
>>>               pending : t1
>>>
>>> Guest
>>>               w1
>>> ------------------------------------------>  Time
>>> Host                     t0
>>>
>>> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
>>> to msr but just update pending
>>
>> if t1 < t0, then it triggers the vm exit, right?
> 
> Yes. If new tsc deadline value is smaller than @armed, namely t1 here, it jumps to wrmsrl
> 
>> And in this case, I think @armed will be updated to t1. What about pending? will it get updated to t1 or not?
> 
> Yes, the guest jumps to wrmsrl and causes a vm-exit, the host side will update the @armed and re-arm the timer
> 

@pending is always updated in guest side no matter whether invokes wrmsrl. In this case, it is updated to t1.

host side only checks it to decide whether to inject local timer interrupt and re-arm the timer.
 
if @pending == @armed, host injects local timer interrupt
if @pending > @armed, host don't inject but re-arm the timer forward.

> 
> Thanks
> Jianchao
> 
>>
>>>
>>> 3. write to msr with t2
>>>
>>>               armed   : t0
>>>               pending : t2
>>>   Guest
>>>                  w2
>>> ------------------------------------------>  Time
>>> Host                      t0
>>>   Similar with step 2, just update pending field with t2, no vm-exit
>>>
>>>
>>> 4.  write to msr with t3
>>>
>>>               armed   : t0
>>>               pending : t3
>>>
>>> Guest
>>>                      w3
>>> ------------------------------------------>  Time
>>> Host                       t0
>>> Similar with step 2, just update pending field with t3, no vm-exit
>>>
>>>
>>> 5.  t0 expires, arm t3
>>>
>>>               armed   : t3
>>>               pending : t3
>>>
>>>
>>> Guest
>>>                              ------------------------------------------>  Time
>>> Host                       t0  ------> t3
>>>
>>> t0 is fired, it checks the pending field and re-arm a timer based on it.
>>>
>>>
>>> Here is the core ideal of this patch ;)
>>>
>>>
>>> Thanks
>>> Jianchao
>>>
>>>>
>>>>> The 1st timer is responsible for arming the next timer. When the armed
>>>>> timer is expired, it will check pending and arm a new timer.
>>>>>
>>>>> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
>>>>> reduce vm-exit obviously.
>>>>>
>>>>>                           Close               Open
>>>>> --------------------------------------------------------
>>>>> VM-Exit
>>>>>               sum         12617503            5815737
>>>>>              intr      0% 37023            0% 33002
>>>>>             cpuid      0% 1                0% 0
>>>>>              halt     19% 2503932         47% 2780683
>>>>>         msr-write     79% 10046340        51% 2966824
>>>>>             pause      0% 90               0% 84
>>>>>     ept-violation      0% 584              0% 336
>>>>>     ept-misconfig      0% 0                0% 2
>>>>> preemption-timer      0% 29518            0% 34800
>>>>> -------------------------------------------------------
>>>>> MSR-Write
>>>>>              sum          10046455            2966864
>>>>>          apic-icr     25% 2533498         93% 2781235
>>>>>      tsc-deadline     74% 7512945          6% 185629
>>>>>
>>>>> This patchset is made and tested on 6.4.0, includes 3 patches,
>>>>>
>>>>> The 1st one adds necessary data structures for this feature
>>>>> The 2nd one adds the specific msr operations between guest and host
>>>>> The 3rd one are the one make this feature works.
>>>>>
>>>>> Any comment is welcome.
>>>>>
>>>>> Thanks
>>>>> Jianchao
>>>>>
>>>>> Wang Jianchao (3)
>>>>>     KVM: x86: add msr register and data structure for lazy tscdeadline
>>>>>     KVM: x86: exchange info about lazy_tscdeadline with msr
>>>>>     KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
>>>>>
>>>>>
>>>>>   arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>>>>>   arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>>>>>   arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>>>>>   arch/x86/kernel/kvm.c                |  13 ++++++++++
>>>>>   arch/x86/kvm/cpuid.c                 |   1 +
>>>>>   arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>>>>   arch/x86/kvm/lapic.h                 |   4 +++
>>>>>   arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>>>>>   8 files changed, 229 insertions(+), 9 deletions(-)
>>>>
>>
