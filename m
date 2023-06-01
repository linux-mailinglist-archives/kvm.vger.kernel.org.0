Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0195371F6A6
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 01:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjFAXbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 19:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjFAXbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 19:31:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A363194;
        Thu,  1 Jun 2023 16:31:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtbvpqOsNdWlanCH9G7UR0UDpPPIEOZxmL5W30GEtF3TPf4ovlxgSj6yNddpnJTeYOdvWpFisa5K7nwHygHVEeVE8TsTgYWVn4vc1Z9c/gG4MpOf7fZ2f92rliZze0Mnm2ukfQLGyiXnH3S30O38NehohJSPwV610C7Z0SNbdqzSzW83mteOdM0ZgY+uRi6p/iDX+AF7v8ph3mZ/5aGW+S//+WUqCQZGsXJgFBMWA6OgH8ee4YnZwbf9xR45OTFQRCIg57iYgRwyEmjCpCPam1saiUXZ5oRvelAImA4KsQY5bx9JA8kPrqHER3ArbXGy2PypgPsHJzovupOxeAQ8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCd+X3dP+YHfVmrq4jYUVy8e6Z2qNqTmGMyZGEcXtFg=;
 b=AbxsJvqkyMgEhV15jhERAFP6SnO5YxtHJ360YVfThZeBak4o9qBdjIWwkeT4qLutcq9FJ8IWyVz7xfL/FWcVLBxEq+PJFVmpCyW1MoLyr9az4vAda5BiZnkletXvK/PLUNUPH/MoZjtoS0f0fuH9ofypLR/UBDquCmhcotXAkHHBbRprYiG12dwDXtCQtxoRXft8nzEYomxYw3WqGdUfhPHxQPPMhndJMtTO+NezVKlsTtx4en3GEBBRUcAqYk7xwCYZApiREfkQiKC4cHqcyVs0DV+pocA9mUkb1klmrAXKOENXrJ531kAD4tvTtq91vNs4k42g4lfzAaZz13j1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCd+X3dP+YHfVmrq4jYUVy8e6Z2qNqTmGMyZGEcXtFg=;
 b=NWUSlcrApznrifykZ7jlFPK3hJa152J+Zfo3j8OK0qbixYqB0DOQ2EuSQ7aTjpJ26FpThEFFVKZBUCC+hPxBAUfV2CgmnkJzk6+Sl9H4dU9F71NSJxZw7pco4UDmfgtgO/kPjQGGUMXSIMdofL2NRI44P1JircztXLQC8sZHGok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DS0PR12MB6582.namprd12.prod.outlook.com (2603:10b6:8:d2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.26; Thu, 1 Jun 2023 23:31:16 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::c815:f324:8eaf:ce61]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::c815:f324:8eaf:ce61%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 23:31:16 +0000
Message-ID: <5e7c6b3d-2c69-59ca-1b9f-2459430e2643@amd.com>
Date:   Fri, 2 Jun 2023 09:31:05 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com> <ZGv9Td4p1vtXC0Hy@google.com>
 <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com> <ZGzfWQub4FQOrEtw@google.com>
 <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com> <ZHDEkuaVjs/0kM6t@google.com>
 <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com>
