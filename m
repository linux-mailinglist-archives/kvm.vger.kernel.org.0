Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653D1305772
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 10:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhA0JyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 04:54:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235521AbhA0JvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 04:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611740988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DaFVJvN6AJIm4eMhIGuGzzmhxpfr2bv/IyhgNnC+fcs=;
        b=gRGHFVQY3lmcjbXocK2gZfhlCKx+iaHfhENUM3y1Ntt+sOOGNc9bmFSLhSW3uMZLgbt6KA
        NOKCBB6BC2PfwCpms2tiLypW97Pnew1RLe933+WaEoNJJnhgCFrfr2UHKc+JfPiIt5TRzL
        tSf889QCCo8DZrjb6Bvp1t6cbTvPTnI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-QT1IY4TeP16kFZ7gb9-3-g-1; Wed, 27 Jan 2021 04:49:47 -0500
X-MC-Unique: QT1IY4TeP16kFZ7gb9-3-g-1
Received: by mail-ej1-f70.google.com with SMTP id q11so442963ejd.0
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 01:49:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DaFVJvN6AJIm4eMhIGuGzzmhxpfr2bv/IyhgNnC+fcs=;
        b=JqxzSxe0IYvGhgmKmv3CPakB3W/ZtHvwgEJJcEVYhRNe1G08O1IswWhRxgvXn8e0IS
         zN90lRmkKc1svVUsKcMMLJSdIJ8J9ckuvg4EetprbEloZ/vS8MHvvYF0+ykI0paEfwCm
         bJgNLx10GmNMhNgwRyv9M0fjiVy7fPAIj2GTVRDXfDgRnuy0TP1vyxL6h8LqXVS6q5pp
         2rjXUTVRYJpCzEwd0nmK1iQCYSwlY6YGfF1po7pR61EiJJbLkxhFzPsIRfXSfGbOEil4
         HP9AWs0gorBki5KaSLmHPWEOphwg8qrs5NmWApiw+1mFMI+8VlBaNWIjQsYZiu05B3KU
         GwcA==
X-Gm-Message-State: AOAM533KO7mBm3IeKDAkwPujVnz8lRtuciK9oAUARanEq0Kpqjh72h2J
        mhZQaP2bqIhlrkfSOKQUpn/Ga9PYDB0wXI1SmhASvfDMCggWLhle3r3ciFiMAdprUCFcOvArN9O
        KK9E/QCuElmFq
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr6266584ejo.59.1611740985605;
        Wed, 27 Jan 2021 01:49:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKE4XIHtscuNYJGHLuvgErFlf3qG4xv2oPDBHbr4SeTGzVxmRmg0qNKm4bY8w1JleVbBlLug==
X-Received: by 2002:a17:906:5495:: with SMTP id r21mr6266562ejo.59.1611740985394;
        Wed, 27 Jan 2021 01:49:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v25sm574656ejw.21.2021.01.27.01.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 01:49:44 -0800 (PST)
Subject: Re: [RESEND v13 09/10] KVM: vmx/pmu: Expose LBR_FMT in the
 MSR_IA32_PERF_CAPABILITIES
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-10-like.xu@linux.intel.com>
 <2ff8ca5a-32ec-ca5d-50c3-d1690e933f6d@redhat.com>
 <fb4c3124-997b-5897-e38f-1b9aa782e5e2@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dfbd5e93-fd15-4185-9315-407011f9aa35@redhat.com>
Date:   Wed, 27 Jan 2021 10:49:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <fb4c3124-997b-5897-e38f-1b9aa782e5e2@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 06:45, Xu, Like wrote:
> On 2021/1/26 17:30, Paolo Bonzini wrote:
>> On 08/01/21 02:37, Like Xu wrote:
>>> Userspace could enable guest LBR feature when the exactly supported
>>> LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES
>>> and the LBR is also compatible with vPMU version and host cpu model.
>>>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>>> ---
>>>   arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
>>>   arch/x86/kvm/vmx/vmx.c          | 7 +++++++
>>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/capabilities.h 
>>> b/arch/x86/kvm/vmx/capabilities.h
>>> index 57b940c613ab..a9a7c4d1b634 100644
>>> --- a/arch/x86/kvm/vmx/capabilities.h
>>> +++ b/arch/x86/kvm/vmx/capabilities.h
>>> @@ -378,7 +378,14 @@ static inline u64 vmx_get_perf_capabilities(void)
>>>        * Since counters are virtualized, KVM would support full
>>>        * width counting unconditionally, even if the host lacks it.
>>>        */
>>> -    return PMU_CAP_FW_WRITES;
>>> +    u64 perf_cap = PMU_CAP_FW_WRITES;
>>> +
>>> +    if (boot_cpu_has(X86_FEATURE_PDCM))
>>> +        rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>>> +
>>> +    perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
>>> +
>>> +    return perf_cap;
>>>   }
>>>     static inline u64 vmx_supported_debugctl(void)
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index ad3b079f6700..9cb5b1e4fc27 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -2229,6 +2229,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, 
>>> struct msr_data *msr_info)
>>>       case MSR_IA32_PERF_CAPABILITIES:
>>>           if (data && !vcpu_to_pmu(vcpu)->version)
>>>               return 1;
>>> +        if (data & PMU_CAP_LBR_FMT) {
>>> +            if ((data & PMU_CAP_LBR_FMT) !=
>>> +                (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
>>> +                return 1;
>>> +            if (!intel_pmu_lbr_is_compatible(vcpu))
>>> +                return 1;
>>> +        }
>>>           ret = kvm_set_msr_common(vcpu, msr_info);
>>>           break;
>>>
>>
>> Please move this hunk to patch 4.
>>
>> Paolo
>>
> Thanks, I'll do this part early in the next version.
> 
> I would have thought that we need to
> make the interface exposing as the last enabling step.

That's the right thing to do for vmx_get_perf_capabilities().  However, 
checking the values of MSR_IA32_PERF_CAPABILITIES can be done early.

Paolo

