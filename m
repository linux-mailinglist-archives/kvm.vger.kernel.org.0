Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6B3E516E
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 05:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhHJDW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 23:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbhHJDW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 23:22:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2891BC0613D3;
        Mon,  9 Aug 2021 20:22:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so3253006pjb.3;
        Mon, 09 Aug 2021 20:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fpAQ85toVv8Dv3of/inO66JEQ6cmQUeELsu6eu6hedA=;
        b=BAoJ9Xava6/MAoixg0T0JTdAqgUHmyQuO/cM9DMNcRoJ8GTGafBLn0LIC3xV3NI3dg
         6WbDyVKVQhTXg6YKbyiVLuUuC99JRo6veebwu/lvN/dG7mDfk0I/wn6Ef1e25BWTvYWQ
         rhT+8uwh1lPP8QGHTeugdn4EUNPnsajAwd9oxDBNZGl9HfJWOkCGgIQzz0iJKVcFKjDx
         SucPGgfbXoWaNTcWcg3jywsi7SjHT58Ei7eKGDxzfOb1ghiDc7ap33HGYFEDxDS6NXJQ
         mgnUTiy/JqrwKr+KDRO2N8yO/fM7afNv/0XHY/ug0+Z3ZMote6Y7hhhyU75oINAHGvos
         Wk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fpAQ85toVv8Dv3of/inO66JEQ6cmQUeELsu6eu6hedA=;
        b=fElSYVcA7/T8BY/QbXasw7wYISmqF9NX6XeohLnHtXYNT/jj306aHKAWHHUgOqsBsQ
         uu3qa6iDh6aQ+KAUia6KUV3DGIb9PQkiQqjDuaPRVy7Co0r9nKjRvWdPb2gFWNbNs7WB
         b/LIogmusQVjQ7OOOKdFW/GLhUK9ycejy1Trnxm7otV0w/ecL0WM9uaRteHkU8PnDOzk
         SCdVtgWsG3Cn2I4Qe2Ln5HRbJwYR4+dCsoQloJOwArpXWzcwK/9N45DKRTfnSFqq/vWO
         zXzKl3Fx7VRRH+l1DPjXIc8+pMVcQGxaZgw96s2AApP1oAgnDBF8G+7LvUeqaLM3YH4G
         PefQ==
X-Gm-Message-State: AOAM530CQvr4PKJoZHM+YOeGQfnOB60YjnoctYkUIMVnpPLjP2xiYd4F
        +t0RjJGU1f58z874QmbaxaBIILcaQQXdvKyq4vI=
X-Google-Smtp-Source: ABdhPJzv2zMnwTQ01WcOML45Ef0kbcqQIROl0WFXDTRirJYBZAzP/2xKWNK+MYC5qdwZPYyPcpNFTQ==
X-Received: by 2002:a17:902:7b93:b029:12b:a0a5:78d2 with SMTP id w19-20020a1709027b93b029012ba0a578d2mr23237440pll.51.1628565724607;
        Mon, 09 Aug 2021 20:22:04 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a11sm25870385pgj.75.2021.08.09.20.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 20:22:04 -0700 (PDT)
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210809074803.43154-1-likexu@tencent.com>
 <7599a987-c931-20f1-9441-d86222a4519d@linux.intel.com>
 <CAA3+yLfF8a5Jwz6s3ZG6zMgRn7GEF5Q8ENucuu3Ne977MmVUug@mail.gmail.com>
 <9a7def9e-8609-e442-524a-d8439b1432d1@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [NAK][PATCH] KVM: x86/pmu: Don't expose guest LBR if the
 LBR_SELECT is shared per physical core
Message-ID: <7e1f2dd5-d8a3-3e63-bedc-e2f1b2ae10d4@gmail.com>
Date:   Tue, 10 Aug 2021 11:21:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9a7def9e-8609-e442-524a-d8439b1432d1@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you, Kan.

