Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA7447C2E
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 09:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhKHIq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 03:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhKHIq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 03:46:58 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9154FC061570;
        Mon,  8 Nov 2021 00:44:14 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s13so1049587pfd.7;
        Mon, 08 Nov 2021 00:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=8Xz0PShYoFNEtIcVxT30uGd5Y/7UcZmS+lhaA+m9dbk=;
        b=mdTYiM8mAnAd/Y/SUHhHUP/w4+N5nS9LQEdY718bleIYyAhwyy56SmlgsHt/MWSrMm
         gpS+iaDvqA3r33wu8hl6j8Q7z7frEUi8n7JhDxdNjkkbmWyJgOsgmACyWv2XaVjQyt6y
         4ZWc+6uN7v+oppFji5jZiGMCE+UU8/e6e/dNp+Gs7Cgep8/3fsl4brIU6PLnwR3xgjIe
         Y/ocg1LVjhQw6Z/jzuxWwDd+ADpCMC0zaA+tXCyNAKEgLv/Qd/3Ld3UAJFHnARxFa0aF
         942APDKqgEAn/7BApYcofJf4c6ANudogW/A89SsvIvN2tGMVX/TSXwh/or2KQXXzSHTq
         D5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=8Xz0PShYoFNEtIcVxT30uGd5Y/7UcZmS+lhaA+m9dbk=;
        b=faQe/XjgxyZGUVoKzEQDSs9M+1niuKi9aHLKrLnKHjqvp7b488e/vcZCgH4lVkm3rP
         eBr2hvlaZ4p6uHx1QmDOiyghnDrS75syNKtK8iM59CqgLiao2rhok9W7TbELMlnQMyIG
         eDF5/gNQ0tEYMWMwzHsRAK/QxRm5Acn5NpABIlVmrNVYt8RARwISqlVCrECXOwZwamiH
         0MQak1NoKCjWXOvP9EmDOo6Dwm/vxKgGdJpeGeCaJWxvTKdFFTfW67Un+kWORw8tmMT+
         voYYdNaGaokIl1RMTu8Sse2IX7XR6vvhRe0PO8knKAgJZJD2XJnTK9XUZHBRn3QFRVNn
         Be6w==
X-Gm-Message-State: AOAM5313zPlv+Je3p5S9jPe0/Xz7j+aOok8w/Kj+WC4fd2YSgBoPvrSq
        vWnTvg3bLeNQ88MScsUrg3g=
X-Google-Smtp-Source: ABdhPJzAf4oZVLK1FuP8HA0NMJsbW92kodCTkQJsrBEFthuCloomJmecnigcZAlz9N1Zy5lUvIKTcw==
X-Received: by 2002:a63:de48:: with SMTP id y8mr43489719pgi.255.1636361053965;
        Mon, 08 Nov 2021 00:44:13 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ep15sm1777965pjb.3.2021.11.08.00.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 00:44:13 -0800 (PST)
Message-ID: <97bc3da2-202b-f1f0-a269-4e28c848c7e9@gmail.com>
Date:   Mon, 8 Nov 2021 16:44:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH V10 05/18] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
Content-Language: en-US
To:     Liuxiangdong <liuxiangdong5@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com, Yao Yuan <yuan.yao@intel.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-6-lingshan.zhu@intel.com> <6187A6F9.5030401@huawei.com>
 <5aa115ab-d22c-098d-0591-36c7ab15f8b6@gmail.com>
 <6188A28B.2020302@huawei.com>
 <276febe3-f61c-8c3d-b069-bbcea4217660@gmail.com>
 <6188DF79.7010405@huawei.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <6188DF79.7010405@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/2021 4:27 pm, Liuxiangdong wrote:
