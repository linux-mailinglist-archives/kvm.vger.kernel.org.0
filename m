Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6365751F94
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbjGMLK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjGMLK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:10:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2029.outbound.protection.outlook.com [40.92.22.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9138CE75;
        Thu, 13 Jul 2023 04:10:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWgx6dpwHm2ZoYFW+gCsZSjCFczbhgGUWO81jZJ2mhglttuYPl7btmSTXJ9xioDP0JDjbQ6ZWOgkQhux2UYzSZJoGqH52kqw2duf8V8hI/Wy4whiwMq9EAkmNOEOt9RXHzzOUgxolHcnU+QwcxKNOGY0rAFjbL1wDvuIdASdb3zVheWv2iRZBSI18xVh1yi/pCdwfcLloXAxC6ZWtx5pOzgxl/3SaBOMtRrVY/jYo+Yso5ZqcZIQUIpfBjpjrx90COiVAzRHqDzUngX9QHxnoY9b+TQX4ArbJzmti95TvbwMMS7NWi+gRqrgTPPbQnDAps3VRmzYg5g+ePbluQ45cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvsQw/EGn9UryP4rLgbJk8tAa6ue0Czt/pDuzwmVebY=;
 b=Tb2ByezJr4J1nlskGC+VGDf75xhX6hcv3IlsZh/rejXzmC2GAQ3GdHGV8+f3di0j25QXtEOHZj/5zUCPoN/ZDpvyD9dR9RsRI32iHf9PGs0gnVQWdEpnvPOg7LfzK+8UySbHNrVI43PkDKQ5qcFbGYQNzUfIM4DQQ1+bzrn3qWcbWrjkLUQ9Ro1sLsJy1I4MMkfkWIwb9g/jl3Xm6ewuSCR4K2Iddzy/IiAz0bCMxhEYYafL4Upant0On8D1IFdKZuOyeLZhlq9OsS7JmvYd+nfJbGnmuf9bSjl3TZM7sOQ08hIdgFbdKqJV/vmgIavQvXdMLyQfgTZJ52UVEU8QYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvsQw/EGn9UryP4rLgbJk8tAa6ue0Czt/pDuzwmVebY=;
 b=ty4kRDXW6GQarQ/xXQ3xk3l9wmZGHmEoV1B+Yn1px3lNhz4YNkEAb2jP1xFUAUiWLB1zfmmyTJYo0OUBmKqD96q6Q226dd30GJzvjEsNf2OIxYiu/Ie3HAMHFPbnHzHpMRHGQG5UTn9F1/Ww5GzSBQkjKbS9QOwsWRgrMIgZifqQNSYkC2WfLJsF2NS578EqBT6VbQBgzuBmdKsnDKlAH9Q0iITD2r1VujdgGIuCtmieOZhad7k06Y77bEqXqtwK6kXfBJIHNeqFZKwslUlSgZNAfEr2kse+4FzOl93R7leYH39v82NONnNzG7QZEl789gNCiQI38DOmOqskTjyJoA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by MW5PR03MB7005.namprd03.prod.outlook.com (2603:10b6:303:1a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 11:10:52 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3%6]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 11:10:52 +0000
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
 <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230713095755.00003d27.zhi.wang.linux@gmail.com>
From:   Wang Jianchao <jianchwa@outlook.com>
Message-ID: <BYAPR03MB413371AAD498CCED98F8C6FECD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
Date:   Thu, 13 Jul 2023 19:10:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20230713095755.00003d27.zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [ZbKaKI7gbWL3XTeujzOgBgLzuC6GqMiXzCaFE97U+wM=]
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <4169bdfd-936d-87be-5541-1ab939dad473@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|MW5PR03MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 70c408ac-ef74-45f9-85ff-08db8391d203
X-MS-Exchange-SLBlob-MailProps: AZnQBsB9XmqZLd1X3toBDeQVLMmFwA23LwnKjnpQa+PjBE0lWjTA46r5+fuJcthtJAqxlOfcUVLtS+9CBPh8JJ+4nAYBcdGbyE/AgtuvvywWefHqXafJBtzah7g7LXVN0sboLpdzrqMaV5cO7m5R3HbPCnz9bx3tpythIEIeqX5Ig6UEBEtjQi2Cgk4iD4afCoesrB1CUKobysgx/x967xrpyDaSQ1tc3RTn5cHYTQHXZM/SvaVDBSJ0I1JkfuuzuaDWPPeaOYY9xrm57YzX4Mj7d6zOSA03QxNjewNDQJ8O1h96SKOKOSS/bQdO/Phe9Z2cG1d52wGcgmIo+lmZrD9KgS+YsVBVN6USFRRknJuG6XAh6GGFKUVT43KX5nGNC/G8L50jhZCBcDnCOEHpihN/yXluE+e/ORU6JJAXPZEBIyONEfFSKFWx2o+1sx47LWmmEppmotn+Xdt9gV2Cw3SVvfhFLoVCNob9v9OmEF1uVsG/aQQHf8F8j6rJwjCWw/E+6eEv/eLVQFDPBD7NBgtlDGhycmm8burxwOCLrhkPcsoa21AuN4XvqY5oyATpQE6Ahjq6j0pTUrVvUi/miuV6W1xxyw8u9XqZm6NAKhGmNuRcVRMh/9GN8Q8kaAIx4jPjFWa8H8MCNi5Nx+cl6bSmnTYQMkq3MYhZOzgQMDG/xhQWW/Vgg6aCPpZhBA37mSa65TcwfCcH50720j6vAhQ28vLXYwVJfvhQtkSvCrtSlcmV/3ML/uF8sjeqseyyBJstLN3U5S8=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fNUS2pJCqT2fQVHmjDMkOPLHZmCjOp3ia0Yn6KHUqktoyyBrFhfRl5TM0drp53gxOFU+t9fwPYKUB2+U8mMN/0nf/bzQsHjLjLF+7huDZBypa0wzoPAUmuP6uHeP7EnYkTg6zGH4D+VpgbGc6ZlAePiXyJncmWHkKpRj2swocel9OIp+FolnBDg0UQGgEzyPVOxs1icPttNFc8oszWB2SV1Ks1so+rl/XysOeu43M2UyZdeYurre1pI2K9S7Sq/sAjOvbbOXnwhLQXyh2i7tzDb8dONA6JSNqNp3iODoVqN30BrOPqUlJ4IvT6Q7Dsmhpb/M3cZKLJK6t7KXjiAiMPVgD0cM332rAz0U7po0OKYTVWmbpVRoADMRoU7jO/eCekmXK2rr5ZClttDXnuEeCn+x+y6K1GV4RbkjZc3CtKKa0vumYYZ6W5XybRe6rXrgdKfYz/0oS/X+0f+kohr+tY56YVR2Mt3XtWA+nZ3o2X6b/JylIYFqVksX3DG75YT3zJoHMGqxhknIcyseq4W+jOXxDmRao/pjQiIm0fXsoxNeMwQI9uq1iMPFhk3I9bVb
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTBDVm1adDRMQ05qMXBEVkViZ2w0WWR5M3dFRGFpM2N5OUhmdVdxQk5jN09i?=
 =?utf-8?B?aU1EYXZmcmJpVXpGRlNoT3V1WFBSRDYwYWZnNEJUYitZc3VYR2Fqdm8rSGF2?=
 =?utf-8?B?UCsyWm5NdjJQWWU1R2c2ckxJMGwwVVlLalYvN3hkVWVGZUp6SG1kY3B4N3dV?=
 =?utf-8?B?YzZYUDlocUl2WC8ya3N1Vk5XYzBBYTJWMWpXRzQrZG5jTWE4VWJJRGZjMmpW?=
 =?utf-8?B?U09mV09IbmMxUVdTSlRhM1FTWEtrT0pCbi9jaUtFUXcyeDBoK0Q1dHdlRCtB?=
 =?utf-8?B?RktKLzg4MHY2TjJ3WjdQVHA1dmxlVW4xMzRob1pWbWI4L1kvc3V3SUJLOUQy?=
 =?utf-8?B?cTRrS2s3UjBrcWtkUzl5TTBSbVlBcUFKYzEwc2twdGwwZ1dYYlExSDlTZVE0?=
 =?utf-8?B?aGREZjJGbC9xeXhQSThFL1dGa1R6bmxLWGQzcGxuZkxoS2NaV3Zucmo2ZXBy?=
 =?utf-8?B?djkzYW1JN2d5YmFkQ1RUazg4SWFqMGRMTU5PMldoKzR3eTdaT2lLQm11OXUw?=
 =?utf-8?B?SzA5RGlzRnJMUmlQalQvd1BlVURmajEwTU1XcWkyQVR4cTB1UE5PaVJQM3hZ?=
 =?utf-8?B?SUgxSGZIVis4Ukx6SkN0OFZMM2MvZ1VSVVF2Q016aHpNNlZXWVY5YUp3eEFG?=
 =?utf-8?B?YXhOc3B4bytqQ0NsMXREQU4zZmJiR0lzTHZJdFFJbldSTktXQ2tjK0xNakFK?=
 =?utf-8?B?UmdocjNkQWJ2Vm5BM04zallWQkVrS3BTQWJXWHBLMWRuZ0hUV2grTS9NOCtu?=
 =?utf-8?B?d0JSQ2F4N3FlUGdjMU9BMFU3QTh5TEs1QTMrQ1p0ZVhhQXpHNTBkelNpYWxV?=
 =?utf-8?B?QTNycmszUFBJanVnaG9TdkVFd2lsTDNJdjh2U2FwV1YyckpJeTN0SkZvVkJp?=
 =?utf-8?B?amN2d3ZucnBiMXMxK25JVG5yM3ZwbDNtUTVEYXVNbWNNdkVPRDJIM1Q5a0c2?=
 =?utf-8?B?NnVXN0ZCWkErTlJOcExxa1ZobS90dktKM2M1YVNHMFVoRERLa0M5VGxrd01D?=
 =?utf-8?B?NWdBTE5PMHY4aW1rSDhIM09iY2o3aHRtNkFlM0kxWU5OanBqa3pWaldvMloz?=
 =?utf-8?B?ZVZkOVVvSy9TNVhha3hyajVoT0FIWXpCd0Z1OFE2VU1BRUxnVzYxU1pyUy9B?=
 =?utf-8?B?TVVldS96anpYczhwdDBmSDVzK3o0Tis4VEw1SUNETUpVbElBbWRNSUtRUWsx?=
 =?utf-8?B?bXFMbkVtcERDZnRpcnMzeGQxWU9GTnJCd0dMRWxsa0xIdG9CRGhiY3F6ZUh5?=
 =?utf-8?B?eURCZ0hsVEhOcUNMd2F5bTVIaDVWWXF1bVRnanp4OWdOYjZ2a3J1MHA5cTJD?=
 =?utf-8?B?S0tWTmRmTEVyS2FhVXcvT0hkcExmVVcySElCZjl2V1FIYUdjUGI5RkRiZ2Nq?=
 =?utf-8?B?b2RPa3IzdjIzS1p0Ukl6R2dpSU5ONXNHQVFxQzBGQnV1SytGWlFVNmRnc04w?=
 =?utf-8?B?S3NVZDZjbUMwVXI0Z3c2RHVNTUx3RmdhQ2xubHNYOWRLZEVOZmp2TTRSMXkx?=
 =?utf-8?B?U2d6eUhlekJpTlhreGx2Vkl3L0hZWEJFajNWU1BSTDNSdWZIVkMzcUhlVTYy?=
 =?utf-8?B?VHMxQXhvY2IxK3pyQ0RPTTJ1UkZFanhVdkdJV0hxK1kxYyt3UTNMMWQ1REdL?=
 =?utf-8?Q?ee7jOC/Jl8DQ9HkN8xJlp+G5kkFqYYbzCz6RTwcIBhxE=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c408ac-ef74-45f9-85ff-08db8391d203
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 11:10:52.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR03MB7005
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023.07.13 14:57, Zhi Wang wrote:
> On Thu, 13 Jul 2023 10:50:36 +0800
> Wang Jianchao <jianchwa@outlook.com> wrote:
> 
>>
>>
>> On 2023.07.13 02:14, Zhi Wang wrote:
>>> On Fri,  7 Jul 2023 14:17:58 +0800
>>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>>
>>>> Hi
>>>>
>>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>>> because the timer is often over-written before it expires. 
>>>>
>>>> v : write to msr of tsc deadline
>>>> | : timer armed by tsc deadline
>>>>
>>>>          v v v v v        | | | | |
>>>> --------------------------------------->  Time  
>>>>
>>>> The timer armed by msr write is over-written before expires and the
>>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>>
>>>>          v v v v v        |       |
>>>> --------------------------------------->  Time  
>>>>                           '- arm -'
>>>>
>>>
>>> Interesting patch.
>>>
>>> I am a little bit confused of the chart above. It seems the write of MSR,
>>> which is said to cause VM exit, is not reduced in the chart of lazy
>>> tscdeadline, only the times of arm are getting less. And the benefit of
>>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>>> to imporve the chart a little bit to help people jump into the idea
>>> easily?
>>
>> Thanks so much for you comment and sorry for my poor chart.
>>
> 
> You don't have to say sorry here. :) Save it for later when you actually
> break something. 
> 
>> Let me try to rework the chart.
>>
>> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
>> a vm-exit occurs and host arms a hv or sw timer for it.
>>
>>
>> w: write msr
>> x: vm-exit
>> t: hv or sw timer
>>
>>
>> Guest
>>          w       
>> --------------------------------------->  Time  
>> Host     x              t         
>>  
>>
>> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
>> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
>>
>>
>> 1. write to msr with t0
>>
>> Guest
>>          w0         
>> ---------------------------------------->  Time  
>> Host     x0             t0     
>>
>>  
>> 2. write to msr with t1
>> Guest
>>              w1         
>> ------------------------------------------>  Time  
>> Host         x1          t0->t1     
>>
>>
>> 2. write to msr with t2
>> Guest
>>                 w2         
>> ------------------------------------------>  Time  
>> Host            x2          t1->t2     
>>  
>>
>> 3. write to msr with t3
>> Guest
>>                     w3         
>> ------------------------------------------>  Time  
>> Host                x3           t2->t3     
>>
>>
>>
>> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
>>
>>
>> Firstly, we have two fields shared between guest and host as other pv features, saying,
>>  - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>>  - pending, the next value of tscdeadline, only updated by __guest__ side
>>
>>
>> 1. write to msr with t0
>>
>>              armed   : t0
>>              pending : t0
>> Guest
>>          w0         
>> ---------------------------------------->  Time  
>> Host     x0             t0     
>>
>> vm-exit occurs and arms a timer for t0 in host side
>>
>>  
>> 2. write to msr with t1
>>
>>              armed   : t0
>>              pending : t1
>>
>> Guest
>>              w1         
>> ------------------------------------------>  Time  
>> Host                     t0    
>>
>> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
>> to msr but just update pending
>>
>>
>> 3. write to msr with t2
>>
>>              armed   : t0
>>              pending : t2
>>  
>> Guest
>>                 w2         
>> ------------------------------------------>  Time  
>> Host                      t0  
>>  
>> Similar with step 2, just update pending field with t2, no vm-exit
>>
>>
>> 4.  write to msr with t3
>>
>>              armed   : t0
>>              pending : t3
>>
>> Guest
>>                     w3         
>> ------------------------------------------>  Time  
>> Host                       t0
>> Similar with step 2, just update pending field with t3, no vm-exit
>>
>>
>> 5.  t0 expires, arm t3
>>
>>              armed   : t3
>>              pending : t3
>>
>>
>> Guest
>>                             
>> ------------------------------------------>  Time  
>> Host                       t0  ------> t3
>>
>> t0 is fired, it checks the pending field and re-arm a timer based on it.
>>
>>
>> Here is the core ideal of this patch ;)
>>
> 
> That's much better. Please keep this in the cover letter in the next RFC.
OK
> 
> My concern about this approach is: it might slightly affect timing
> sensitive workload in the guest, as the approach merges the deadline
> interrupt. The guest might see less deadline interrupts than before. It
> might be better to have a comparison of number of deadline interrupts
> in the cover letter.

