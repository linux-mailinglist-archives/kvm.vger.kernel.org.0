Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506BF2F1B63
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 17:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbhAKQsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:48:20 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:48612
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389009AbhAKQsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 11:48:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9NPWcTRuk2GlTg5KyciWikM1QQL7DJpnPzDM7uzGdsL2JPpRcrV1/q0qIi34ucLHC583VXzNYRMnv0eBz8eHWeDp7Edya0cWpJ2U5qh8Ik9pmBWr47pXz/70MM51/O0taKGOWUmA4N8aB278M/qlGi2IkyMla7ATZWQvV/IUZ6uSm5FwUtT96pdSDAqU5PHjcI08doHVllyYQSoLc+1qtO3jPQ4nvHV+9wRp+eOy3Q+fcmqSJfmHzWThYniphc09Us+oamoB2oBKO2NcZov+Kcc5QZYvogxG0JgvzpPW5ILOZ75H+yMzZ/e/mIMw1iCGX/6kqFIgGt1tbBOWjGTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALLRX2txRa6hlQpBBqxycLxy3GnaksqnLb0FOsQL/LE=;
 b=cowVdc58jnpuY0ZRNC95v2F2x9/YC/W0NDyOE50FkCpypkDaagRUFAzm6NZ1cIYhAKu1ewuXW39/wgI31S+J8CbTuamF21B6hd3eaeLX3+7DzcFXnz5gS/5VKli+s/cVX87taLUI1GfTvFsZ+UHQO6qJNwK3h98Kg2RgjUnyW/wZJU1mB0sXDHmcP0Rd3SMK86bG3ZUnITsYM8qS0e2yJQCBAnVefUxsqhQt7F8zi05OLifwXwgmfkNWaulvb12VoPOPczHU8E/MCqV2Ha38rWVADY7kujzmnRPRqMAFE+c7KmwgANTFxrFN+prLCB2L1JbRgiZhCYPea3HoIwH8xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALLRX2txRa6hlQpBBqxycLxy3GnaksqnLb0FOsQL/LE=;
 b=IjJbXkwt7mJD9nFkxS8Njo0l10hdM5960CJ/LxWG6Mnb55EJMAfkjdh1cLrhZiZ+lytfyi0SFXF3RzABhQC+y09fKKeHt/Sboqw59j8GSoTnS00HPlXF7mMvZOI1NKcVg/bUUa4INfZ2kzMskH/t6j4knWjspSwJylW5lc7dMu4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2359.namprd12.prod.outlook.com (2603:10b6:4:b4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 16:47:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 16:47:25 +0000
Subject: Re: [PATCH 06/13] x86/sev: Rename global "sev_enabled" flag to
 "sev_guest"
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-7-seanjc@google.com>
 <f6ed8566-6521-92f0-927e-1764d8074ce6@amd.com>
Message-ID: <5b3a5d5e-befe-8be2-bbc4-7e7a8ebbe316@amd.com>
Date:   Mon, 11 Jan 2021 10:47:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f6ed8566-6521-92f0-927e-1764d8074ce6@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0106.namprd12.prod.outlook.com
 (2603:10b6:802:21::41) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0106.namprd12.prod.outlook.com (2603:10b6:802:21::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 16:47:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 250ce3bb-5bfc-41f4-dcd2-08d8b6509310
X-MS-TrafficTypeDiagnostic: DM5PR12MB2359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2359371236A6D8BAFBAB71A9ECAB0@DM5PR12MB2359.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxUjeU//pRIM+7pDNb4eyZLDUfI4u9GGzauL8gnpTKti4ewa2Th1U0rzOStY2u+9zP34orKfyRKcKZT922vnLV9SxJbSw2ui1AM2HZaPG6sjquq8CvRcRdIx07q14+bnhycSJBQ/JOhiEpm4+gRRvCY75AXfmZF9gufn7WgLm+k0ygybyNoOxHxM7myEl1dwRHoH/WdHn1i76aFUGcDKARbimlxPhTDlvLNM0Z3jb4iKD6JN8Sl2gM12v44KnvtiPrfUte9gpakdaDR3o7egKoTWZuxLsVayL9qVv/v9FnZZwhtS4d8QkIJEukpY+zJ+irHn2ExWHEJukHvBk6DVs/p5piOjquKJphQ+ilvrRmPO9PP9TmgFiaM3vHCfEEAbgB9wS8vDMbotZYHz1dp7fen/a1hePNO1iev8mJqBmqxW0nY9aDgvDBKSs/4et9YZ2tFDmV53Xhw+0mFlPqgZ0voIPo39mp7ipnbL4Ca35AI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(2906002)(66476007)(31696002)(7416002)(66946007)(66556008)(4326008)(186003)(16526019)(52116002)(83380400001)(6486002)(6506007)(5660300002)(6512007)(110136005)(2616005)(26005)(54906003)(8676002)(316002)(31686004)(956004)(53546011)(36756003)(86362001)(478600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDE0bnkzaXREdjJsQzNnQmJ1Z0xCYVpMUnR0ZnVUdHVpVXh5WFBQbzdpWjlC?=
 =?utf-8?B?VDFISWZiZHNFbThPVjdwdEJ6U0FBdmltMkQwZ0lRZGZFSVZNckFRNUd6UlJr?=
 =?utf-8?B?bmRrZVBLZFNxTEFVZkxHQVJsK2RjNFc1ckRGWDVWS2VmMCs5Rkk2WnNjT2VE?=
 =?utf-8?B?VVNMWWtTZ3F1Zlg3TnNHcm4xK2pNMStGUXlhaHJQT0pXOXdKM2RWTkZIanMz?=
 =?utf-8?B?NDNFcHMyRVJSczVwWVoyVDQ5cW5Ia0VyZ29zVVEwUzBmSVlFbVFOc0xBb0lC?=
 =?utf-8?B?Z2Rqb2JRV1BHVFRvV2NiUEg1eWtDWG5TaVpwdDBZSDJTN0NQSVc5d0hoUW1O?=
 =?utf-8?B?V2oxMEdrcGRiS0liTEhwY2ovRzV6enBPVUhxTTNwME9oVWdXcU44K1RObm1N?=
 =?utf-8?B?ZGpkckV2QU1xVHFEczFqRk12ZUo2bjNTZVVKOWRjYWp0T0o2cDlIWGhIVjI0?=
 =?utf-8?B?VDk2MEFWeEpDOFdiZTRkT3hLQnRGK2hsYzVhcElYTjd4cFhNZjQzV2F4UHFq?=
 =?utf-8?B?NnhsWWlHUmI4SUlUWjVlOVpkblFzak5MS2lpbyswQ2FKbEdRUFFScHVjRitx?=
 =?utf-8?B?Y0xpOCttYWlQbm0vYnRqUklIYmFac2xaVC82eVpvRi94aVU2T3N0cWIwRmpa?=
 =?utf-8?B?UWxPTXErMi9IdENydldQa2t3aWJna0JrczQwbnhHMkplcHNuZmIyU1hGUUI2?=
 =?utf-8?B?R1NyNndQOHVEQTBPRzNQcUNuVTdLTGZ3YjR6U2NsMVVWYzcxZ2RnYWI4enJS?=
 =?utf-8?B?QnR3R1lCZGJzRmF5ZlU4SDN3bmZIMlFXRTJ5OFZSMGcyenh6aStNb2NDVzll?=
 =?utf-8?B?Q3lIcVRpMFRpckUwZVQxbFdlWEZYTnBacVJxRzZxQXl1MHhNZElrdVdDQUFn?=
 =?utf-8?B?SUdVTEkwUElFUFJaQ0toTjZyNm95L2RYd0puNXRaZUJBVHBLb09aRldnNVdX?=
 =?utf-8?B?QkdMa3FOL2FSSnBsY2RRSkJMcGtWT0lybkxrVm5Pb0E3czVlaWE4ckJvbnhY?=
 =?utf-8?B?N0prZFAyYXk2d0s4eXl1WFl6OEtTNHNYTWJTSWQyUUVmMzg2ZjhrcG5sdW1i?=
 =?utf-8?B?QVQ0enJqV0V2cGp3RmxTeWYzWDJSdnFPcWI4dE9kMlNWUFNFNDBtYkJEdDVP?=
 =?utf-8?B?aDhHT1pBaThRUFRmeVFXRnV2cldxWEx3dEdWRTdsY21SYXE5ajdEdTZKRjJF?=
 =?utf-8?B?bXhBd05iVzh6SVNsUWloVzZjU1pSb1lwYlNxZWgzbVZyb0tMeWt3dStoSHlB?=
 =?utf-8?B?TmpFcGFld1A3ekFNTDUwd3dOQlJYVUh2ZitRSjdjVE95SjlkVEhDY04vaWtT?=
 =?utf-8?Q?xiZ1MDqc3q+L+C6PJUmvoOlKlnp6bQf7AG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 16:47:25.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 250ce3bb-5bfc-41f4-dcd2-08d8b6509310
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onEQXH0SL+44Ck8cXXdXUEV93cDhM19XmHU/EpXFcQfu+d+W1ukCInSp1R8E3gWwcXiKOSHy+n1/d2BWRHtMpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2359
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/21 10:02 AM, Tom Lendacky wrote:
> On 1/8/21 6:47 PM, Sean Christopherson wrote:
>> Use "guest" instead of "enabled" for the global "running as an SEV guest"
>> flag to avoid confusion over whether "sev_enabled" refers to the guest or
>> the host.  This will also allow KVM to usurp "sev_enabled" for its own
>> purposes.
>>
>> No functional change intended.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Ah, I tried building with CONFIG_KVM=y and CONFIG_KVM_AMD=y and got a 
build error:

In file included from arch/x86/kvm/svm/svm.c:43:
arch/x86/kvm/svm/svm.h:222:20: error: ‘sev_guest’ redeclared as different 
kind of symbol
   222 | static inline bool sev_guest(struct kvm *kvm)
       |                    ^~~~~~~~~
In file included from ./include/linux/mem_encrypt.h:17,
                  from ./arch/x86/include/asm/page_types.h:7,
                  from ./arch/x86/include/asm/page.h:9,
                  from ./arch/x86/include/asm/thread_info.h:12,
                  from ./include/linux/thread_info.h:38,
                  from ./arch/x86/include/asm/preempt.h:7,
                  from ./include/linux/preempt.h:78,
                  from ./include/linux/percpu.h:6,
                  from ./include/linux/context_tracking_state.h:5,
                  from ./include/linux/hardirq.h:5,
                  from ./include/linux/kvm_host.h:7,
                  from arch/x86/kvm/svm/svm.c:3:
./arch/x86/include/asm/mem_encrypt.h:23:13: note: previous declaration of 
‘sev_guest’ was here
    23 | extern bool sev_guest;
       |             ^~~~~~~~~

Thanks,
Tom

> 
>> ---
>>   arch/x86/include/asm/mem_encrypt.h | 2 +-
>>   arch/x86/mm/mem_encrypt.c          | 4 ++--
>>   arch/x86/mm/mem_encrypt_identity.c | 2 +-
>>   3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/mem_encrypt.h 
>> b/arch/x86/include/asm/mem_encrypt.h
>> index 2f62bbdd9d12..9b3990928674 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -20,7 +20,7 @@
>>   extern u64 sme_me_mask;
>>   extern u64 sev_status;
>> -extern bool sev_enabled;
>> +extern bool sev_guest;
>>   void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>>                unsigned long decrypted_kernel_vaddr,
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index bc0833713be9..0f798355de03 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -44,7 +44,7 @@ EXPORT_SYMBOL(sme_me_mask);
>>   DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>>   EXPORT_SYMBOL_GPL(sev_enable_key);
>> -bool sev_enabled __section(".data");
>> +bool sev_guest __section(".data");
>>   /* Buffer used for early in-place encryption by BSP, no locking needed */
>>   static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>> @@ -344,7 +344,7 @@ int __init early_set_memory_encrypted(unsigned long 
>> vaddr, unsigned long size)
>>    */
>>   bool sme_active(void)
>>   {
>> -    return sme_me_mask && !sev_enabled;
>> +    return sme_me_mask && !sev_guest;
>>   }
>>   bool sev_active(void)
>> diff --git a/arch/x86/mm/mem_encrypt_identity.c 
>> b/arch/x86/mm/mem_encrypt_identity.c
>> index 6c5eb6f3f14f..91b6b899c02b 100644
>> --- a/arch/x86/mm/mem_encrypt_identity.c
>> +++ b/arch/x86/mm/mem_encrypt_identity.c
>> @@ -545,7 +545,7 @@ void __init sme_enable(struct boot_params *bp)
>>           /* SEV state cannot be controlled by a command line option */
>>           sme_me_mask = me_mask;
>> -        sev_enabled = true;
>> +        sev_guest = true;
>>           physical_mask &= ~sme_me_mask;
>>           return;
>>       }
>>