On 10/8/2021 2:03 am, Liang, Kan wrote:
> 
> 
> On 8/9/2021 11:08 AM, Like Xu wrote:
>> On Mon, Aug 9, 2021 at 10:12 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>
>>>
>>>
>>> On 8/9/2021 3:48 AM, Like Xu wrote:
>>>> From: Like Xu <likexu@tencent.com>
>>>>
>>>> According to Intel SDM, the Last Branch Record Filtering Select Register
>>>> (R/W) is defined as shared per physical core rather than per logical core
>>>> on some older Intel platforms: Silvermont, Airmont, Goldmont and Nehalem.
>>>>
>>>> To avoid LBR attacks or accidental data leakage, on these specific
>>>> platforms, KVM should not expose guest LBR capability even if HT is
>>>> disabled on the host, considering that the HT state can be dynamically
>>>> changed, yet the KVM capabilities are initialized at module initialisation.
>>>>
>>>> Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the 
>>>> MSR_IA32_PERF_CAPABILITIES")
>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>> ---
>>>>    arch/x86/include/asm/intel-family.h |  1 +
>>>>    arch/x86/kvm/vmx/capabilities.h     | 19 ++++++++++++++++++-
>>>>    2 files changed, 19 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/intel-family.h 
>>>> b/arch/x86/include/asm/intel-family.h
>>>> index 27158436f322..f35c915566e3 100644
>>>> --- a/arch/x86/include/asm/intel-family.h
>>>> +++ b/arch/x86/include/asm/intel-family.h
>>>> @@ -119,6 +119,7 @@
>>>>
>>>>    #define INTEL_FAM6_ATOM_SILVERMONT  0x37 /* Bay Trail, Valleyview */
>>>>    #define INTEL_FAM6_ATOM_SILVERMONT_D        0x4D /* Avaton, Rangely */
>>>> +#define INTEL_FAM6_ATOM_SILVERMONT_X3        0x5D /* X3-C3000 based on 
>>>> Silvermont */
>>>
>>>
>>> Please submit a separate patch if you want to add a new CPU ID. Also,
>>> the comments should be platform code name, not the model.
>>>
>>> AFAIK, Atom X3 should be SoFIA which is for mobile phone. It's an old
>>> product. I don't think I enabled it in perf. I have no idea why you want
>>> to add it here for KVM. If you have a product and want to enable it, I
>>> guess you may want to enable it for perf first.
>>
>> Thanks for your clarification about SoFIA. I'll drop 0x5D check
>> for V2 since we doesn't have host support as you said.
>>
>> Do the other models here and the idea of banning guest LBR make sense to you ?
>>
> 
> For the Atom after Silvermont, I don't think hyper-threading is supported. 
> That's why it's per physical core. I don't think we should disable LBR because 
> of it.

In addition to your clarification below, it makes sense to keep it as it is.

> 
> For Nehalem, it seems possible that the MSR_LBR_SELECT can be overridden if the 
> other logical core has a different configure. But I'm not sure whether it brings 
> any severe problems. Logical core A may miss some LBRs or get extra LBRs, but I 
> don't think LBRs can be leaked to Logical core B. Also, Nehalem is a 13+ year 
> old machine. Not sure how many people still use it.

Allowing one guest to prevent another guest from using the LBR (writing zero
consistently) is quite a serious flaw, but considering that only such an old model
is affected, adding a maintenance burden to KVM here is not a good choice.

> 
> LBR format 0 is also a valid format version, LBR_FORMAT_32. It seems this patch 
> just forces the format to LBR_FORMAT_32 for these machines. It doesn't sound 
> correct.

Sigh, I assume that the platform reporting LBR_FORMAT_32 is older than Nehalem.

> 
> Thanks,
> Kan
>>>
>>>>    #define INTEL_FAM6_ATOM_SILVERMONT_MID      0x4A /* Merriefield */
>>>>
>>>>    #define INTEL_FAM6_ATOM_AIRMONT             0x4C /* Cherry Trail, 
>>>> Braswell */
>>>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>>>> index 4705ad55abb5..ff9596d7112d 100644
>>>> --- a/arch/x86/kvm/vmx/capabilities.h
>>>> +++ b/arch/x86/kvm/vmx/capabilities.h
>>>> @@ -3,6 +3,7 @@
>>>>    #define __KVM_X86_VMX_CAPS_H
>>>>
>>>>    #include <asm/vmx.h>
>>>> +#include <asm/cpu_device_id.h>
>>>>
>>>>    #include "lapic.h"
>>>>
>>>> @@ -376,6 +377,21 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>>>        return pt_mode == PT_MODE_HOST_GUEST;
>>>>    }
>>>>
>>>> +static const struct x86_cpu_id lbr_select_shared_cpu[] = {
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_X3, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_G, NULL),
>>>> +     X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX, NULL),
>>>> +     {}
>>>> +};
>>>> +
>>>>    static inline u64 vmx_get_perf_capabilities(void)
>>>>    {
>>>>        u64 perf_cap = 0;
>>>> @@ -383,7 +399,8 @@ static inline u64 vmx_get_perf_capabilities(void)
>>>>        if (boot_cpu_has(X86_FEATURE_PDCM))
>>>>                rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>>>>
>>>> -     perf_cap &= PMU_CAP_LBR_FMT;
>>>> +     if (!x86_match_cpu(lbr_select_shared_cpu))
>>>> +             perf_cap &= PMU_CAP_LBR_FMT;
>>>>
>>>>        /*
>>>>         * Since counters are virtualized, KVM would support full
>>>>
> 