This patch is based on the idea that the tscdeadline msr can be overwritten
many times before local timer interrupt is fired. ITOW, the tscdeadline msr
is moved forward again and again, as well as the timer in host side, but
there is no timer interrupt during this period. The guesOS should guarantee
that there is no pending timers if it invokes set_next_event. If there is
deadline interrupt lost, it should be a bug ;)

> 
> Note that I went through the whole patch series. The coding seems fine
> except some sanity checks and typos. I think it is good enough to
> demonstrate the idea. Let's wait for more folks to weigh in for the ideas.
> 
> For cover letter, besides the chart, you can also briefly describe what
> each patch does in the cover letter and put more details in the comments
> of each patch. So that people can grab the basic idea quickly without
> switching between email threads.
> 
> For the comment body of patch, please refer to Sean's maintainer handbook.
> They have patterns and they are quite helpful on improving the readability.
> :) 

I will try to put more details int the comment of patches

> 
> Also, don't worry if you doesn't have QEMU patches for people to try. You
> can add a KVM selftest to the patch series to let people try.
> 

Thanks so much for your kindly comment !
Jianchao

>>
>> Thanks
>> Jianchao
>>
>>>
>>>> The 1st timer is responsible for arming the next timer. When the armed
>>>> timer is expired, it will check pending and arm a new timer.
>>>>
>>>> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
>>>> reduce vm-exit obviously.
>>>>
>>>>                          Close               Open
>>>> --------------------------------------------------------
>>>> VM-Exit
>>>>              sum         12617503            5815737
>>>>             intr      0% 37023            0% 33002
>>>>            cpuid      0% 1                0% 0
>>>>             halt     19% 2503932         47% 2780683
>>>>        msr-write     79% 10046340        51% 2966824
>>>>            pause      0% 90               0% 84
>>>>    ept-violation      0% 584              0% 336
>>>>    ept-misconfig      0% 0                0% 2
>>>> preemption-timer      0% 29518            0% 34800
>>>> -------------------------------------------------------
>>>> MSR-Write
>>>>             sum          10046455            2966864
>>>>         apic-icr     25% 2533498         93% 2781235
>>>>     tsc-deadline     74% 7512945          6% 185629
>>>>
>>>> This patchset is made and tested on 6.4.0, includes 3 patches,
>>>>
>>>> The 1st one adds necessary data structures for this feature
>>>> The 2nd one adds the specific msr operations between guest and host
>>>> The 3rd one are the one make this feature works.
>>>>
>>>> Any comment is welcome.
>>>>
>>>> Thanks
>>>> Jianchao
>>>>
>>>> Wang Jianchao (3)
>>>> 	KVM: x86: add msr register and data structure for lazy tscdeadline
>>>> 	KVM: x86: exchange info about lazy_tscdeadline with msr
>>>> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
>>>>
>>>>
>>>>  arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>>>>  arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>>>>  arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>>>>  arch/x86/kernel/kvm.c                |  13 ++++++++++
>>>>  arch/x86/kvm/cpuid.c                 |   1 +
>>>>  arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>>>  arch/x86/kvm/lapic.h                 |   4 +++
>>>>  arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>>>>  8 files changed, 229 insertions(+), 9 deletions(-)
>>>
> 
