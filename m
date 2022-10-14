Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03C05FEAB5
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiJNIo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 04:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJNIo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 04:44:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200672FFCD;
        Fri, 14 Oct 2022 01:44:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso7294825pjf.2;
        Fri, 14 Oct 2022 01:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hNH6YoBt3tcXnXeC+JpDK2RRJ97XnIkMQVVSD5paWSc=;
        b=j2XKkGkJutFBPNaV8FTo44sMK7ctnTAe0sd3KEU6ysVTjtWwocMLJyK5IJuuLaX9kf
         geuIoL8Upwd2OhgAzsXNQMLSTGHNEqrwTv94obYpJleBC9vng/cZopg4MbWeNsSDIJH7
         oPCR5TShBR3gNOJnWl+DIg0TLCLDMkD44ULCTWEETe80kbN1B44dOr360uuH+NBBKz1Y
         Up/bSVXLAD0bhz+/z9PNebxCh0uY2tbsKxvx+dZmj0e9OlQOeMauHUE3CjgfH/s2ObKM
         IrFjFSJA4eMLcCVIMY2lrRE3Xtu2ZE8SB0lf9ptpbSREwIkyeuQSUz6Vr+IrkE6jHKSA
         8vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hNH6YoBt3tcXnXeC+JpDK2RRJ97XnIkMQVVSD5paWSc=;
        b=WQfjWLlycn0AHJfSH/KPhSfPhYZ4UFXUV8rDLideMpykOTlsT2fdJ91itaz6SRg3gV
         cklMzH71blt0Y7F9gaDxxvJhtku/snAN8iqiPSarmQKQfFDNmxSL8DB5Cr1iaJHhBx01
         ENjtt9Qg28oZkDqk9RoyfD58j2QWKXYw2YgyBeLYKDAh9Y30Pjwh7Z/Ezjw+dBnvpNKO
         KcB4a3Tl9VspOPAgfEEMiGTG/99LYmPCBXyTLAAQqj0nXiR65V79uMRu0ykp23T5s4fK
         kUN11VY3AykftnpwOeIWq/VST4osrai0/fudpwp4RFlJu9XlusneJcgkMFnFnXf09uar
         hLrQ==
X-Gm-Message-State: ACrzQf0/Nf2Su0wFeFstVuSHWNDNHzk1QRFfg0/0Yw90C/Hktybr9FGi
        z6YOzNvLP8ZDT4HIz7d4sJs=
X-Google-Smtp-Source: AMsMyM5dINkItqbcUAq8EtcrNjLkOD7fdpnw8Gb6ct1dq67/4A03PwGhzJdAivyUQWdJEC0epO3Z/A==
X-Received: by 2002:a17:902:d2cf:b0:17f:7b65:862f with SMTP id n15-20020a170902d2cf00b0017f7b65862fmr4019424plc.168.1665737095560;
        Fri, 14 Oct 2022 01:44:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u125-20020a627983000000b005615c8a660csm1108630pfc.65.2022.10.14.01.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 01:44:54 -0700 (PDT)
Message-ID: <e1003a0c-7388-9dce-3fc2-8a1f9288e23f@gmail.com>
Date:   Fri, 14 Oct 2022 16:44:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v2 2/2] KVM: x86/pmu: Add PEBS support for SPR and future
 non-hybird models
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220922051929.89484-1-likexu@tencent.com>
 <20220922051929.89484-2-likexu@tencent.com> <Y0W/YR6gXhunJYry@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y0W/YR6gXhunJYry@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/2022 3:09 am, Sean Christopherson wrote:
> Kind of a nit, but I would prefer a shortlog that talks about the pdit/pdir
> stuff and not a "enable PEBS" bucket.
> 
> On Thu, Sep 22, 2022, Like Xu wrote:
>> @@ -140,6 +149,16 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>>   	__kvm_perf_overflow(pmc, true);
>>   }
>>   
>> +static bool need_max_precise(struct kvm_pmc *pmc)
>> +{
>> +	if (pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu))
>> +		return true;
>> +	if (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu))
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>   static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   				  u64 config, bool exclude_user,
>>   				  bool exclude_kernel, bool intr)
>> @@ -181,11 +200,11 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   		 * the accuracy of the PEBS profiling result, because the "event IP"
>>   		 * in the PEBS record is calibrated on the guest side.
>>   		 *
>> -		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
>> +		 * On Icelake everything is fine. Other hardware (TNT+) that
>>   		 * could possibly care here is unsupported and needs changes.
> 
> This part of the comment is still somewhat stale, and for me at least it's not at
> all helpful.

SPR has GLC core, and this patch adds this support and removes the unsupported 
statements.
Not sure how else I may help you.

> 
>>   		 */
>>   		attr.precise_ip = 1;
>> -		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
>> +		if (need_max_precise(pmc))
>>   			attr.precise_ip = 3;
> 
> What about writing this as:
> 
> 		attr.precise_ip = pmc_get_pebs_precision(pmc);
> 
> (or whatever name is appropriate for "pebs_precision").

The comment says, "the difference in the software precision levels of guest and
host PEBS events will not affect the accuracy of the PEBS profiling result".

> 
> Then in the helper, add comments to explaint the magic numbers and the interaction
> with PDIST and PDIR.  Bonus points if #defines for the the magic numbers can be
> added somewher

KVM just uses "precision_ip = 3" to request hw pdit/pdir counters from host perf,
It only works at 3. For 1 or 2, there is no difference.

> 
> 				 *  0 - SAMPLE_IP can have arbitrary skid
> 				 *  1 - SAMPLE_IP must have constant skid
> 				 *  2 - SAMPLE_IP requested to have 0 skid
> 				 *  3 - SAMPLE_IP must have 0 skid
> 
> static u64 pmc_get_pebs_precision(struct kvm_pmc *pmc)
> {
> 	/* Comment that explains why PDIST/PDIR require 0 skid? */
> 	if ((pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu)) ||
> 	    (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu)))
> 		return 3;
> 
> 	/* Comment about constant skid? */
> 	return 1;
> }
, therefore 0 or constant skid makes no difference.

> 
> 
>>   	}
>>   
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index c5e5dfef69c7..4dc4bbe18821 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -398,7 +398,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>   
>>   static inline bool vmx_pebs_supported(void)
>>   {
>> -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>> +	return boot_cpu_has(X86_FEATURE_PEBS) &&
>> +		!boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
> 
> This belongs in a separate patch, and it should be ordered before patch 1 so that
> there's no window where KVM can see pebs_ept==1 on a hybrid CPU.
> 
> Actually, shouldn't everything in this patch land before core enabling?

Perf core enabling about SPR is already upstreamed.
KVM support is not too late either, thanks to SPR's relentless delays.

> 
>> +		kvm_pmu_cap.pebs_ept;
> 
> Please align indentation:
> 
> 	return boot_cpu_has(X86_FEATURE_PEBS) &&
> 	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
> 	       kvm_pmu_cap.pebs_ept;
> 