> 
> 
> On 2021/11/8 12:11, Like Xu wrote:
>> On 8/11/2021 12:07 pm, Liuxiangdong wrote:
>>>
>>>
>>> On 2021/11/8 11:06, Like Xu wrote:
>>>> On 7/11/2021 6:14 pm, Liuxiangdong wrote:
>>>>> Hi, like and lingshan.
>>>>>
>>>>> As said,  IA32_MISC_ENABLE[7] bit depends on the PMU is enabled for the 
>>>>> guest, so a software
>>>>> write openration to this bit will be ignored.
>>>>>
>>>>> But, in this patch, all the openration that writes msr_ia32_misc_enable in 
>>>>> guest could make this bit become 0.
>>>>>
>>>>> Suppose:
>>>>> When we start vm with "enable_pmu", vcpu->arch.ia32_misc_enable_msr may be 
>>>>> 0x80 first.
>>>>> And next, guest writes msr_ia32_misc_enable value 0x1.
>>>>> What we want could be 0x81, but unfortunately, it will be 0x1 because of
>>>>> "data &= ~MSR_IA32_MISC_ENABLE_EMON;"
>>>>> And even if guest writes msr_ia32_misc_enable value 0x81, it will be 0x1 also.
>>>>>
>>>>
>>>> Yes and thank you. The fix has been committed on my private tree for a long 
>>>> time.
>>>>
>>>>>
>>>>> What we want is write operation will not change this bit. So, how about this?
>>>>>
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
>>>>> msr_data *msr_info)
>>>>>           }
>>>>>           break;
>>>>>       case MSR_IA32_MISC_ENABLE:
>>>>> +        data &= ~MSR_IA32_MISC_ENABLE_EMON;
>>>>> +        data |= (vcpu->arch.ia32_misc_enable_msr & 
>>>>> MSR_IA32_MISC_ENABLE_EMON);
>>>>>           if (!kvm_check_has_quirk(vcpu->kvm, 
>>>>> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>>>>>               ((vcpu->arch.ia32_misc_enable_msr ^ data) & 
>>>>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>>>>               if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>>>>
>>>>>
>>>>
>>>> How about this for the final state considering PEBS enabling:
>>>>
>>>>     case MSR_IA32_MISC_ENABLE: {
>>>>         u64 old_val = vcpu->arch.ia32_misc_enable_msr;
>>>>         u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
>>>>             MSR_IA32_MISC_ENABLE_EMON;
>>>>
>>>          u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
>>>              MSR_IA32_MISC_ENABLE_EMON;
>>>
>>> Repetitive "MSR_IA32_MISC_ENABLE_EMON" ?
>>
>> Oops,
>>
>>     u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
>>             MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
>>
> 
> Yes. bit[12] is also read-only, so we can keep this bit unchanged also.
> 
> And, because write operation will not change this bit by "pmu_mask", do we still 
> need this if statement?
> 
>          /* RO bits */
>          if (!msr_info->host_initiated &&
>              ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
>              return 1;
> 
> "(old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL" means some operation 
> tries to change this bit,
> so we cannot allow it.
> But, if there is no this judgement, "pmu_mask" will still make this bit[12] no 
> change.
> 
> The only difference is that we can not change other bit (except bit 12 and bit 
> 7) once "old_val[12] != data[12]" if there exists this statement
> and we can change other bit if there is no judgement.
> 
> For both MSR_IA32_MISC_ENABLE_EMON and MSR_IA32_MISC_ENABLE_EMON are read-only, 
> maybe we can keep
> their behavioral consistency. Either both judge, or neither.

One more difference per Intel SDM, I assume:

For Bit 7, Performance Monitoring Available (R)
	(R)  means that attempts to change this bit will be silent;
For Bit 12, Processor Event Based Sampling (PEBS) Unavailable (RO),
	(RO) means that attempts to change this bit will be #GP;

> 
> Do you think so?
> 
> 
>> I'll send the fix after sync with Lingshan.
>>
>>>
>>>>         /* RO bits */
>>>>         if (!msr_info->host_initiated &&
>>>>             ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
>>>>             return 1;
>>>>
>>>>         /*
>>>>          * For a dummy user space, the order of setting vPMU capabilities and
>>>>          * initialising MSR_IA32_MISC_ENABLE is not strictly guaranteed, so to
>>>>          * avoid inconsistent functionality we keep the vPMU bits unchanged 
>>>> here.
>>>>          */
>>> Yes. It's a little clearer with comments.
>>
>> Thanks for your feedback! Enjoy the feature.
>>
>>>>         data &= ~pmu_mask;
>>>>         data |= old_val & pmu_mask;
>>>>         if (!kvm_check_has_quirk(vcpu->kvm, 
>>>> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>>>>             ((old_val ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>>>>             if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>>>                 return 1;
>>>>             vcpu->arch.ia32_misc_enable_msr = data;
>>>>             kvm_update_cpuid_runtime(vcpu);
>>>>         } else {
>>>>             vcpu->arch.ia32_misc_enable_msr = data;
>>>>         }
>>>>         break;
>>>>     }
>>>>
>>>>> Or is there anything in your design intention I don't understand?
>>>>>
>>>>> Thanks!
>>>>>
>>>>> Xiangdong Liu
>>>>>
>>>>>
>>>>> On 2021/8/6 21:37, Zhu Lingshan wrote:
>>>>>> From: Like Xu <like.xu@linux.intel.com>
>>>>>>
>>>>>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
>>>>>> detect whether the processor supports performance monitoring facility.
>>>>>>
>>>>>> It depends on the PMU is enabled for the guest, and a software write
>>>>>> operation to this available bit will be ignored. The proposal to ignore
>>>>>> the toggle in KVM is the way to go and that behavior matches bare metal.
>>>>>>
>>>>>> Cc: Yao Yuan <yuan.yao@intel.com>
>>>>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>>>>> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>>>>> ---
>>>>>>   arch/x86/kvm/vmx/pmu_intel.c | 1 +
>>>>>>   arch/x86/kvm/x86.c           | 1 +
>>>>>>   2 files changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> index 9efc1a6b8693..d9dbebe03cae 100644
>>>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>>>> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>>>       if (!pmu->version)
>>>>>>           return;
>>>>>> +    vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
>>>>>>       perf_get_x86_pmu_capability(&x86_pmu);
>>>>>>       pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>> index efd11702465c..f6b6984e26ef 100644
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
>>>>>> msr_data *msr_info)
>>>>>>           }
>>>>>>           break;
>>>>>>       case MSR_IA32_MISC_ENABLE:
>>>>>> +        data &= ~MSR_IA32_MISC_ENABLE_EMON;
>>>>>>           if (!kvm_check_has_quirk(vcpu->kvm, 
>>>>>> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>>>>>>               ((vcpu->arch.ia32_misc_enable_msr ^ data) & 
>>>>>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>>>>>               if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>>>>
>>>
> 
