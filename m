Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22DF623E8E
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 10:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKJJ1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 04:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiKJJ1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 04:27:04 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE776A697;
        Thu, 10 Nov 2022 01:27:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so4207776pjc.3;
        Thu, 10 Nov 2022 01:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yYm73sNWFFE4EpN1dR1Cx+FmfgIhAJM/KoAjWBFI0pU=;
        b=S11BeIH9//OPm5srXrPrTgYJzz+5OmimB+1dMAHEycfVcEf/NOwXJJCasXSpwsi2WG
         UOA5OtVZRUVwZvvindZLVt7X0OSeuXvxce6yQLh04fsADzfFiuhgfa8+o7hJBk8sqUYg
         /g/2MlWduEstk/j84Fh338RjO+zz/JPMMSvEFVw9oYyysODTKYdIJKPYnX5Xt/0BqEyy
         QpGaD+nhn84sHfYtINI9c/MJsy0vxK0VKVL/AD4Eky+WTKW6IlHVCW0Fa1YMXaMmFni+
         2CFoeh6S04RYG7p27QOVEES6blCCO5A7Wr1ifVghvF3synbsdUBcBULux77gbKPd3BiV
         5hSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yYm73sNWFFE4EpN1dR1Cx+FmfgIhAJM/KoAjWBFI0pU=;
        b=ftkbzfvLNYlqD/HA3l7pmpvfx5J+CveiEY7BM4dBeM3lM2u64kH0HSYGdMMx4TlaBa
         tzWuhmI6opJsSp1hD3NXuq09wd7CNc+yy3QcarYJyqKg2Pcg4DzruEFOXPd5uwD9VHXJ
         3YCMXIBXKq4YEXoeJKLnIxmnN6Gm01sSudk9lFkvvXAgux2sewcmlDa0GkF/QaGrDHeQ
         WTN2SjuhKPoK8WERyy6FuFJlm6Hg85/qBKlLPaDZvsepfn976FviT36fF2GlAgsvDDd/
         LKkyeJVvW0J+1yJ0mD277kbBuxRWFD+mPiFpuJr2go8AqwtaIVU3jF883BoJcL1q8xaa
         IDQQ==
X-Gm-Message-State: ACrzQf3/pV1SD+Ze15eCBegZ5hEkvTrCifPbHZdl4gWGWEbcpA0oG059
        zam/QhSFcysdmnto2z+/6sLf1gv8Jjg7VSYV
X-Google-Smtp-Source: AMsMyM4EseASGx+Zu4adT2uRSUFLBvFguQM9DVRUkpSniAgkjaOqOeWtMXnKvUStdK8wRa+SV9ecEA==
X-Received: by 2002:a17:902:bc88:b0:185:4421:250 with SMTP id bb8-20020a170902bc8800b0018544210250mr62698002plb.29.1668072423183;
        Thu, 10 Nov 2022 01:27:03 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902ea0b00b0018700ba9090sm10718065plg.185.2022.11.10.01.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 01:27:02 -0800 (PST)
Message-ID: <948ec6a5-3f30-e8c2-9629-12235f1e1367@gmail.com>
Date:   Thu, 10 Nov 2022 17:26:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v2 3/3] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg
 leaf 0x80000022
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-4-likexu@tencent.com> <Y1sIHXX3HEJEXJm+@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y1sIHXX3HEJEXJm+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/2022 6:37 am, Sean Christopherson wrote:
> On Mon, Sep 19, 2022, Like Xu wrote:
>> From: Sandipan Das <sandipan.das@amd.com>
>>
>> From: Sandipan Das <sandipan.das@amd.com>
> 
> Duplicate "From:"s.
> 
>> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
>> new performance monitoring features for AMD processors.
> 
> Wrap changelogs closer to ~75 chars.
> 
>> Bit 0 of EAX indicates support for Performance Monitoring
>> Version 2 (PerfMonV2) features. If found to be set during
>> PMU initialization, the EBX bits of the same CPUID function
>> can be used to determine the number of available PMCs for
>> different PMU types.
>>
>> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
>> that guests can make use of the PerfMonV2 features.
>>
>> Co-developed-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> ---
>>   arch/x86/include/asm/perf_event.h |  8 ++++++++
>>   arch/x86/kvm/cpuid.c              | 32 ++++++++++++++++++++++++++++++-
>>   2 files changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index f6fc8dd51ef4..c848f504e467 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
>>   	unsigned int		full;
>>   };
>>   
>> +union cpuid_0x80000022_eax {
>> +	struct {
>> +		/* Performance Monitoring Version 2 Supported */
>> +		unsigned int	perfmon_v2:1;
>> +	} split;
>> +	unsigned int		full;
>> +};
> 
> I'm not a fan of perf's unions, but I at least understand the value added for
> CPUID entries that are a bunch of multi-bit values.  However, this leaf appears
> to be a pure features leaf.  In which case a union just makes life painful.
> 
> Please add a CPUID_8000_0022_EAX kvm_only_cpuid_leafs entry (details in link[*]
> below) so that KVM can write sane code like
> 
> 	guest_cpuid_has(X86_FEATURE_AMD_PMU_V2)
> 
> and cpuid_entry_override() instead of manually filling in information.
> 
> where appropriate.
> 
> [*] https://lore.kernel.org/all/Y1AQX3RfM+awULlE@google.com

When someone is selling syntactic sugar in the kernel space, extra attention
needs to be paid to runtime performance (union) and memory footprint 
(reverse_cpuid).

Applied for this case, while the cpuid_0x80000022_eax will be used again
in the perf core since the other new AMD PMU features are pacing at the door.

> 
>>   struct x86_pmu_capability {
>>   	int		version;
>>   	int		num_counters_gp;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 75dcf7a72605..34ba845c91b7 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>   		entry->edx = 0;
>>   		break;
>>   	case 0x80000000:
>> -		entry->eax = min(entry->eax, 0x80000021);
>> +		entry->eax = min(entry->eax, 0x80000022);
>>   		/*
>>   		 * Serializing LFENCE is reported in a multitude of ways, and
>>   		 * NullSegClearsBase is not reported in CPUID on Zen2; help
>> @@ -1203,6 +1203,36 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>   		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>   			entry->eax |= BIT(6);
>>   		break;
>> +	/* AMD Extended Performance Monitoring and Debug */
>> +	case 0x80000022: {
>> +		union cpuid_0x80000022_eax eax;
>> +		union cpuid_0x80000022_ebx ebx;
>> +
>> +		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>> +		if (!enable_pmu)
> 
> Shouldn't
> 
> 	case 0xa: { /* Architectural Performance Monitoring */
> 
> also check enable_pmu instead of X86_FEATURE_ARCH_PERFMON?

Applied as a separate patch, though KVM will have zero-padded kvm_pmu_cap to do
subsequent assignments when !enable_pmu but that doesn't hurt.

> 
>> +			break;
>> +
>> +		if (kvm_pmu_cap.version > 1) {
>> +			/* AMD PerfMon is only supported up to V2 in the KVM. */
>> +			eax.split.perfmon_v2 = 1;
> 
> With a proper CPUID_8000_0022_EAX, this becomes:
> 
> 		entry->ecx = entry->edx = 0;
> 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2)) {
> 			entry->eax = entry->ebx;
> 			break;
> 		}
> 
> 		cpuid_entry_override(entry, CPUID_8000_0022_EAX);
> 
> 		...

Then in this code block, we will have:

	/* AMD PerfMon is only supported up to V2 in the KVM. */
	entry->eax |= BIT(0);

to cover AMD Perfmon V3+, any better move ?

> 
> 		entry->ebx = ebx.full;
