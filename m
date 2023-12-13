Return-Path: <kvm+bounces-4305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 572C6810C5A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C9A5281B82
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38981EB38;
	Wed, 13 Dec 2023 08:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0dNI53Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5659DF2;
	Wed, 13 Dec 2023 00:25:02 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6cea2a38b48so5887103b3a.3;
        Wed, 13 Dec 2023 00:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702455902; x=1703060702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uh3dbu4BJGoqG7WyDjS7Ql7hw90UlDVfz+hx8zYG/jE=;
        b=C0dNI53Qb4NVQjHQS71eLSRw2si/uiDCOBCSdkAA2A+ZmlRwQKkNcQzb5+wvRZ5EYE
         bqW20YJzTnKYBy+/NbKdwfRyWF9hsmysSPLOhS5Ur8ydKrK7mMCwJg6xxOEC1GGmqmvJ
         v/fZVibEWCdpcRcYvkxGf7fIyHut2BL0n7d6UkYs9iA024HU0J91jPT3nMRFxUxhR2pf
         Jt5V0qqxZB2+fRQDTNygb+Y/85Za8utBx8bU2NGniKQe0Neysv5UB6GxYmf/5yRxhgGd
         3CKRxTdODZerGW8algGMcEm+DonXXOryCnSPWhQQAqu3ysrzk/MFJwQp26CDfFEqf9Kd
         R6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702455902; x=1703060702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uh3dbu4BJGoqG7WyDjS7Ql7hw90UlDVfz+hx8zYG/jE=;
        b=iEqzCmsQrr8kEbBCbttMdbzOVBeCehyAbSL9Rj2J9of/9XnpvvWAjFATUGtQroeHju
         niX5D+E6TjVLATncoD+6BcmZRdlaME+Tp8ahmLw9yCPF8ZDZ3xgJvYgaZO5BnZlbf68I
         UKgv489j+2pz4849gaux6Ef6/I5yx7lOnJdSb40d2bV/ujWgd09mJHpfPtVSIEZRPc7+
         W8UkHD967fs5XmE+KAO+49SUMuXmrOwpF+QJyBKYNZ7RX9OrsMlcQ95WV6SG12jYO68A
         gqJLHBLtZ2YWJGvM9xe31oC35/y5HCHf4ckfdrDYtxRlPVaU7NLUKe0y7jQNsvOfvUCI
         KK3w==
X-Gm-Message-State: AOJu0YxHiJQ1ZfDKTsdQOBbdH0CqN1hnJkUN+N95Uy88lAtDQqW0jPcU
	Lrpt6pSVp7r1j/Q7uArp8Tc=
X-Google-Smtp-Source: AGHT+IHk9xKbXKXJI4IzKs7YZf5cJqfyU+FKKjoIMbM8cAp68YbPe8olw2mibm4zNmxgq3ynp1h97Q==
X-Received: by 2002:a05:6a00:10cc:b0:6ce:751b:81d9 with SMTP id d12-20020a056a0010cc00b006ce751b81d9mr8704308pfu.9.1702455901616;
        Wed, 13 Dec 2023 00:25:01 -0800 (PST)
Received: from [192.168.255.10] ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id u23-20020a62d457000000b006ce9e9d27c7sm9798465pfl.129.2023.12.13.00.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 00:25:01 -0800 (PST)
Message-ID: <0591cb18-77e1-4e98-a405-4a39cfb512e1@gmail.com>
Date: Wed, 13 Dec 2023 16:24:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>
References: <20231206032054.55070-1-likexu@tencent.com>
 <6d3417f7-062e-9934-01ab-20e3a46656a7@oracle.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <6d3417f7-062e-9934-01ab-20e3a46656a7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/12/2023 3:28 pm, Dongli Zhang wrote:
