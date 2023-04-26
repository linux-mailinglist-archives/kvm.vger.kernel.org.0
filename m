Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013D86EED82
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 07:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbjDZFZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 01:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDZFZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 01:25:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E71110FB;
        Tue, 25 Apr 2023 22:25:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEcFWXH3CvoZHscRFITTvXg1MikUQOqknHGbbdHj2fiMi4GPIxc2ekyPoDJHcc3TR0meHllzl9FhudUABzQ9QwEyHt3MpROmtqTSLDtNrQTMuUDI7q+dBX+Whk39DcL0JFqmB4pxHH53Ob1ozzH3ihP5i42aQy262P55ET1PukFwNvcIhT8+LxbNs7hVxr4zCIRtVaMgUpcX7k+60TGVLnOnv9OzyCusqq8yygc3QtDXUEllAjKTr0Rq6jnthyMCm0IDAJQTdLCo+o3FyCBJ0KJQJ9Kcq58GPPyBvdcWBy5JAGeHk0tmmdDixckHd9bgnge/AEpzfO58WdyFA7hhxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSu0fRKXyaN9Nm3TL0OOQ5vsdJX5I/ouqCjoYBf8yOY=;
 b=f4NU/valHsRCbppyf2z9sulpReGuPYY06dRg/QF5RZS66ixIENNKNcwJgoxIvhROXxuIx1G8t+DXM338BAOcBgT6G+6fOAhI7et7dWYLNz1DZ5B3xQCrNlVEJ2iUAA8cdFc6ilhBZf8HGQF3jLO2bk/OOwSu+TrTWsuujIFzK777POg2cdSNNTW6fyrCeSClLzU6N1f4N1bkF/ab3sqgq2fPMfHyk3bo0gwby95VjwdT9pM2ymcz6vJfPzf8e9rMcggC250/V9S6WJpnctoyZ6YomkK2Pvu7CqybLGNWsLej8R5SPJ8pdy2sl36dFjpUwPmVThNjNPRLPDy6/SqGPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSu0fRKXyaN9Nm3TL0OOQ5vsdJX5I/ouqCjoYBf8yOY=;
 b=tPY7fQZeNH88fRxFAIk8pAuzOt1cY0jeYIz7kAIqOrIqb6uFwCReEp1cVlgxsBijMFij3YCmiTVsuHyHUcf7febwU8NKKdEmU2ukji7z7D6PGCEwmnBs8GjsCERKXm9wdBYTBZbmwJmqnzPAatAcTLqD2+Z1JFPqMiZAXnb1Zws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA0PR12MB8745.namprd12.prod.outlook.com (2603:10b6:208:48d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 05:25:41 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::d1a6:3a8:a6dd:b094]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::d1a6:3a8:a6dd:b094%9]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 05:25:41 +0000
Message-ID: <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com>
Date:   Wed, 26 Apr 2023 10:55:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <20230310105346.12302-1-likexu@tencent.com>
 <20230310105346.12302-6-likexu@tencent.com> <ZC99f+AO1tZguu1I@google.com>
 <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com>
 <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
