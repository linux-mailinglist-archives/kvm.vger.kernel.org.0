Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A2D490558
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiAQJo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 04:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiAQJoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 04:44:25 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E45EC061574;
        Mon, 17 Jan 2022 01:44:25 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso29629291pjm.4;
        Mon, 17 Jan 2022 01:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=mdwf3QVWEVozyH3y2Bjjx4PrVGzKuMTlglc54DhgDfA=;
        b=aCjFWLvc9zk1tqajP/UTFqJZKTKsLlZK3yRxd87MFggY6n+JvpqTtqPDsbc/k6c1RV
         H0qkh8DBomANTG0HvwXpf7hNXk6WAdWNEaWV9ppoo//5wqcR6gC80+XgMEy2Crj2tbdg
         fViwJOhLWs5pvK9q9Efm3Z0yo/e00O0l8uCoXECfMMWrRpVn2lJYlrwq4Bo+i/jwMfEI
         xXG+Nnz04K4QBK8nUcXRIKQtKo6gfVi0zkbxnG6agOC0LlzskhF0Dyy/JTh73VoFjk5a
         iyuZ5i0JxfIQUxofKh5v5ZnVUmdBtRKCDy5Rsq+tdYuycmNWGy3zykSn929WFo1HtSgN
         gGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=mdwf3QVWEVozyH3y2Bjjx4PrVGzKuMTlglc54DhgDfA=;
        b=mcPqqLsKnKWfTWQh+vuxkLOfb1cp4/B6Vx9we9S0Rhd1z3ltNxcLjU0Hsom/GPWiDs
         Dd8Aryqm/q8njZ/nRxJFWltbmPYbsHtMGgT3G1I7gkS1uO+nLTwxqp/lmImc0Ta5OAsu
         F3FGo7HiALT42W8qfwcIrip1GC6tVMi/txchCXsBbHNSXgpfC45xULZ9oLhVN9spsFqy
         4virVlAxZ7t5s/NmRM3aZ7PNVuo8lDRMTTezeuBW66bJbsgF6OgPJGYuYlbYepvIv+lo
         Lv7kFrtB0J0kMEMG63dbrfO1II29CB6RHEXksEIpEqaYs07ypBJse6G/RX0v2NaOaXeM
         wbTA==
X-Gm-Message-State: AOAM530osn9ssTzOCPCO6+GSyL0s9YX5tNfuApEarEBhTrKo9ZwsmPoC
        qJIDdzkmL6pge3evAil2uUDSyZLVio0PwA==
X-Google-Smtp-Source: ABdhPJxoGRrN24sGF2vubdM+x8QNuX3vVLK8ELd6PN0PXEk6dD2S4QNPG1u86Lh0s15OZRn6hpK+XA==
X-Received: by 2002:a17:902:d2ce:b0:14a:9f24:879d with SMTP id n14-20020a170902d2ce00b0014a9f24879dmr9859504plc.10.1642412665006;
        Mon, 17 Jan 2022 01:44:25 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t7sm12779361pfj.168.2022.01.17.01.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 01:44:24 -0800 (PST)
Message-ID: <9c655b21-640f-6ce8-61b4-c6444995091e@gmail.com>
Date:   Mon, 17 Jan 2022 17:44:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
 <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for XSETBV
 emulation
In-Reply-To: <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uh, thanks for your prompt response.

On 17/1/2022 4:31 pm, Paolo Bonzini wrote:
> On 1/17/22 08:24, Like Xu wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 76b4803dd3bd..7d8622e592bb 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1024,7 +1024,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 
>> index, u64 xcr)
>>   int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>>   {
>> -    if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
>> +    if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
>> +        !kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
>> +        return kvm_handle_invalid_op(vcpu);
> 
> There's no need to check XSAVE, because it XSAVE=0 will prevent setting 
> CR4.OSXSAVE.

So we just need to check X86_CR4_OSXSAVE for #UD here ?

> 
> Likewise, CPL and SS.DPL are also defined in real mode so there's no need to 
> check is_protmode.  The Intel manuals sometimes still act as the descriptor 
> caches don't exist, even though VMX effectively made them part of the architecture.

OK, make sense to drop is_protmode().

> 
> Also, the "Fixes" tag is not really correct as the behavior was the same 
> before.  Rather, it fixes commit 02d4160fbd76 ("x86: KVM: add xsetbv to the 

It seems the original code comes from 81dd35d42c9a ("KVM: SVM: Add xsetbv 
intercept").
2acf923e38 ("KVM: VMX: Enable XSAVE/XRSTOR for guest") and 92f9895c146d.

> emulator", 2019-08-22).  Checking OSXSAVE is a bug in the emulator path, even 
> though it's not needed in the XSETBV vmexit case.

The kvm_emulate_xsetbv() has been removed from the emulator path.
I'm not really sure why it's not needed in the XSETBV vmexit case. More details ?

> 
> Thanks,
> 
> Paolo
> 
>> +    if ((is_protmode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) != 0) ||
>>           __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
>>           kvm_inject_gp(vcpu, 0);
>>           return 1;
> 
> 