> Hi Like,
> 
> On 12/5/23 19:20, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Explicitly checking the source of external interrupt is indeed NMI and not
>> other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
>> positive samples generated in perf/core NMI mode after vm-exit but before
>> kvm_before_interrupt() from being incorrectly labelled as guest samples:
> 
> About the before kvm_before_interrupt() ...
> 
>>
>> # test: perf-record + cpu-cycles:HP (which collects host-only precise samples)
>> # Symbol                                   Overhead       sys       usr  guest sys  guest usr
>> # .......................................  ........  ........  ........  .........  .........
>> #
>> # Before:
>>    [g] entry_SYSCALL_64                       24.63%     0.00%     0.00%     24.63%      0.00%
>>    [g] syscall_return_via_sysret              23.23%     0.00%     0.00%     23.23%      0.00%
>>    [g] files_lookup_fd_raw                     6.35%     0.00%     0.00%      6.35%      0.00%
>> # After:
>>    [k] perf_adjust_freq_unthr_context         57.23%    57.23%     0.00%      0.00%      0.00%
>>    [k] __vmx_vcpu_run                          4.09%     4.09%     0.00%      0.00%      0.00%
>>    [k] vmx_update_host_rsp                     3.17%     3.17%     0.00%      0.00%      0.00%
>>
>> In the above case, perf records the samples labelled '[g]', the RIPs behind
>> the weird samples are actually being queried by perf_instruction_pointer()
>> after determining whether it's in GUEST state or not, and here's the issue:
>>
>> If vm-exit is caused by a non-NMI interrupt (such as hrtimer_interrupt) and
>> at least one PMU counter is enabled on host, the kvm_arch_pmi_in_guest()
>> will remain true (KVM_HANDLING_IRQ is set) until kvm_before_interrupt().
> 
> ... and here.
> 
> Would you mind helping why kvm_arch_pmi_in_guest() remains true before
> *kvm_before_interrupt()*.
> 
> According to the source code, the vcpu->arch.handling_intr_from_guest
> is set to non-zero only at kvm_before_interrupt(), and cleared at
> kvm_after_interrupt().
> 
> Or would you mean kvm_after_interrupt()?

Oops, it should refer to kvm_after_interrupt() as the code fixed. Thank you.

> 
> Thank you very much!
> 
> Dongli Zhang
> 
>>
>> During this window, if a PMI occurs on host (since the KVM instructions on
>> host are being executed), the control flow, with the help of the host NMI
>> context, will be transferred to perf/core to generate performance samples,
>> thus perf_instruction_pointer() and perf_guest_get_ip() is called.
>>
>> Since kvm_arch_pmi_in_guest() only checks if there is an interrupt, it may
>> cause perf/core to mistakenly assume that the source RIP of the host NMI
>> belongs to the guest world and use perf_guest_get_ip() to get the RIP of
>> a vCPU that has already exited by a non-NMI interrupt.
>>
>> Error samples are recorded and presented to the end-user via perf-report.
>> Such false positive samples could be eliminated by explicitly determining
>> if the exit reason is KVM_HANDLING_NMI.
>>
>> Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
>> is cleared, it's also still possible that another PMI is generated on host.
>> Also for perf/core timer mode, the false positives are still possible since
>> that non-NMI sources of interrupts are not always being used by perf/core.
>> In both cases above, perf/core should correctly distinguish between real
>> RIP sources or even need to generate two samples, belonging to host and
>> guest separately, but that's perf/core's story for interested warriors.
>>
>> Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> V1 -> V2 Changelog:
>> - Refine commit message to cover both perf/core timer and NMI modes;
>> - Use in_nmi() to distinguish whether it's NMI mode or not; (Sean)
>> V1: https://urldefense.com/v3/__https://lore.kernel.org/kvm/20231204074535.9567-1-likexu@tencent.com/__;!!ACWV5N9M2RV99hQ!MQ8FetD27SVKN34CS_P-K3qrhspFnpf_Mqb0McFN9y5vSUeScc5b0TlZ3ZMDvt4Cn4b3g0h9ci6EO9k3PBEQXpePrg$
>>   arch/x86/include/asm/kvm_host.h | 10 +++++++++-
>>   arch/x86/kvm/x86.h              |  6 ------
>>   2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index c8c7e2475a18..167d592e08d0 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1868,8 +1868,16 @@ static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
>>   }
>>   #endif /* CONFIG_HYPERV */
>>   
>> +enum kvm_intr_type {
>> +	/* Values are arbitrary, but must be non-zero. */
>> +	KVM_HANDLING_IRQ = 1,
>> +	KVM_HANDLING_NMI,
>> +};
>> +
>> +/* Enable perf NMI and timer modes to work, and minimise false positives. */
>>   #define kvm_arch_pmi_in_guest(vcpu) \
>> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
>> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
>> +	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>>   
>>   void __init kvm_mmu_x86_module_init(void);
>>   int kvm_mmu_vendor_module_init(void);
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 2f7e19166658..4dc38092d599 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>>   	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
>>   }
>>   
>> -enum kvm_intr_type {
>> -	/* Values are arbitrary, but must be non-zero. */
>> -	KVM_HANDLING_IRQ = 1,
>> -	KVM_HANDLING_NMI,
>> -};
>> -
>>   static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>>   						 enum kvm_intr_type intr)
>>   {
>>
>> base-commit: 1ab097653e4dd8d23272d028a61352c23486fd4a

