Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A06AF885
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 23:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCGWW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 17:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjCGWWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 17:22:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46822E0FB;
        Tue,  7 Mar 2023 14:22:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKriaZZOMZ7+BzWxVcNBzKhKolTZ2Mu0oS8yTZ2xcDz1gnDKQvXv3rojwz0XaGZHn80G0l26+FBE42fSyPsgkxuQBPn9MVYSAyhcW1Ss6wur5HdMwt+uOQPwwK60ZAPoHQ36v4Xmv17jeume4f2eARMuHCN+eUf8DlRsIIzFl+AeP7+kfSy9HyLO3NT34Tzn+0471EIcue0QLnsjndL3Y2IMxYhz+91y41u01XjJYOTdFHse7Q4Rw/SmsOVL8xcpATS3M7B4MlUdQrRtuk3f9qFskMXKo2n0nceDgwEKVJJX5OFIq0fU46o/QOmLkd9W4axna/mJyxxna23t2caKdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Odgx0Ea5jekT9xp3eL03ELEnsdLpgmLKLDenjl/3JWE=;
 b=Pv3BB1cIYENnxOQVsIqLp5/xyMUAm8cQaTsRxz4pw+ICfICBNtTQOJUEfNvZGLPS/fTsWKqqAt9FZrhMYmgppZU1DSaVzHr9zAPUspkT1uzlRPe2YERBqQ8S//gvSvGTX+3Hju98lzah8lnkaFZjTXX4E25XCpkVEPrMOs+mWuVhy2XZBtBw47Ds3RZ9icsFJNz635DrNE3Y3rYfcF5PvHPD/pfykTDA1XtTD9mxNvqKWtX4p/fC3G/BgYTovPLlIEDWQVRXktoQcIbAd6+UEkjhs0ivbHX8Z7lw9RLiuAJSUjfFj7xcOF9JOWgGX7J47x7pbbetEjQIRVBPEuy/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Odgx0Ea5jekT9xp3eL03ELEnsdLpgmLKLDenjl/3JWE=;
 b=yQeuPc6IDrNDHicyp66+ZHj8ZmYbLpwSKEMS7ImktHlzxmhFn3f5LxH3bQ0MSNNwOD1+c9pE9G855o/kkc3viZAm0obbdsrdE5Su3YH53FghHGdRrOEKvObsx1z0nmdO3Z66v+hJv3NlRwoyAMNE50uan1F4bqU0SbIpyifqJJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB5752.namprd12.prod.outlook.com (2603:10b6:408:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Tue, 7 Mar
 2023 22:22:32 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 22:22:31 +0000
Message-ID: <3bfbbd92-b2ed-8189-7b57-0533f6c87ae7@amd.com>
Date:   Tue, 7 Mar 2023 16:22:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, brgerst@gmail.com,
        "Rapan, Sabin" <sabrapan@amazon.com>
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        seanjc@google.com, pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
 <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
 <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
 <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
In-Reply-To: <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:208:178::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB5752:EE_
X-MS-Office365-Filtering-Correlation-Id: ac0b5a4f-21b4-40a9-33af-08db1f5a7182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AiRzmAZjkGcg2h0nZ57srhprsvUjHVlzovgpxlKBWZaaThWmgFCzjBpAOgty7Mbu0UZvE2e0TBNXpz/YEhRql3xfvU9KbMzL7ecLi+o5MZe1Ac/bLiKuQ/8zTRM9WaCSd1eOuPJRtACt44DRATEb9LPjn5aTTJ5b+2b8Y2phvYujqde5ymyureqr6Jj0BfuL0XWJyTHOb+C+QbD3vin7UDFpZeYrbH0sWj7GrUcr1vlijSDI5HUWKI8Hf4Bwcv5p53URv2WyI5fP6mSF9uGJva1t+V1RaoIxZ1wUb4+28A+UhFzmj/MuTqAY/ADRL6sOlW5CNF1KEXnOm+fBUPw3wBgqmRxvlB3Iq3C9PtZzP+IN0m2NQaqkGDcxiw83C2+2R6tuuQ4WROxaHWmS/BKF5EuoilQWrGUTCRKj5B+5o25SqyDnS/d/AN1FQbGSxlEtZ8ESV5ANWO67FbBepcILlhQNNvO4a8JLFgxNhP1CpEg3TkwX5N55UvUP1xhksKi+Ykwg7GxXmOW/Hxonnt4C1mK/0fRIQle0FBYZjuCCw4pBnLIvwKhVJGyR7cqiFoAHXJH5+uKAPdUIyZuHADl565OTiEmtPsDPdAoqb7xXfTRFplvimAJCWXzkV8YSR1fI94ou4CIAcxIUMLtVFySLP7a0VZb43OAf8nxZ6JxO47cJCXtLVNgUX4HG+6JvgklMej2kmo9WoF/Trxo5+VH2O6GxHMKt/4ZDmFl1ydfGYkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(110136005)(478600001)(5660300002)(7416002)(38100700002)(41300700001)(4326008)(316002)(66476007)(66946007)(8936002)(66556008)(8676002)(53546011)(36756003)(6512007)(2616005)(6506007)(2906002)(966005)(6666004)(30864003)(86362001)(31696002)(31686004)(26005)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXFGRk1oQk1wRXJPbnh6K21kdjNRcDZLM015OStvY1FRd1ZZWDc0b1ZrMVFr?=
 =?utf-8?B?SVFadHhtRmd4NFRxUmtzTUZOaDU2L05rdXRBazY5WWRPYm4xTC9BeXpQbzN6?=
 =?utf-8?B?UHBSMTZVMWxsUjhkUDhDSjlrSkNkRmFzbDhab05wVWkrRXplbkhLZjlXRUJq?=
 =?utf-8?B?cXpDNmxnU2ZTd25LcWk1bTBPYmYwNkpzOTJuYktOWENOaG52ZTlKUkFxN3Bz?=
 =?utf-8?B?L2hrbXNwWlFzUDY3K09ER3ptaVZNOUNNSnM5M1B3dFN0bXRkR1FvWDlFNjFN?=
 =?utf-8?B?a3h3QkRkTDFiZEcwZFRDZUQwUjJLbG14akNRc3hiVXJlQkFqei8yMG9hb2Nw?=
 =?utf-8?B?NldhcU0xZ1o5SFNoVndOSmQyUjZmQUdtRmQ0SzlJaFhUR0hLTUM3MGdYeG5a?=
 =?utf-8?B?ZWJ1N0VLVzh0UUM0QThSR1UraXZjdFBSYnc5WkNaRlBYcmdEdlhlYS94ZEUy?=
 =?utf-8?B?anQzT1BEUkVaT2k3NnBNR3VYME9NWFZQV2QvQmh2akxWNmc1S25yMTBOSXZK?=
 =?utf-8?B?UFk3dEQzTytYYncycTJNOS9LZEdmR1M5Qmt2VlJsaTBIVWdJUGNOclM5UVAr?=
 =?utf-8?B?STJkZTY3WFRXc1l5VzVmNEJsdnJhQTMwL0RRd3htYU83bEZtWVZ4YS9kTDhP?=
 =?utf-8?B?ZlpkWW1lTEhHdko2QnZiL3VHMzhvQTJ1aksxY0c5RnFEUms3TXhacGp4RHJL?=
 =?utf-8?B?ODczZUFFd2Nwam1pc1MyZnZtTXk1Wm9pVU5ZT1ZFdkNESmwwZmJ2ek93QWRx?=
 =?utf-8?B?Y1FOL0lueFlnNU91ZjJCQ3N0clowT1pTRjJhaVVQUWdGc0h3V1ZMVkRTcUFw?=
 =?utf-8?B?dFE1M1JVUFE1bnNVQUlnamZtbUdrazdnMVBDaml0Rit1dE5jVW10ZzJqM3RP?=
 =?utf-8?B?WVBEdFVHdGR5NjZCRG4wVWhZcmNzK1FzN3VzMVlDUzJyS2d5aUI1QjFLV28v?=
 =?utf-8?B?OFdrS1NGeEVWZGc5TlEvR2lRSHpMZkFSTnM3bnZVa0wxOFVKUmFCQVIrTmxG?=
 =?utf-8?B?aEhLQ21LZCtGZEwyQjhxNDdLUEtPZUk0dVJCL0o5Vk5YanBmOG5jTHJIQ2JY?=
 =?utf-8?B?TGNFTUNQK2Z1R2J6QnRQWFQ5Vmk0aVhEelh2Qm5RWnMwNERsWEdSUHVIbTQv?=
 =?utf-8?B?ZnhhdXBJckt1U3dGaDJYbmFvRkpUTVhFL1ZuKzAyai9ndFVvZG02ODNGM0Rt?=
 =?utf-8?B?NzZ1QnBaUi9qVXRNMGhzRStLT1QyMU5EanZSQk4yb0dQc0hFcWRnVFBLSnhU?=
 =?utf-8?B?QS9oZ2RtRDduRFdWWU14QXh3Q09VWXFwblM2R2ZENTJNcnVzdUVaa2ZuNzJV?=
 =?utf-8?B?bTN1RkR1VURvRDJubE1IR1RnR1pFU1ljajBlUTlVbGZEbzJwbE8xdTYreFNR?=
 =?utf-8?B?U3ZKTUs3bEZtMkFXcVhpVFRQS256R1h5NXNRNkwxNm5HdFhDQ3c2NzNLZGxJ?=
 =?utf-8?B?SGI0NllDa1B0V2JWNEV5MEVzYzhmYzZlMllyZGg5VURlUWZnbGk1eUdsc3Nn?=
 =?utf-8?B?N3pmUmRlYmlTczg4b09odldiMmlGUWd2Tk94NnRzd0JXcS95VUQzMXRjaXQ1?=
 =?utf-8?B?Rzc1N1V0YWNFSi82VzZZUTNZbFBvM3AxdnZ3Z2RwMHp5NUY4MjNHeE0yaHRQ?=
 =?utf-8?B?K0todGs4NnVCcTNtbDJrRFpUdlcwbmNxN1QyaWRNLzVOdzFpYkc1dkozRXZi?=
 =?utf-8?B?RjNjMW9ZTHdWUmhwRDZETXo4dGNYdzcwT1FnakJET2RGTWpkdldPUjY5L3dO?=
 =?utf-8?B?LzZuNU9uL1BQdHplVHFBTUMyL2JWNWs2OEg4ZTZoYnRjd1B5ODhuUndIWWJC?=
 =?utf-8?B?b0hPRjF5Q1NtNzg2OVpFelVNZlJ5ODVZaWZRUTBxV0tUaUl4T1lVT25wMlAv?=
 =?utf-8?B?MVozdFdFdFUvZDBhZFVGeWo4MlZqRERzOHQyZlJhbFhvdUhLMmhmUGw0aGZ3?=
 =?utf-8?B?YkNWa25naGQxYXByS1RpdTRNS0VVS3F5S04yaThBUng0akFqZk9MMXptbFo4?=
 =?utf-8?B?Uzg0OW5aY0JnZGxyTVlDTm5YTnpON055SmQrZzlITllNOExkOVlkYTZiNFQr?=
 =?utf-8?B?Y1dSbUVGWUZhYmZ1ak5iWjdMci9JOW03dUc4Ky95T0FEU3FLWUEzUGwxZVhT?=
 =?utf-8?Q?Rg0GK2g/PklMl6HLk/2G1zV2s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0b5a4f-21b4-40a9-33af-08db1f5a7182
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 22:22:31.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0njXDFw5xampE5TXuZFzmxnjrpTrbhc0uxXvsUs5/UT/B4kthLptmrZ1Jae2xHv5FceXdQe7iigJusKQgdQfdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 14:06, Tom Lendacky wrote:
> On 3/7/23 13:18, David Woodhouse wrote:
>> On Tue, 2023-03-07 at 10:45 -0600, Tom Lendacky wrote:
>>> On 3/7/23 08:42, David Woodhouse wrote:
>>>> On Thu, 2023-03-02 at 11:12 +0000, Usama Arif wrote:
>>>>> The main code change over v12 is to fix the build error when
>>>>> CONFIG_FORCE_NR_CPUS is present.
>>>>>
>>>>> The commit message for removing initial stack has also been improved, 
>>>>> typos
>>>>> have been fixed and extra comments have been added to make code clearer.
>>>>
>>>> Might something like this make it work in parallel with SEV-SNP? If so,
>>>> I can clean it up and adjust the C code to actually invoke it...
>>>
>>> This should be ok for both SEV-ES and SEV-SNP.
>>
>> Thanks. So... something like this then?
>>
>> Is static_branch_unlikely(&sev_es_enable_key) the right thing to use,
>> and does that cover SNP too?
> 
> Yes, that will cover SNP, too.
> 
>>
>> Pushed to
>> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-rc8-v12bis
>>
>>  From d03aed91e5cfe840f4b18820fe6aed1765687321 Mon Sep 17 00:00:00 2001
>> From: David Woodhouse <dwmw@amazon.co.uk>
>> Date: Tue, 7 Mar 2023 19:06:50 +0000
>> Subject: [PATCH] x86/smpboot: Allow parallel bringup for SEV-ES
>>
>> Enable parallel bringup for SEV-ES guests. The APs can't actually
>> execute the CPUID instruction directly during early startup, but they
>> can make the GHCB call directly instead, just as the VC trap handler
>> would do.
>>
>> Factor out a prepare_parallel_bringup() function to help reduce the level
>> of complexity by allowing a simple 'return false' in the bail-out cases/
>>
>> Thanks to Sabin for talking me through the way this works.
>>
>> Suggested-by: Sabin Rapan <sabrapan@amazon.com>
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

I did some Qemu/KVM testing. One thing I noticed is that on AMD, CPUID 0xB 
EAX will be non-zero only if SMT is enabled. So just booting some guests 
without CPU topology never did parallel booting ("smpboot: Disabling 
parallel bringup because CPUID 0xb looks untrustworthy"). I would imagine 
a bare-metal system that has diabled SMT will not do parallel booting, too 
(but I haven't had time to test that).

I did have to change "vmgexit" to a "rep; vmmcall" based on my binutils 
and the IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) change I mentioned before. But 
with that, I was able to successfully boot 64 vCPU SEV-ES and SEV-SNP 
guests using parallel booting.

Thanks,
Tom

>> ---
>>   arch/x86/include/asm/sev-common.h |   3 +
>>   arch/x86/include/asm/smp.h        |   3 +-
>>   arch/x86/kernel/head_64.S         |  27 ++++++-
>>   arch/x86/kernel/smpboot.c         | 112 ++++++++++++++++++------------
>>   4 files changed, 98 insertions(+), 47 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h 
>> b/arch/x86/include/asm/sev-common.h
>> index b8357d6ecd47..f25df4bd318e 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -70,6 +70,7 @@
>>       /* GHCBData[63:12] */                \
>>       (((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
>> +#ifndef __ASSEMBLY__
>>   /*
>>    * SNP Page State Change Operation
>>    *
>> @@ -160,6 +161,8 @@ struct snp_psc_desc {
>>   #define GHCB_RESP_CODE(v)        ((v) & GHCB_MSR_INFO_MASK)
>> +#endif /* __ASSEMBLY__ */
>> +
>>   /*
>>    * Error codes related to GHCB input that can be communicated back to 
>> the guest
>>    * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
>> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
>> index defe76ee9e64..b3f67a764bfa 100644
>> --- a/arch/x86/include/asm/smp.h
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -204,7 +204,8 @@ extern unsigned int smpboot_control;
>>   /* Control bits for startup_64 */
>>   #define STARTUP_APICID_CPUID_0B    0x80000000
>>   #define STARTUP_APICID_CPUID_01    0x40000000
>> +#define STARTUP_APICID_SEV_ES    0x20000000
>> -#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | 
>> STARTUP_APICID_CPUID_0B)
>> +#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | 
>> STARTUP_APICID_CPUID_0B | STARTUP_APICID_SEV_ES)
>>   #endif /* _ASM_X86_SMP_H */
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index c35f7c173832..3f5904eab678 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -26,7 +26,7 @@
>>   #include <asm/nospec-branch.h>
>>   #include <asm/fixmap.h>
>>   #include <asm/smp.h>
>> -
>> +#include <asm/sev-common.h>
>>   /*
>>    * We are not able to switch in one step to the final KERNEL ADDRESS 
>> SPACE
>>    * because we need identity-mapped pages.
>> @@ -242,6 +242,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
>> SYM_L_GLOBAL)
>>        *
>>        * Bit 31    STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
>>        * Bit 30    STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
>> +     * Bit 29    STARTUP_APICID_SEV_ES flag (CPUID 0x0b via GHCB MSR)
>>        * Bit 0-24    CPU# if STARTUP_APICID_CPUID_xx flags are not set
>>        */
>>       movl    smpboot_control(%rip), %ecx
>> @@ -249,6 +250,8 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
>> SYM_L_GLOBAL)
>>       jnz    .Luse_cpuid_0b
>>       testl    $STARTUP_APICID_CPUID_01, %ecx
>>       jnz    .Luse_cpuid_01
>> +    testl    $STARTUP_APICID_SEV_ES, %ecx
>> +    jnz    .Luse_sev_cpuid_0b
>>       andl    $0x0FFFFFFF, %ecx
>>       jmp    .Lsetup_cpu
>> @@ -259,6 +262,28 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
>> SYM_L_GLOBAL)
>>       shr    $24, %edx
>>       jmp    .Lsetup_AP
>> +.Luse_sev_cpuid_0b:
>> +    /* Set the GHCB MSR to request CPUID 0xB_EDX */
>> +    movl    $MSR_AMD64_SEV_ES_GHCB, %ecx
>> +    movl    $(GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ, %eax
>> +    movl    $0x0B, %edx
>> +    wrmsr
>> +
>> +    /* Perform GHCB MSR protocol */
>> +    vmgexit
>> +
>> +    /*
>> +     * Get the result. After the RDMSR:
>> +     *   EAX should be 0xc0000005
>> +     *   EDX should have the CPUID register value and since EDX
>> +     *   is the target register, no need to move the result.
>> +     */
>> +    rdmsr
>> +    andl    $GHCB_MSR_INFO_MASK, %eax
>> +    cmpl    $GHCB_MSR_CPUID_RESP, %eax
>> +    jne    1f
>> +    jmp    .Lsetup_AP
>> +
>>   .Luse_cpuid_0b:
>>       mov    $0x0B, %eax
>>       xorl    %ecx, %ecx
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 9d956571ecc1..d194c4ffeef8 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1510,6 +1510,71 @@ void __init smp_prepare_cpus_common(void)
>>       set_cpu_sibling_map(0);
>>   }
>> +
>> +/*
>> + * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
>> + * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
>> + * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
>> + * hard. And not for SEV-ES guests because they can't use CPUID that
>> + * early.
>> + */
>> +static bool __init prepare_parallel_bringup(void)
>> +{
>> +    if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1)
>> +        return false;
>> +
>> +    if (x2apic_mode) {
>> +        unsigned int eax, ebx, ecx, edx;
>> +
>> +        if (boot_cpu_data.cpuid_level < 0xb)
>> +            return false;
>> +
>> +        /*
>> +         * To support parallel bringup in x2apic mode, the AP will need
>> +         * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
>> +         * only 8 bits. Check that it is present and seems correct.
>> +         */
>> +        cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
>> +
>> +        /*
>> +         * AMD says that if executed with an umimplemented level in
>> +         * ECX, then it will return all zeroes in EAX. Intel says it
>> +         * will return zeroes in both EAX and EBX. Checking only EAX
>> +         * should be sufficient.
>> +         */
>> +        if (!eax) {
>> +            pr_info("Disabling parallel bringup because CPUID 0xb looks 
>> untrustworthy\n");
>> +            return false;
>> +        }
>> +
>> +        if (IS_ENABLED(AMD_MEM_ENCRYPT) && 
>> static_branch_unlikely(&sev_es_enable_key)) {
> 
> This should be IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)
> 
> Let me take this patch and run some tests to confirm that everything works 
> as expected.
> 
> Thanks!
> Tom
> 
>> +            pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
>> +            smpboot_control = STARTUP_APICID_SEV_ES;
>> +        } else if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
>> +            /*
>> +             * Other forms of memory encryption need to implement a way of
>> +             * finding the APs' APIC IDs that early.
>> +             */
>> +            return false;
>> +        } else {
>> +            pr_debug("Using CPUID 0xb for parallel CPU startup\n");
>> +            smpboot_control = STARTUP_APICID_CPUID_0B;
>> +        }
>> +    } else {
>> +        if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
>> +            return false;
>> +
>> +        /* Without X2APIC, what's in CPUID 0x01 should suffice. */
>> +        pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
>> +        smpboot_control = STARTUP_APICID_CPUID_01;
>> +    }
>> +
>> +    cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
>> +                  native_cpu_kick, NULL);
>> +
>> +    return true;
>> +}
>> +
>>   /*
>>    * Prepare for SMP bootup.
>>    * @max_cpus: configured maximum number of CPUs, It is a legacy parameter
>> @@ -1550,51 +1615,8 @@ void __init native_smp_prepare_cpus(unsigned int 
>> max_cpus)
>>       speculative_store_bypass_ht_init();
>> -    /*
>> -     * We can do 64-bit AP bringup in parallel if the CPU reports
>> -     * its APIC ID in CPUID (either leaf 0x0B if we need the full
>> -     * APIC ID in X2APIC mode, or leaf 0x01 if 8 bits are
>> -     * sufficient). Otherwise it's too hard. And not for SEV-ES
>> -     * guests because they can't use CPUID that early.
>> -     */
>> -    if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1 ||
>> -        (x2apic_mode && boot_cpu_data.cpuid_level < 0xb) ||
>> -        cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
>> -        do_parallel_bringup = false;
>> -
>> -    if (do_parallel_bringup && x2apic_mode) {
>> -        unsigned int eax, ebx, ecx, edx;
>> -
>> -        /*
>> -         * To support parallel bringup in x2apic mode, the AP will need
>> -         * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
>> -         * only 8 bits. Check that it is present and seems correct.
>> -         */
>> -        cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
>> -
>> -        /*
>> -         * AMD says that if executed with an umimplemented level in
>> -         * ECX, then it will return all zeroes in EAX. Intel says it
>> -         * will return zeroes in both EAX and EBX. Checking only EAX
>> -         * should be sufficient.
>> -         */
>> -        if (eax) {
>> -            pr_debug("Using CPUID 0xb for parallel CPU startup\n");
>> -            smpboot_control = STARTUP_APICID_CPUID_0B;
>> -        } else {
>> -            pr_info("Disabling parallel bringup because CPUID 0xb looks 
>> untrustworthy\n");
>> -            do_parallel_bringup = false;
>> -        }
>> -    } else if (do_parallel_bringup) {
>> -        /* Without X2APIC, what's in CPUID 0x01 should suffice. */
>> -        pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
>> -        smpboot_control = STARTUP_APICID_CPUID_01;
>> -    }
>> -
>> -    if (do_parallel_bringup) {
>> -        cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
>> -                      native_cpu_kick, NULL);
>> -    }
>> +    if (do_parallel_bringup)
>> +        do_parallel_bringup = prepare_parallel_bringup();
>>       snp_set_wakeup_secondary_cpu();
>>   }
