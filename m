Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F8379FE34
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 10:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbjINIXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 04:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjINIX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 04:23:29 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82591BFC;
        Thu, 14 Sep 2023 01:23:25 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-57790939a2bso473871a12.3;
        Thu, 14 Sep 2023 01:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694679805; x=1695284605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y4DVGHEKkh6DJ6bSb9WKSdfDpI9FMYgxcK/JHrHLUwY=;
        b=W9nQqW8lT75p2gLWN1GVIAxtPcL7t7232jmZnqoRBnNfcr3AwxNctH1OhY1be+XyC4
         2tvi/d4rWZrQHjezVGRX5fmAh+oh6k6MTs2EuYZXfIvui/J4TEvFzHX5rnGYOm3gIPOZ
         dojctmW8ehsSICv8mT5U7zHY5g1BPvjBbzAczlIgBsTrzsthHbrGPyfeD91kHI133coT
         PyzEcyGQzFJmjuB0wNFG8/kgUQB3F/nefO0Zh80VzVh5KbqvK97EvfYkdQUVbpfIlive
         oeEOSw7I5xKN8a06U/6fPKc72Yrr496YpyCiJbpxWAUwfrDjHLv62gibeE9BjFubiTap
         fCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694679805; x=1695284605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4DVGHEKkh6DJ6bSb9WKSdfDpI9FMYgxcK/JHrHLUwY=;
        b=kF6H+Y/Eh42TJIbkXAVnmWKlOBSptXYS7ZYXccbYCVg0ID3EFBW2JKYAWwNG4T6cHq
         QzgZ4xww9oiehN9YxYuJpbi+REim/VfHvwBw/WW9hh4Ys9AnU44+sMfC1hUMCdEJQEIt
         NXXaLHAfmwSw1khn2hfe/o3uWQ9FaPJTLT1wfYMLzdBHKIFjBWCow8DOMa4pPUqMnESi
         CE/yEvgsfugLxepBtwxMYfQqQDSRcCB4vJfo43fPaJCDFyks0IKTbC+l35lHC4O6WPz9
         YOkihtL1nmsNz4ST0+gq3iCcV6UiwESBOuD+uyYaQ+m7PV9zek5YqMZTz+gIpHx4zTtA
         F/hQ==
X-Gm-Message-State: AOJu0Yxw3A5c4wF4qVX//+3R59cQnH9DS4TAqZEmk3GxoMfc9SWlmS7e
        4cpCXq/J8W9LiixanpSryPU=
X-Google-Smtp-Source: AGHT+IEkhM0boEsH1csJYAlUVyFy80w/YI5btaaNgRG4LP+YfyPdSdsybSXgW39nzTyKSCXj3CkIZA==
X-Received: by 2002:a05:6a20:3955:b0:13e:b58a:e3e8 with SMTP id r21-20020a056a20395500b0013eb58ae3e8mr5512715pzg.50.1694679805300;
        Thu, 14 Sep 2023 01:23:25 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l6-20020a17090ac58600b002682392506bsm811438pjt.50.2023.09.14.01.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 01:23:24 -0700 (PDT)
Message-ID: <6ee140c9-ccd5-9569-db17-a542a7e28d5c@gmail.com>
Date:   Thu, 14 Sep 2023 16:23:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH V2] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit
 doesn't exist
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Manali Shukla <manali.shukla@amd.com>
References: <20230407085646.24809-1-likexu@tencent.com>
 <ZDA4nsyAku9B2/58@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZDA4nsyAku9B2/58@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 11:37 pm, Sean Christopherson wrote:
> On Fri, Apr 07, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Unlike Intel's MSR atomic_switch mechanism, AMD supports guest pmu
>> basic counter feature by setting the GUESTONLY bit on the host, so the
>> presence or absence of this bit determines whether vPMU is emulatable
>> (e.g. in nested virtualization). Since on AMD, writing reserved bits of
>> EVENTSEL register does not bring #GP, KVM needs to update the global
>> enable_pmu value by checking the persistence of this GUESTONLY bit.
> 
> This is looking more and more like a bug fix, i.e. needs a Fixes:, no?

Fix: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM") ?
Fix: 4b6e4dca7011 ("KVM: SVM: enable nested svm by default") ?

As far as I can tell, the current KVM code makes the PMU counter of AMD nested
VMs have ridiculous values. One conservative fix is to disable nested PMU on AMD.

> 
>> Cc: Ravi Bangoria <ravi.bangoria@amd.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> V1:
>> https://lore.kernel.org/kvm/20230307113819.34089-1-likexu@tencent.com
>> V1 -> V2 Changelog:
>> - Preemption needs to be disabled to ensure a stable CPU; (Sean)
>> - KVM should be restoring the original value too; (Sean)
>> - Disable vPMU once guest_only mode is not supported; (Sean)
> 
> Please respond to my questions, don't just send a new version.  When I asked
> 
>   : Why does lack of AMD64_EVENTSEL_GUESTONLY disable the PMU, but if and only if
>   : X86_FEATURE_PERFCTR_CORE?  E.g. why does the behavior not also apply to legacy
>   : perfmon support?
> 
> I wanted an actual answer because I genuinely do not know what the correct
> behavior is.