Content-Language: en-US
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::9) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA0PR12MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: 5459276f-2aad-4d26-37a4-08db4616acfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +XqYFz7/6I5U8MsXM2foE+4JvynAJDkPM10ifkeAr7HOgG1T7oaomNXGIaWrzhviQXC2IDO3bpuuaq/95iuq3SWXw5iMgTqR484G1QEAf4uk/RtaqVLSeHEv4WzcvXEqfjurvKGodBMc8W72SMuF98RfPrFSWAH5jRa1Wy5xvt3M3AyodcqwtWcQuHPMHO+h7KQH1uIdB8JMu6YwEJSgDvZQuN9Rc/IPkNfVvnvPm6SXyYGxaYgNZJutmBelqg42IEc9pAYnaZsxHAM1XmjCGw51I7NxpdOs90Ue93g2yxLM1xKK7bj+nacXjGrpIw2gCNexYmtMdcQKLgRrSMSmIFApax9XG5fIYBAGshB3eyRXKw2s8ciHLrSsA5jLSUl7aKV6MRaqGHhCo54lT7lXqvzTpDoaI6aV3uoilUnZgk3mSaW0sac9+VfbMpNr+MVqF4Xox2I0aFsw8MDL/XMwlfmFr0TLOemAKw2uJ1nwLjAodwCPemzrZnOVBe9wE9KslA0JtNq7EVdNDW4ZQUWipdtMCujRCTY846SuwPM02AG3yABmPA1zoTBPNyvIiJgwJ9QOayFOABwYTt9fk02YuKqLrNxHgbq3wk8RCCtZe1tocSDDbKpLEwHjM5TYlBx6SBellAnxtwCTxR66+Uqu+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199021)(2616005)(66476007)(66556008)(66946007)(316002)(4326008)(186003)(83380400001)(6666004)(110136005)(6486002)(54906003)(478600001)(41300700001)(8676002)(8936002)(38100700002)(5660300002)(44832011)(31686004)(26005)(53546011)(6512007)(6506007)(2906002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1JoTDZEN1VRT2lLdDVmRW1pbjBrU2JtMEoxNmV2VEFwQkxaR2lFbDAxRGVx?=
 =?utf-8?B?WTdlenMvSmlybUgwSkNDbnN5S0Q1eVZZUkpoTmg4M3ZKNGxxeGZNcHA0SUdn?=
 =?utf-8?B?KzYzeUxVVHFxR29vbEF5OEtWc0RISjNZWGhBVWlCeU9SUDBDQlhMdUg4MEJz?=
 =?utf-8?B?YWZVOThBQ29xZWhUUHQyendJcFdpanRkSllXZVdtc3RXbnZUb2ZGMnFWVjBK?=
 =?utf-8?B?ckxnYnRKM1JnZkZzM2JOaTZLdmNZdU12NFNKVVRQeW1xc0Y1SUJlNmxSVC9R?=
 =?utf-8?B?NWdpN3NQZHVhSWpsUEpIZ0VCU1Uwbno2RjlEZHVISFJ3cmp4bklncGFicEJC?=
 =?utf-8?B?Vm8vV0luNDIzZ0dSUElLQ3Vqd0JNV0pZcjFYV0RISGpYNDNTY1BwMk1YOFV1?=
 =?utf-8?B?aVpPcTBra01KUEhtcVJUYXRlWENmK1czWko3NWhzeDRiNFpZKzh5UytXYm8r?=
 =?utf-8?B?QktsMkpHbGN1NmJlVW9ycFYxN1JoRkRTbThlSWo1QlJVQ214UlFBR3YxcU15?=
 =?utf-8?B?RnFOM1Q5VnNnS0dlR0FoUTZyY1lBTi8xZjRoODVBUE1qRTRycEMrMDVyUHhZ?=
 =?utf-8?B?c08vUjhVdDArYVJ1R1UvY2xNcWpZTHRLeURXNUJqUkZrajY1dldGMEMySGlJ?=
 =?utf-8?B?eVVjdVk0VGxDL1lMdURlM0NUaGFXYlpnSFlxd0czakpwUjhRN3U0QXl6cTFU?=
 =?utf-8?B?dWYrUjB5MTV5K3FJNms0S2FjM09LK0FMbmdXL0NaZW9iNVZEa3NTL2V6eUV2?=
 =?utf-8?B?TWJDeExON3Jyc3NQQ0pMekFjbTFsOUY4bnRuVDN6TmhqRDI0V1o3OVA3cWR4?=
 =?utf-8?B?emZBWHZMb2sybm4xbEdLZTBUME1FVXBQYzhpM1cveEl1REtlc1l5QUVNWDkz?=
 =?utf-8?B?bTFyVmhKeXZpNXlCd0dkN2N0VjVHQXVVUEVkTjlGZjl4VitIT3RycWFndFIv?=
 =?utf-8?B?cjJoZzR1U2ZxaytZa3ZmUmo4K21mdzVLYTJEMjNjalVvTG5ZZDVla3ZNbmdi?=
 =?utf-8?B?YTBpdzNkM05MRFNLd2xRYU02SFVRYlY1em1wTU8yd0JSWWVWSFArWVB4SXBM?=
 =?utf-8?B?aThWNVpPOW5rUzBlZk0zdVg5SjM5RFQ0REk0aWNZd2p1aUFLNzlPTEU0ZllC?=
 =?utf-8?B?bUtLYTV1eERUeXNWR0FGL3NYOXVpbHlzZjdxTFExckNKWUt6RXdOZWJPcDZQ?=
 =?utf-8?B?SFphRFlHOE1JengrUkE2S1pEVzd5dXpOdk4vZWNBbnR6dmVRSVBQdENGc2xN?=
 =?utf-8?B?WnFGNkllcUQ0ZE1WaVg5RzRPdXRTRHRjKzMwYVF0MzkvaVJUVE4rbHM4Ujk5?=
 =?utf-8?B?d21WQlU3Zmg0NzJhUTZzWmcyeXJXeksrZkd3djA0UmxOQXBqdDlIdFBPTnVt?=
 =?utf-8?B?R256Q2NRTXc1NGJiUXAxSnd2cGFIcXl0dGMwTThwTFExUE1xSVJ6enF1L01z?=
 =?utf-8?B?a0VISjR3ZExkNGxuclNDM3ZjNVFuaW5NMGZmcHJiTzBmeW11WFBISitPNFZQ?=
 =?utf-8?B?NTczaCtzMDBib21DQXlOUmE3dFZwWFhaRU1lVGlnWFF2SzVOaDd2UjZEb3pF?=
 =?utf-8?B?T1RIK29kSjF4SFRsbzRkdTdwSUZRU0pWZDBIWWZnellXUlJLemdnU2NSOW1p?=
 =?utf-8?B?TDV3UFI5OXlUNWNuaE55S3VzRi9zWlRDaEJjM2V4MmdRaDVhOHZLTGxuc29T?=
 =?utf-8?B?ZnNVcHRTdjdyY1ptMlo0cFlOMGI3aGpqL1ZIYkhZSlpFaGcvNkFPRnhpTkFw?=
 =?utf-8?B?Y3JETmE0U3NIMUUxcUFWSmZNZ1Avcm44QXZpdHNzQmxQUlRXVHlrZGV1d2l6?=
 =?utf-8?B?a25QRXAydit1dzljSzArRFovNzZoZTVSZ3FtdGM1c3o0cWNDMDV2R2ZXSXRI?=
 =?utf-8?B?K1N1Q3pyY0FoSm1PNFZXeTNIeXFhV2w4ZGc4alk5emkrUGNTN3NUcUlUdDB6?=
 =?utf-8?B?SC8zNWtWa3Y4YWlUM3I3Z0YwY2d2R0J2ck95dSsrZFpLYjNhb3lDMC9RRmtO?=
 =?utf-8?B?QmhabVptQW51bjBJL2dLMTVFSkp0OVN0cmhCWlAyWE1ZSFpsT1MvTFk5VUYx?=
 =?utf-8?B?WC9qWE80elR5ZDFHa2RMb1Z3enNxMWV5MkV2M0F2OEszZ3g4RHRid2k0dDds?=
 =?utf-8?Q?edNRkR+SLQpcB0S3DEgEtxBxT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5459276f-2aad-4d26-37a4-08db4616acfb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 05:25:41.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0m4Le/nqjhp6cmINnYHIztwPLyTKqRQpDbKhM1gQwMR81J/9IXiv6T645n3/x5O1d/JUXeGZlBwL+PkzO6uUbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8745
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean, Like,

On 4/19/2023 7:11 PM, Like Xu wrote:
> On 7/4/2023 10:56 pm, Sean Christopherson wrote:
>> On Fri, Apr 07, 2023, Like Xu wrote:
>>> On 7/4/2023 10:18 am, Sean Christopherson wrote:
>>>> Wait, really?  VMRUN is counted if and only if it enters to a CPL0 guest?  Can
>>>> someone from AMD confirm this?  I was going to say we should just treat this as
>>>> "normal" behavior, but counting CPL0 but not CPL>0 is definitely quirky.
>>>
>>> VMRUN is only counted on a CPL0-target (branch) instruction counter.
>>
>> Yes or no question: if KVM does VMRUN and a PMC is programmed to count _all_ taken
>> branches, will the PMC count VMRUN as a branch if guest CPL>0 according to the VMCB?
> 
> YES, my quick tests (based on run_in_user() from KUT on Zen4) show:
> 
> EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
> EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1
> 
> EVENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
> EVENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1
> 
> VENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_USR -> No change
> VENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_OS -> No change
> 
> I'm actually not surprised and related test would be posted later.
> 
>>
>>> This issue makes a guest CPL0-target instruction counter inexplicably
>>> increase, as if it would have been under-counted before the virtualization
>>> instructions were counted.
>>
>> Heh, it's very much explicable, it's just not desirable, and you and I would argue
>> that it's also incorrect.
> 
> This is completely inaccurate from the end guest pmu user's perspective.
> 
> I have a toy that looks like virtio-pmu, through which guest users can get hypervisor performance data.
> But the side effect of letting the guest see the VMRUN instruction by default is unacceptable, isn't it ?
> 
>>
>> AMD folks, are there plans to document this as an erratum?  I agree with Like that
>> counting VMRUN as a taken branch in guest context is a CPU bug, even if the behavior
>> is known/expected.
> 

This behaviour is architectural and an erratum will not be issued. However, for clarity, a future
release of the APM will include additional details like the following:

  1) From the perspective of performance monitoring counters, VMRUNs are considered as far control
     transfers and VMEXITs as exceptions.

  2) When the performance monitoring counters are set up to count events only in certain modes
     through the "OsUserMode" and "HostGuestOnly" bits, instructions and events that change the
     mode are counted in the target mode. For example, a SYSCALL from CPL 3 to CPL 0 with a
     counter set to count retired instructions with USR=1 and OS=0 will not cause an increment of
     the counter. However, the SYSRET back from CPL 0 to CPL 3 will cause an increment of the
     counter and the total count will end up correct. Similarly, when counting PMCx0C6 (retired
     far control transfers, including exceptions and interrupts) with Guest=1 and Host=0, a VMRUN
     instruction will cause an increment of the counter. However, the subsequent VMEXIT that occurs,
     since the target is in the host, will not cause an increment of the counter and so the total
     count will end up correct.

