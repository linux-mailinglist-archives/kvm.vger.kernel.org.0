Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6FC4D384D
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 19:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiCIRs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiCIRs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:48:58 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA63B250C;
        Wed,  9 Mar 2022 09:47:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgdoKz43TfzhmalaIcJj1I65Rmj42cq0vIiwI0LNtcnbLltOnF+xYZLh4ig/NBvsKSyWbDSjQ8ofIkwlZVzPmgIWJ/ssEowE/sWwtT5fcgb8uIGUqLmBbOtGG6AZHQYHuVHBqC0zwgereRGHMcjE/t2ObiWL8U11INNyc0W5QNeEIeR7/EtVdgGjoJDXNCMfg93Ni+eaKl8VTTIeYaYOemoj8CIIGwTIWR+t2YrKVItweq3ol9+YY8ZmTk2gLoyWMKBY1MuDlwmw4tRRtXdnwh54XlGKMugyMeXM6Xpseq7nQsBT6u/62C1aJep+UkHt/bBZAyWrVT+sG+VzzlEcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTSXC5WE0NTlP6WrV4vN8weCNQDDw82i5bJp6/vNRAc=;
 b=DUOAU1/LM/lCCUJazvBM1HI4yrLpVsqKKLcVErlz5r+8nQLi221c9yJlfW/vNTj83MkJLAQENKOxAmlEUWCkpEpIzaXlewtsykfPrPaethUcC1z/oRVJTBQqgeEJmAHv3O037fgECoRcxTBdQxVc7JCmoTkD3SbNudlbJpAIpCmOAgx07uSn+lLLqTBnQNP1KKmBJd7DFerj0V7HCR1upzNRiO80ubw5wJ9lovVfRDbE1dVk/YF8VT0EU+xVQ5lIm9R7PnJrvomvTAk/X5wBaqBSYGqbg3OmiqVksNEycFiEN6c8q0XxXyM7vVy8jAGXEpPy+SSwYzb+qOmBKDQZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTSXC5WE0NTlP6WrV4vN8weCNQDDw82i5bJp6/vNRAc=;
 b=YKdsA7TVBmk2z6bbjq3FX/9NubDE8PeeRV2AE54WbAFrBGlvFdZZCMlMq+TlIFPqbjWWADvqzK8VxLVNz4o34Ek609qyJB/EfZ/9/0qS83UeWthXTnY1XMuxanNqcigWEjUysVT4wK+t6VK8X11YxzDBfsBJdft824+oRrITgPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21)
 by MWHPR12MB1503.namprd12.prod.outlook.com (2603:10b6:301:b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Wed, 9 Mar
 2022 17:47:55 +0000
Received: from SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::5d1f:4060:d060:62df]) by SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::5d1f:4060:d060:62df%3]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:47:55 +0000
Message-ID: <952b68c0-6316-f8fe-16a6-80b85f4d9744@amd.com>
Date:   Wed, 9 Mar 2022 23:17:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC v1 9/9] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-10-nikunj@amd.com>
 <421f4fba-3e1c-b676-d74c-02c6c3f804d2@maciej.szmigiero.name>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <421f4fba-3e1c-b676-d74c-02c6c3f804d2@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR0101CA0026.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::12) To SN1PR12MB2477.namprd12.prod.outlook.com
 (2603:10b6:802:28::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 049f7778-4555-4993-5a3d-08da01f4f073
X-MS-TrafficTypeDiagnostic: MWHPR12MB1503:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB150397B71E6B43ACA5A7E937E20A9@MWHPR12MB1503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ck+ayFKUBmxuxP1OoHICLCmh66Maikfp+Kz1UPI3kTZzsHHrfeMxG5ziJyfaZvsCpkhowgytU/I+4rQx/U5riRd3weeHCeWD+/0MwjkE+9D6QZBKgWQzq1edjQ9mEC+gNP6Jl8FOghfmRTLN47WdpAKqfPoic7vQvR9urpW/Byj7nDG2sdyD3CyavwtQoCgCgCeQO1OqNkLeQA9RdzF7M4OqqA7O6b26OHcF292g1DyHPSZutnkll//zNP2rP0P0yAFoh4TcrT1gas3aBONkv8AvmQVgLxu9SfKtiQ6Eo6FwZbXwhHfiDHgaYbylDpajzmS+5L4bHUX99850dlfN1aL1XlOaztYS/W426NUtY4liern9GFvWeDGp0JAS+n9VXAKI+iVcnvk2x4MgIUEpTFVcNF3qBA2vZh9suc1erjZqA/WFZMSA83/9+9ziPBVUEeW5CGKPQShY23xn1pum2vX3QLl/HGAu3tT86m3l8NyVYBUrDOhNtRA8u/xmu5BQv6ivpjtZ9JQXoBJIPDU4n0pm1CIiZfsh+NsdI/zS/iDIt3e/mWL+qkFoWr3D1+PUnjNeqpizFNDpdmhvsZRC8H+76+mzh33y06BjiniaqP1ZVe2C3QWRiO4i8sUkfr0lpQjKp3kbT6L9fzutRGH8L6ZEYc5+4X6bYH3l+Oz/8pi3a86tsySfhg9/gAYRGw+np7qZYh3mwFxR1wLTqrw/t6yIdK4Y5uJejH+xdddMxFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2477.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(6486002)(186003)(26005)(53546011)(83380400001)(2616005)(36756003)(2906002)(31686004)(6506007)(508600001)(54906003)(6916009)(38100700002)(5660300002)(7416002)(8936002)(31696002)(316002)(66476007)(4326008)(8676002)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmpNc1QxRE9nQjF1bWlBaU9lNWF4em9Fd1R2TlVjMG4rVHVSWGF5UlhrSVVv?=
 =?utf-8?B?c2Mrekx6Q3ZVdFlzUkx0azFyU2dud0VBZVZwSmhYY1RNSm1LRFVqanFFcFRL?=
 =?utf-8?B?QkovNGcrRGRKL3BWNnFDSW1SaWtlSkJxYVJzNGRLQ3NJY1dNK0t3WWJOaFFB?=
 =?utf-8?B?N0plRlFjMGJoS2xaQ2wvZXl5Y2dxM1JGYk1ZN3R4U0RjWjBDUlhjWmhBRUFZ?=
 =?utf-8?B?MnpFS2R4dEJ0SkxwczI1WFIwcDY3MGhIdWtrblRQaUtTcUZ3ODN5VkFyaDhY?=
 =?utf-8?B?bFpsenJ4dFNrczlHWUxFTDV5dUQ4Tkd0T1pIVmdacUs5ekx2c1YxVWtjM2NZ?=
 =?utf-8?B?LzU5VXA0bVc0T0EyVGVkQ0swQjkwUEdOZWI0MmJrNTdFNG9VQ0J4WjdtMW1J?=
 =?utf-8?B?Y1MyKzlRNmNVMUZheFRGQkZOenlYR1o3UlhaWmMwNlk4VHFtdjFXU0dGdm51?=
 =?utf-8?B?ZEJUY1MrcnJkbXNYSys1eFF5LzJpZXRVcmR5L0w2RmFPLzdRM0VhOGU2cHdN?=
 =?utf-8?B?VzhXWmIySUVQRG5ZWWdKOUdJYi9QbHdMbFJLeEdXekVZTkJmUGx4a3ZxQ242?=
 =?utf-8?B?ZElJa2t1cmJuYVNmNEZBSXpTaGJtcDlXNFJmbE5LRTYrWlFiWjVyU0M3N3hR?=
 =?utf-8?B?QkVJbFRMWDNOcDBpVjA1eCt4dGFTK2Vid1FvMS9ReDZHZXI3UnlGOFR2M0Iv?=
 =?utf-8?B?MERlVHBOb21paTdnNlczZDlFUTk3VVowLzIzK2FQbWpTQ2dodUVJV2V3SXpw?=
 =?utf-8?B?ZnlCSWJKQ29CUTlYdTI3NkphcUlHUEpGN3JtK1pSeUMxeWF5dnB2d2NjVjg0?=
 =?utf-8?B?WjBDbHFlV2ltUkNqUnYyUFNhZ0o2MmFWbXVadTZTc1dGR2twRE1obHU0bnJ5?=
 =?utf-8?B?anIyakNkRWR3ZnpicGdiZk1zSThkS2luR2dRbWg2L1hFS2t4M0lhWDdQRmhx?=
 =?utf-8?B?c0RERXJRaVZySW9EVVdiZjRlRURoWUZYZVg1eW4xZ0YvRXljdjZjY2g1ZzRE?=
 =?utf-8?B?Smp6dldTUldsWWNjdWpZWmIxVzBIK1lmQTR5SEV3dkk1S2JVN2UyWkQzWHll?=
 =?utf-8?B?azd0SW1aY1JIa2ZKSy9sczE5VHpJNzZwbmFFQXUrc2J4T0VleDlUcjl4eHJo?=
 =?utf-8?B?a3EvT1pZZSs0NEU0Uy9DeDMxNHJrL3RPcTNvb1JrNXM3R2dhUW1DQXVuclph?=
 =?utf-8?B?ZitESE85dHI0bENMVkdnZGxZdTJ3TjYrajhacFdzdnVpMUw2MHpxRmsrVnFB?=
 =?utf-8?B?dFNQbXZwUzFIZ2haMjJlS2krZTNCbE9KZUdCeHdMVHpybUVDaEtjblpiKzhn?=
 =?utf-8?B?czcvNklTa1NxejZlc0RIdTRhR2ltMDVzWmpiaHBobFlySnQ4YUlMYW05MEtv?=
 =?utf-8?B?SXQ3cU1mUTN3ajZod0ZXOTIwOFFuME5uRHg5NUVMdW16Z3BxMjZacjUzVlhJ?=
 =?utf-8?B?czF2dHBEaFNKUmt0UHpPWnR3QmN1K3M3MHhvMEtpL3FEWERLMzZ3ZGlIbEln?=
 =?utf-8?B?RlU1aVFNVitTWXp1TEdEb2RVbHZObm5lOXB2WTN1RkZjMCs5QUZCSnpFaDA2?=
 =?utf-8?B?Rnd5Z0RMVHNQbXIxeWJTalIwclljZ0Z1aEpQQVQ4ckw0ZGpTRTRlcndVa0Jx?=
 =?utf-8?B?WHVGU2d2Sm1lOHM4LzhRVHZBMGVOK0hNbGFiaVZNN1FNRG5tampUL0RUcWJG?=
 =?utf-8?B?cFlOR0xhUnRoTEd6VFl2YzlkSlpPeXZMbk9zRXpacnhPeTRYZ1NvOUtNZXIv?=
 =?utf-8?B?ckVDaDJsREhlMmp6WTNHRklpWTFRQnVwWDR2ZU1DSTdHUXdnMXhzSGV6bVZZ?=
 =?utf-8?B?bkxROVB6UDJCVk5BajdsL0c2RnFBbkNEWSthVHRoNzhycVBTVEhHMnFlYTFS?=
 =?utf-8?B?bTNKZ1Z6WHRnNGRDVThGVC9VYjBjS3RNKy9FcGFxVmgwWTcrQVNrWHlEcVFJ?=
 =?utf-8?B?Y3dUZmcvaXNzRWl5dVprU1cvcy8vRTh6OG1qUHd0UEhBQU45RVc1RGhyZE4x?=
 =?utf-8?B?aE9lUTFTZ3VyTC85c01kREZUd0VYQzlCYjdMaXB2a3J1dTJWQmtzcDNrOS9J?=
 =?utf-8?B?NDFqemlPbGxBalNIVnF6S1NXT29CS2xIc1FmR0ZiTVNVcTc0VFlUREoxcmpi?=
 =?utf-8?B?UUxmRU1hZHFTSWdXeExDOTJ2SG9Wa0VjWTVEdFovREQxL3A0NDB1RVRJMWI2?=
 =?utf-8?Q?JHIxeN1bix04uaykjaFtyR4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049f7778-4555-4993-5a3d-08da01f4f073
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2477.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:47:54.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBz79trXDE0icK85abkWqtVlmJsSc7gpTcLKMO3YZ3DG9tt4AlU3BK3nSjKKqJIFmKEtui1fWUVh28LSQM4k5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1503
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/2022 10:27 PM, Maciej S. Szmigiero wrote:
> On 8.03.2022 05:38, Nikunj A Dadhania wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Pin the memory for the data being passed to launch_update_data()
>> because it gets encrypted before the guest is first run and must
>> not be moved which would corrupt it.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> [ * Use kvm_for_each_memslot_in_hva_range() to find slot and iterate
>>    * Updated sev_pin_memory_in_mmu() error handling.
>>    * As pinning/unpining pages is handled within MMU, removed
>>      {get,put}_user(). ]
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 146 +++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 134 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7e39320fc65d..1c371268934b 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>>   +#include "mmu.h"
>>   #include "x86.h"
>>   #include "svm.h"
>>   #include "svm_ops.h"
>> @@ -428,9 +429,93 @@ static void *sev_alloc_pages(struct kvm_sev_info *sev, unsigned long uaddr,
>>       return pages;
>>   }
>>   +#define SEV_PFERR_RO (PFERR_USER_MASK)
>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>> +
>> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
>> +                       unsigned long size,
>> +                       unsigned long *npages)
>> +{
>> +    unsigned long hva_start, hva_end, uaddr, end, slot_start, slot_end;
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct interval_tree_node *node;
>> +    struct kvm_memory_slot *slot;
>> +    struct kvm_memslots *slots;
>> +    int idx, ret = 0, i = 0;
>> +    struct kvm_vcpu *vcpu;
>> +    struct page **pages;
>> +    kvm_pfn_t pfn;
>> +    u32 err_code;
>> +    gfn_t gfn;
>> +
>> +    pages = sev_alloc_pages(sev, addr, size, npages);
>> +    if (IS_ERR(pages))
>> +        return pages;
>> +
>> +    vcpu = kvm_get_vcpu(kvm, 0);
>> +    if (mutex_lock_killable(&vcpu->mutex)) {
>> +        kvfree(pages);
>> +        return ERR_PTR(-EINTR);
>> +    }
>> +
>> +    vcpu_load(vcpu);
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +
>> +    kvm_mmu_load(vcpu);
>> +
>> +    end = addr + (*npages << PAGE_SHIFT);
>> +    slots = kvm_memslots(kvm);
>> +
>> +    kvm_for_each_memslot_in_hva_range(node, slots, addr, end) {
>> +        slot = container_of(node, struct kvm_memory_slot,
>> +                    hva_node[slots->node_idx]);
>> +        slot_start = slot->userspace_addr;
>> +        slot_end = slot_start + (slot->npages << PAGE_SHIFT);
>> +        hva_start = max(addr, slot_start);
>> +        hva_end = min(end, slot_end);
>> +
>> +        err_code = (slot->flags & KVM_MEM_READONLY) ?
>> +            SEV_PFERR_RO : SEV_PFERR_RW;
>> +
>> +        for (uaddr = hva_start; uaddr < hva_end; uaddr += PAGE_SIZE) {
>> +            if (signal_pending(current)) {
>> +                ret = -ERESTARTSYS;
>> +                break;
>> +            }
>> +
>> +            if (need_resched())
>> +                cond_resched();
>> +
>> +            /*
>> +             * Fault in the page and sev_pin_page() will handle the
>> +             * pinning
>> +             */
>> +            gfn = hva_to_gfn_memslot(uaddr, slot);
>> +            pfn = kvm_mmu_map_tdp_page(vcpu, gfn_to_gpa(gfn),
>> +                           err_code, PG_LEVEL_4K);
>> +            if (is_error_noslot_pfn(pfn)) {
>> +                ret = -EFAULT;
>> +                break;
>> +            }
>> +            pages[i++] = pfn_to_page(pfn);
>> +        }
>> +    }
> 
> This algorithm looks much better than the previews one - thanks!

Thanks for your feedback earlier. 

> By the way, as far as I know, there could be duplicates in the "page" array
> above since the same hva can be mapped to multiple gfns (in different memslots).
> Is the code prepared to deal with this possibility?

Yes, as the pinning is done with pfn as index, it can get pinned multiple times. During 
memslot destroy path they would get unpinned.

Regards
Nikunj 