As far as I know, only AMD CPUs that support PERFCTR_CORE+ will have
the GUESTONLY bit, if the BIOS doesn't disable it.

The "GO/HO bit" is first introduced for perf-kvm usage (2011)
before adding support for AMD guest vPMU (2015).

As the guest_only name implies, this bit can be used for SVM to emulate
core counter for AMD guests. So if the host does not have this bit (e.g.
on the L1 VM), the L2 VM's vPMU will work abnormally.

> 
>> - Appreciate any better way to probe for GUESTONLY support;
> 
> Again, wait for discussion in previous versions to resolve before posting a new
> version.  If your answer is "not as far as I know", that's totally fine, but
> sending a new version without responding makes it unnecessarily difficult to
> track down your "answer".  E.g. instead of seeing a very direct "I don't know",
> I had to discover that answer by finding a hint buried in the ignored section of
> a new patch.

Okay, then. Nice rule to follow.

> 
>>   arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7584eb85410b..1ab885596510 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4884,6 +4884,20 @@ static __init void svm_adjust_mmio_mask(void)
>>   	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>>   }
>>   
>> +static __init bool pmu_has_guestonly_mode(void)
>> +{
>> +	u64 original, value;
>> +
>> +	preempt_disable();
>> +	rdmsrl(MSR_F15H_PERF_CTL0, original);
> 
> What guarantees this MSR actually exists?  In v1, it was guarded by enable_pmu=%true,
> but that's longer the case.  And KVM does
> 
> 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> 		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> 			return NULL;
> 
> which very strongly suggests this MSR doesn't exist if the CPU supports only the
> "legacy" PMU.

Yes, the check for boot_cpu_has(X86_FEATURE_PERFCTR_CORE) is missing here.

> 
>> +	wrmsrl(MSR_F15H_PERF_CTL0, AMD64_EVENTSEL_GUESTONLY);
>> +	rdmsrl(MSR_F15H_PERF_CTL0, value);
>> +	wrmsrl(MSR_F15H_PERF_CTL0, original);
>> +	preempt_enable();
>> +
>> +	return value == AMD64_EVENTSEL_GUESTONLY;
>> +}
>> +
>>   static __init void svm_set_cpu_caps(void)
>>   {
>>   	kvm_set_cpu_caps();
>> @@ -4928,6 +4942,9 @@ static __init void svm_set_cpu_caps(void)
>>   	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>   		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>>   
>> +	/* Probe for AMD64_EVENTSEL_GUESTONLY support */
> 
> I've said this several times recently: use comments to explain _why_ and to call
> out subtleties.  The code quite obviously is probing for guest-only support, what's
> not obvious is why guest-only support is mandatory for vPMU support.  It may be
> obvious to you, but pease try to view all of this code from the perspective of
> someone who has only passing knowledge of the various components, i.e. doesn't
> know the gory details of exactly what KVM supports.

How about:

/*
  * The guest vPMU counter emulation depends on the EVENTSEL_GUESTONLY bit.
  * If this bit is present on the host, the host needs to support at least the 
PERFCTR_CORE.
  */

> 
> Poking around, I see that pmc_reprogram_counter() unconditionally does
> 
> 	.exclude_host = 1,
> 
> and amd_core_hw_config()
> 
> 	if (event->attr.exclude_host && event->attr.exclude_guest)
> 		/*
> 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
> 		 * and will count in both modes. We don't want to count in that
> 		 * case so we emulate no-counting by setting US = OS = 0.
> 		 */
> 		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
> 				      ARCH_PERFMON_EVENTSEL_OS);
> 	else if (event->attr.exclude_host)
> 		event->hw.config |= AMD64_EVENTSEL_GUESTONLY;
> 	else if (event->attr.exclude_guest)
> 		event->hw.config |= AMD64_EVENTSEL_HOSTONLY;
> 
> and so something like this seems appropriate
> 
> 	/*
> 	 * KVM requires guest-only event support in order to isolate guest PMCs
> 	 * from host PMCs.  SVM doesn't provide a way to atomically load MSRs
> 	 * on VMRUN, and manually adjusting counts before/after VMRUN is not
> 	 * accurate enough to properly virtualize a PMU.
> 	 */
> 
> But now I'm really confused, because if I'm reading the code correctly, perf
> invokes amd_core_hw_config() for legacy PMUs, i.e. even if PERFCTR_CORE isn't
> supported.  And the APM documents the host/guest bits only for "Core Performance
> Event-Select Registers".
> 
> So either (a) GUESTONLY isn't supported on legacy CPUs and perf is relying on AMD
> CPUs ignoring reserved bits or (b) GUESTONLY _is_ supported on legacy PMUs and
> pmu_has_guestonly_mode() is checking the wrong MSR when running on older CPUs.
> 
> And if (a) is true, then how on earth does KVM support vPMU when running on a
> legacy PMU?  Is vPMU on AMD just wildly broken?  Am I missing something?
> 

(a) It's true and AMD guest vPMU have only been implemented accurately with
the help of this GUESTONLY bit.

There are two other scenarios worth discussing here: one is support L2 vPMU
on the PERFCTR_CORE+ host and this proposal is disabling it; and the other
case is to support AMD legacy vPMU on the PERFCTR_CORE+ host.

Please let me know if you have more concerns.