In-Reply-To: <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0003.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::16) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DS0PR12MB6582:EE_
X-MS-Office365-Filtering-Correlation-Id: aeb95144-43e8-4759-5846-08db62f84b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7K8EVGm9wz3IaLMn/XRjTwloJ/YZtyjsVJiDlPPBF8BD+SJMQ13ZYRTPDuC14GOwhRmQuMmwFGDl4fUPyp9Eh/l43SdCKOnuYwAM5ztstgWnfVhZdRMBJbNC5D1yesXPRxRtTBiswCCcgP3G1li6GJC5VEVLrjx5vK1D0qlq/il6uAtDqQ9VnrPsfzCGZOkCQE+Un3xpaXtBZBCy+sYzC08PzazIT0vbCM0TBKLUDH4zQbPu8xv8SrseAVPPdO/M9+59qice36u/TBEkuSJWYbKAbK0ayVBKLZTkQp5/01tj17vAk3qrMHbYd6EEOTHRaD2axYE38zumTcKnhRYYqfcl/zSnnDVZqqdkQzduLGgQbxMDiVMvx7DdHe/YNWrpYzBzIHDLSWlhEi8rdc5CVFkzIa6RjmmZawJt+Bi0iaAKN7K8ofF77SQsc/umE1wv5XzjreB1VXPVC++rkGUMdvly16z61KFvrjiZfTP/b8H3GgCxhIBXBjg2qpRjCr6S6VuyZyBPUYGK3Jc6QXxrpFMev98bYYNnolKwd1OZ9qhh34YE6G+3pItjdE3LCDLbTm7oQT4sxOz2DD1iGvmtQzb0GB8oWsk78H40b0QdDEC9JhAgAea0rlPAgcdaxY0EzS5BWnvJ0uMwvm9rbAkIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(6486002)(6666004)(36756003)(83380400001)(2616005)(38100700002)(31696002)(53546011)(26005)(6506007)(186003)(6512007)(66556008)(66946007)(66476007)(2906002)(54906003)(6916009)(8676002)(8936002)(316002)(4326008)(31686004)(41300700001)(5660300002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mm9WZUdRVTJla2xQRW91aHNQblBaNjNIUndCWitxVG9aNzZEanM2aGVoUHJw?=
 =?utf-8?B?dkFqWU1jbC9DZEg3VWplNW9jRzZDVU9icjBZcEwwY3RKUHRzcUljOUFJd09Z?=
 =?utf-8?B?cE5McjBNdWwyVjFuaFJBWFl4VGVIc3ZBR3V0c3JnRm50UXFGaWRsNFo2RWlL?=
 =?utf-8?B?cXdZeGhHdWJwczJaaHVkYkFZVmltaHFCd21ITWc3SExkd2tiTTc2QWpSQ0pz?=
 =?utf-8?B?OGh6b3ZRWVZQS2t0YWJmMmp6UVI0Vk80QllVZUJFMmNRY1N1T29PTVdraUdw?=
 =?utf-8?B?dWk1SXhMMUZDbEtMS2Yrc25EalVWTFAyVlFvQll4RWl3ZWZxZ1hDeWtxZmRQ?=
 =?utf-8?B?SUQwYTNiTWIyZnNqcW0zZ1dDcnRReVZ1UkUycFVpcjFteFlCUE9ZSHJocFhQ?=
 =?utf-8?B?Sk5VTkRrencrek5qUHNUNm9ER2orNk5tU3B6UlR6MkpwMm0zTDc1em1ycURK?=
 =?utf-8?B?bWlVSTI4ZkRPckNMd09YQTlWRzBCTHNCcnRRNW04bVpib3d6Z3NmcUhxSldv?=
 =?utf-8?B?ZzIvOGU1UEQ5ckljbUFCVUhWUGY0SW80UGpuM3F2TU1GdjlWVWhWVnRmZXBr?=
 =?utf-8?B?cXdIVG9obzByY24rcEovQkU2TitMTDRWUnlNS2pqcEJCVkhKZ0pDMmk0aVhz?=
 =?utf-8?B?S2ZYVUJqWVYzc21ldjhrRlFFMi9qYzArY096RXY3cStXN21xcTdNeGtoUU53?=
 =?utf-8?B?aDJwOEszdjZUNnFZYVFscUc4VlpDMitjcEJtZ3NQbXp4cU1hWXJnYmFrMW1v?=
 =?utf-8?B?Wlhaem5Ib3VMbjlRRi8ySWNIUFBXckJoNW1PTmVCZk94NjkwYTMvSkVGTTVI?=
 =?utf-8?B?cTNzMS9qNVlacFcxT00vc2V1TWFNc0VXR1gxTWE3aXpoZ0sxQXpUWjFjcW1M?=
 =?utf-8?B?VU5JSXhwNytYNmRTQTMrT0tNT09GWnV6R201am9RL2p4ejc5SmhwSjkvNXRs?=
 =?utf-8?B?WCsvOWVKWnF6YXJMK0dTa3dyWnlBcW5iZDNWYnVPd05vV0t2S0VHYmZHdi9N?=
 =?utf-8?B?d2RtNGl2TGo5VmZJQ1BnbkxDR0IwdE5OMU1tSWplazlvSXJsUkxQQW0ydS83?=
 =?utf-8?B?ZkN5UEdvT3lscUJlUHNDdlQ2a1RIcU15SEhDaW5yeVNYaENaK201ak9VV0py?=
 =?utf-8?B?Rk1GT2FwSENpeDZodkJWZEZRNDdSbzFBcVFhNlovc0FpSXdPM2pPalpVT2lG?=
 =?utf-8?B?bWZCVU5TbERIckk0OEdLKzZYRVllRzNkK2o1WXdFVGpyclN5MnJZZlY0cStC?=
 =?utf-8?B?SDVvRTNDcjR5VkN6VlkxOGZvUzJwWUdTMmxwdWw3bXNobUVEakUwdjlXMldX?=
 =?utf-8?B?cU05UHhtRW5BbitUM3FiRmJ2RUpoc1l4SWNEZDdKcTRNa013V3BwS3d0NUpa?=
 =?utf-8?B?ZkY2SUdWenNic3BJS09nVEN5ZEVGamhLdCtyaTlSSXNtYjIwMDBoTGR1cytT?=
 =?utf-8?B?U0x4RWxTYWV0OTZENEhBdDhTdlpmT3ZJV2R6elVyR1RUYlBDbDJ5eFBBaFVt?=
 =?utf-8?B?WEcrSWVmSklHY3Q0ZzQxbm1oMU9vWVdqWlpIZHVjcVg5YU9McWdneUdhNTZW?=
 =?utf-8?B?NWs3UEdlaFo0ejQvbnJJbHlXOXJZWTZvMWM4R3MzS3h0cGRwei81VEx0cXp4?=
 =?utf-8?B?ZzFEdjBxUUxvN0o2U0xGZDNPUGlvdTJtTFdxRkZDdSs5bFc4bkhuU0xHcVRW?=
 =?utf-8?B?bmhISm15NWRSbTJ2UThrVmhiRHhRckppSHhzMFNuWWdwU1RkcGR2aUljY1Jo?=
 =?utf-8?B?KzU5UTlpSkR2RUpjWXdQM1lSRHlDbkNubkdOc1o4QW13UFNpSTM2NnNSNGR4?=
 =?utf-8?B?YjcwYTZLS2VoWmVtL1k0dHBrMjQzVWh2VjlhVm82L0hiQkVTTG1xTGJEcjNn?=
 =?utf-8?B?dXhORUhONlhCeWN3UU1GWitqbTduM1MwdnpMeDR3UHJYUG13QldJek15aXE5?=
 =?utf-8?B?WmJ4dTZnYUhzWTZTKzZrZWxFRDc5ZTlpTDNEQk1EVGN0K3Q2cSs2ZjRkYXRv?=
 =?utf-8?B?ZU1uVDhhbVhNRXY2LzJNd2tjaVVsSW42Zi9lUC9LLzlYVDlGS3pCTHQxWkNR?=
 =?utf-8?B?TUdMaHB0NFpFZVZCUGRkZmYxOUM2MEEwNEtzZktucmRUek14SEdWRUd2N1VE?=
 =?utf-8?Q?njKi9KIjHfPKEjRiQ+2ydpGBk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb95144-43e8-4759-5846-08db62f84b69
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 23:31:16.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V88gIcrPSclME1vdjxDaWma+DsakA54sptXsITaFqki+tRRuxSAd9gwpLXhtZpk/D5i+hEaOQG+oewshoo6RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6582
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, ping?

I wonder if this sev-es-not-singlestepping is a showstopper or it is 
alright to repost this patchset without it? Thanks,


On 30/5/23 18:57, Alexey Kardashevskiy wrote:
> 
> 
> On 27/5/23 00:39, Sean Christopherson wrote:
>> On Fri, May 26, 2023, Alexey Kardashevskiy wrote:
>>>
>>> On 24/5/23 01:44, Sean Christopherson wrote:
>>>> On Tue, May 23, 2023, Alexey Kardashevskiy wrote:
>>>>>> Actually, can't disabling #DB interception for DebugSwap SEV-ES 
>>>>>> guests be a
>>>>>> separate patch?  KVM can still inject #DBs for SEV-ES guests, no?
>>>>>
>>>>> Sorry for my ignorance but what is the point of injecting #DB if 
>>>>> there is no
>>>>> way of changing the guest's DR7?
>>>>
>>>> Well, _injecting_ the #DB is necessary for correctness from the 
>>>> guest's perspective.
>>>> "What's the point of _intercepting_ #DB" is the real question.  And 
>>>> for SEV-ES guests
>>>> with DebugSwap, there is no point, which is why I agree that KVM 
>>>> should disable
>>>> interception in that case.  What I'm calling out is that disabling 
>>>> #Db interception
>>>> isn't _necessary_ for correctness (unless I'm missing something), 
>>>> which means that
>>>> it can and should go in a separate patch.
>>>
>>>
>>> About this. Instead of sev_es_init_vmcb(), I can toggle the #DB 
>>> intercept
>>> when toggling guest_debug, see below. This
>>> kvm_x86_ops::update_exception_bitmap hook is called on vcpu reset and
>>> kvm_arch_vcpu_ioctl_set_guest_debug (which skips this call if
>>> guest_state_protected = true).
>>
>> KVM also intercepts #DB when single-stepping over IRET to find an NMI 
>> window, so
>> you'd also have to factor in nmi_singlestep, and update 
>> svm_enable_nmi_window()
>> and disable_nmi_singlestep() to call svm_update_exception_bitmap().
> 
> Uff. New can of worms for me :-/
> 
> 
>>> Is there any downside?
>>
>> Complexity is the main one.  The complexity is quite low, but the 
>> benefit to the
>> guest is likely even lower.  A #DB in the guest isn't likely to be 
>> performance
>> sensitive.  And on the flip side, opening an NMI window would be a 
>> tiny bit more
>> expensive, though I doubt that would be meaningful either.
>>
>> All in all, I think it makes sense to just keep intercepting #DB for 
>> non-SEV-ES
>> guests.
>>
>> Side topic, isn't there an existing bug regarding SEV-ES NMI windows?  
>> KVM can't
>> actually single-step an SEV-ES guest, but tries to set RFLAGS.TF anyways. 
> 
> Why is it a "bug" and what does the patch fix? Sound to me as it is 
> pointless and the guest won't do single stepping and instead will run 
> till it exits somehow, what do I miss?
> 
>> Blech,
>> and suppressing EFER.SVME in efer_trap() is a bit gross,
> 
> Why suppressed? svm_set_efer() sets it eventually anyway.
> 
>> but I suppose since the
>> GHCB doesn't allow for CLGI or STGI it's "fine".
> 
> GHCB does not mention this, instead these are always intercepted in 
> init_vmcb().
> 
>> E.g. shouldn't KVM do this?
> 
> It sure can and I am happy to include this into the series, the commit 
> log is what I am struggling with :)
> 
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ca32389f3c36..4e4a49031efe 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3784,6 +3784,16 @@ static void svm_enable_nmi_window(struct 
>> kvm_vcpu *vcpu)
>>          if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
>>                  return; /* IRET will cause a vm exit */
>> +       /*
>> +        * KVM can't single-step SEV-ES guests and instead assumes 
>> that IRET
>> +        * in the guest will always succeed, 
> 
> It relies on GHCB's NMI_COMPLETE (which SVM than handles is it was IRET):
> 
>          case SVM_VMGEXIT_NMI_COMPLETE:
>                  ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
>                  break;
> 
> 
>> i.e. clears NMI masking on the
>> +        * next VM-Exit.  Note, GIF is guaranteed to be '1' for SEV-ES 
>> guests
>> +        * as the GHCB doesn't allow for CLGI or STGI (and KVM suppresses
>> +        * EFER.SVME for good measure, see efer_trap()).
> 
> SVM KVM seems to not enforce EFER.SVME, the guest does what it wants and 
> KVM is only told the new value via EFER_WRITE_TRAP. And "writes by 
> SEV-ES guests to EFER.SVME are always ignored by hardware" says the APM. 
> I must be missing the point here...
> 
> 
>> +        */
>> +       if (sev_es_guest(vcpu->kvm))
>> +               return;
>> +
>>          if (!gif_set(svm)) {
>>                  if (vgif)
>>                          svm_set_intercept(svm, INTERCEPT_STGI);
> 

-- 
Alexey
