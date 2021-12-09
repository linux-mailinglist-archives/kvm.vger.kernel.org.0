Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12C546E8A4
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 13:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhLIMx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 07:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLIMx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 07:53:56 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AB6C061746;
        Thu,  9 Dec 2021 04:50:23 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z6so3805651plk.6;
        Thu, 09 Dec 2021 04:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=HJT4r7EpD7hUntvUb8lemLdBO90PB0xUen0XDv9KS5I=;
        b=OnWALz1YpPvhKkgimLeXB0CmATh5b98HNQXlO8W7+ppRzrSqNcaWk5yVv0ETUKxe+e
         tFdBZ4QE2PDYkxG+jtQz2feN+XaRk/NnCT+Rptmy1IL5owEYAz3R/ivg5oxYboASy9wz
         wuaYlzyrOZOYCGCH9vn5uB1D4vMaYiMyqxAYDwxtFHQ8hIJTel14BcjoYq46IHvc8LOQ
         uuFSdhw7aBK0MnyMFbqrDhDGV3FJotpYRcJdJgB9RiYhactltKtZ4PLMd0AVwTQx40hL
         9RjpiQJHwfdVJ7/8I0Ld80hTxaDc44+izuGIu2GZL/zGGG0DeEfs28phyprWUK2hFnwF
         q59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=HJT4r7EpD7hUntvUb8lemLdBO90PB0xUen0XDv9KS5I=;
        b=gtPfZejiBifYuH9N4cRg3yuwDJUdQct4rNPZMX6NR2EUOf+27Hm7AajxzJ2fVjQ+ss
         /luN2TeTtKQUSHYizPh1vC0fzWJpMFjqywjo4Eh8mipT3evzU5DwDOtsGRsnIzsQ5HGN
         xKT2NaMkDsfdYe0PyuBaM7hwrrXdJb7kmuu3daiTZMpOArH47/cZIXE2q2bllf0CU0mb
         1d9semSJCwd7yHiHlaVHDfWqhbrey/QMarSGmrbq6MSwaxyO9O6YwpFXkB5yI5s4U3Jb
         aPCW1lbDjD07QwkOkIQjFkd2VFoBRKvZc9iZ5HZM1EpQImyBm4/v7NMv35AF7tFy6qI6
         +O2Q==
X-Gm-Message-State: AOAM531kXK5j0Ow50PlWrsX5QKGWWkvapgvi9zVMyKCwsyMlD/Uy4+Nc
        hJFcr7gWsfDLZxNqDsXIidU=
X-Google-Smtp-Source: ABdhPJwgzCzHv6Zi9x2WGTe84DR51VbL0/TWZ0wfIxZhRwLDdSElJmLu7ffC2rxDr+Bjeca7/7SSBw==
X-Received: by 2002:a17:90b:17cf:: with SMTP id me15mr15142932pjb.125.1639054222806;
        Thu, 09 Dec 2021 04:50:22 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n16sm6069096pja.46.2021.12.09.04.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 04:50:22 -0800 (PST)
Message-ID: <bfaac3e8-71a0-1e4a-0ff7-b25add6917d5@gmail.com>
Date:   Thu, 9 Dec 2021 20:50:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v2 6/7] KVM: x86: Introduce definitions to support static
 calls for kvm_pmu_ops
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20211108111032.24457-1-likexu@tencent.com>
 <20211108111032.24457-7-likexu@tencent.com> <YbD691K7B9VVbswI@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YbD691K7B9VVbswI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 9/12/2021 2:35 am, Sean Christopherson wrote:
> On Mon, Nov 08, 2021, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Use static calls to improve kvm_pmu_ops performance. Introduce the
>> definitions that will be used by a subsequent patch to actualize the
>> savings. Add a new kvm-x86-pmu-ops.h header that can be used for the
>> definition of static calls. This header is also intended to be
>> used to simplify the defition of amd_pmu_ops and intel_pmu_ops.
>>
>> Like what we did for kvm_x86_ops, 'pmu_ops' can be covered by
>> static calls in a simlilar manner for insignificant but not
>> negligible performance impact, especially on older models.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
> 
> This absolutely shouldn't be separated from patch 7/7.  By _defining_ the static
> calls but not providing the logic to actually _update_ the calls, it's entirely
> possible to add static_call() invocations that will compile cleanly without any
> chance of doing the right thing at runtime.
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 0236c1a953d0..804f98b5552e 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -99,7 +99,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
> 
>   static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>   {
> -       return kvm_pmu_ops.pmc_is_enabled(pmc);
> +       return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
>   }
> 
>   static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
> 
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_NULL)
>> +BUILD_BUG_ON(1)
>> +#endif
>> +
>> +/*
>> + * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_NULL() are used to
> 
> Please use all 80 chars.
> 
>> + * help generate "static_call()"s. They are also intended for use when defining
>> + * the amd/intel KVM_X86_PMU_OPs. KVM_X86_PMU_OP() can be used
> 
> AMD/Intel since this is referring to the vendor and not to function names (like
> the below reference).
> 
>> + * for those functions that follow the [amd|intel]_func_name convention.
>> + * KVM_X86_PMU_OP_NULL() can leave a NULL definition for the
> 
> As below, please drop the _NULL() variant.
> 
>> + * case where there is no definition or a function name that
>> + * doesn't match the typical naming convention is supplied.
>> + */
> 
> ...
> 
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 353989bf0102..bfdd9f2bc0fa 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -50,6 +50,12 @@
>>   struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
>>   EXPORT_SYMBOL_GPL(kvm_pmu_ops);
>>   
>> +#define	KVM_X86_PMU_OP(func)	\
>> +	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
>> +				*(((struct kvm_pmu_ops *)0)->func))
>> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
>> +#include <asm/kvm-x86-pmu-ops.h>
>> +
>>   static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>>   {
>>   	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index b2fe135d395a..40e0b523637b 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -45,6 +45,11 @@ struct kvm_pmu_ops {
>>   	void (*cleanup)(struct kvm_vcpu *vcpu);
>>   };
>>   
>> +#define	KVM_X86_PMU_OP(func)	\
>> +	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
>> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
> 
> I don't want to proliferate the pointless and bitrot-prone KVM_X86_OP_NULL macro,
> just omit this.  I'll send a patch to drop KVM_X86_OP_NULL.

Thanks for your clear comments on this patch set.

I will send out V3 once KVM_X86_OP_NULL is dropped as well as
the comment in arch/x86/include/asm/kvm-x86-ops.h is updated.

> 
>> +#include <asm/kvm-x86-pmu-ops.h>
>> +
>>   static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>>   {
>>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> -- 
>> 2.33.0
>>
> 
